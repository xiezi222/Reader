//
//  FileLoader.m
//  Reader
//
//  Created by xing on 2018/4/28.
//  Copyright © 2018年 xing. All rights reserved.
//

#import "FileLoader.h"

static NSUInteger kStreamBlockSize = (20 * 1024);

@interface FileLoader () <NSStreamDelegate>

@property (nonatomic, copy) id block;
@property (nonatomic, strong) NSURL *url;

@property (nonatomic, strong) NSInputStream *inputStream;
@property (nonatomic, assign, getter=isLoading) BOOL loading;

@property (nonatomic, assign) NSStringEncoding encoding;

@end;

@implementation FileLoader

- (instancetype)initWithURL:(NSURL *)url
{
    self = [super init];
    if (self) {
        self.url = url;
    }
    return self;
}

- (NSInputStream *)inputStream {
    if (!_inputStream) {
        
        NSString *path = self.url.path;
        _inputStream = [[NSInputStream alloc] initWithFileAtPath:path];
        _inputStream.delegate = self;
    }
    return _inputStream;
}

- (void)loadFileUserBlock:(void (^)(NSString *content, BOOL finished))block;
{
    if (![self.url isFileURL]) {
        return;
    }
    
    if (self.isLoading) {
        return;
    }
    self.loading = YES;
    
    dispatch_queue_t queue = dispatch_queue_create("com.queue.fileLoader", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        NSRunLoop *currentRunLoop = [NSRunLoop currentRunLoop];
        [self.inputStream scheduleInRunLoop:currentRunLoop forMode:NSRunLoopCommonModes];
        [self.inputStream open];
        [currentRunLoop run];
    });
}

- (void)cancel {
    if (!self.isLoading) {
        return;
    }
    self.loading = NO;
    [self.inputStream close];
    _inputStream = nil;
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
            
            if (length) {
                
                
                NSData *data = [NSData dataWithBytes:(const void *)buffer length:length];
                NSString *string = nil;
                BOOL isLossy;
                
                NSDictionary *options = nil;
//                if (self.encoding != 0) {
//                    options = @{NSStringEncodingDetectionSuggestedEncodingsKey: @[[NSNumber numberWithUnsignedInteger:self.encoding]]};
//                }
                
                data = [@"12s我啊大xcfvghjn" dataUsingEncoding:NSUTF8StringEncoding];
                
                NSDate *date = [NSDate date];
                
                
                
                
                NSStringEncoding encoding = [NSString stringEncodingForData:data
                                                            encodingOptions:options
                                                            convertedString:&string
                                                        usedLossyConversion:&isLossy];
                
                NSLog(@"%f", [[NSDate date] timeIntervalSinceDate:date]);
                if (encoding != 0) {
                    self.encoding = encoding;
                }
                
                
//                NSLog(@"%lld", encoding);
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

@end
