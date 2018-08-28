//
//  FileLoader.m
//  Reader
//
//  Created by xing on 2018/4/28.
//  Copyright © 2018年 xing. All rights reserved.
//

#import "FileLoader.h"
#import "FileInfo.h"

static NSUInteger kStreamBlockSize = (20 * 1024);

@interface FileLoader () <NSStreamDelegate>

@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) NSInputStream *inputStream;
@property (nonatomic, assign) NSStringEncoding encoding;

@property (nonatomic, strong) NSMutableData *surplusData;

@end;

@implementation FileLoader

- (instancetype)initWithPath:(NSString *)path
{
    self = [super init];
    if (self) {
        self.path = path;
    }
    return self;
}

- (NSInputStream *)inputStream
{
    if (!_inputStream) {
        _inputStream = [[NSInputStream alloc] initWithFileAtPath:self.path];
        _inputStream.delegate = self;
    }
    return _inputStream;
}

- (void)load
{
    dispatch_queue_t queue = dispatch_queue_create("com.queue.fileLoader", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{

        self.encoding = [FileInfo encodingForTextFile:self.path];
        if (self.encoding == 0) {
            return;
        }

        NSRunLoop *currentRunLoop = [NSRunLoop currentRunLoop];
        [self.inputStream scheduleInRunLoop:currentRunLoop forMode:NSRunLoopCommonModes];
        [self.inputStream open];
        [currentRunLoop run];
    });
}

- (void)cancel {
    [self.inputStream close];
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
    
    switch (eventCode) {
        case NSStreamEventOpenCompleted:
            break;
        case NSStreamEventHasBytesAvailable:
        {
            uint8_t buffer[kStreamBlockSize];
            NSUInteger length = 0;
            length = [self.inputStream read:buffer maxLength:kStreamBlockSize];
            
            if (length != 0) {
                NSData *data = [NSData dataWithBytes:(const void *)buffer length:length];
                [self stringEncodingForData:data surplusLegth:0];
            }
        }
            break;
        case NSStreamEventEndEncountered:
        {
            [self cancel];
        }
            break;
        default:
            break;
    }
}

- (NSString *)stringEncodingForData:(NSData *)data surplusLegth:(NSInteger)length
{
    //加载上次解析多出的data
    if (self.surplusData.length) {
        [self.surplusData appendData:data];
        data = self.surplusData;
        self.surplusData = nil;
    }

    //这次解析要用的data
    NSData *subData = [data subdataWithRange:NSMakeRange(0, data.length -length)];

    NSString *string = [[NSString alloc] initWithData:subData encoding:self.encoding];
    if (string == nil) { //解析失败，重新计算data

        if (length >= 4) {//多次解析无果，放弃
            NSLog(@"多次解析无果，放弃");
            self.surplusData = nil;
            return @"";
        }
        return [self stringEncodingForData:data surplusLegth:length + 1];
    }
    if (length) {
        NSInteger location = data.length -length;
        NSRange range = NSMakeRange(location, length);
        self.surplusData = [NSMutableData dataWithData:[data subdataWithRange:range]];
    }
    return string;
}

@end
