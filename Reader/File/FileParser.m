//
//  FileParser.m
//  Reader
//
//  Created by xing on 2018/4/28.
//  Copyright © 2018年 xing. All rights reserved.
//

#import "FileParser.h"
#import "FileInfo.h"
#import "Book.h"
#import "DatabaseManager.h"

static NSUInteger kStreamBlockSize = (20 * 1024);
NSNotificationName const kFileParserFinishedNotification = @"kFileParserFinishedNotification";


@interface FileParser () <NSStreamDelegate>

@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) NSInputStream *inputStream;
@property (nonatomic, assign) NSStringEncoding encoding;

@property (nonatomic, strong) NSMutableData *surplusData;
@property (nonatomic, strong) NSRegularExpression *regular;
@property (nonatomic, strong) NSString *bookName;

@end;

@implementation FileParser

- (void)dealloc
{
    NSLog(@"FileLoader dealloc");
}

- (instancetype)initWithPath:(NSString *)path
{
    self = [super init];
    if (self) {
        self.path = path;
        self.bookName = path.lastPathComponent;
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

- (void)readDataFinished
{
    [[DatabaseManager sharedManager] addBookHistory:self.bookName];
    [self performSelector:@selector(cancel)];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kFileParserFinishedNotification object:nil];
    });
}

- (void)cancel {
    [_inputStream close];
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
            [self readDataFinished];
        }
            break;
        default:
            break;
    }
}

- (void)stringEncodingForData:(NSData *)data surplusLegth:(NSInteger)length
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
            return;
        }
        [self stringEncodingForData:data surplusLegth:length + 1];
        return;
    }
    NSLog(@"解析成功");
    //这次解析多出来的字节，存贮起来，下次用
    if (length) {
        NSInteger location = data.length -length;
        NSRange range = NSMakeRange(location, length);
        self.surplusData = [[NSMutableData alloc] initWithData:[data subdataWithRange:range]];// dataWithData:];
    }

    [self extractForChapter:string];
    return;
}

- (NSRegularExpression *)regular
{
    if (!_regular) {
        NSString *pattern = @"第[0-9一二三四五六七八九十百千]*[章回].*";
        NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
        _regular = regular;
    }
    return _regular;
}

- (void)extractForChapter:(NSString *)string
{
    NSArray *results = [self.regular matchesInString:string
                                             options:NSMatchingReportCompletion
                                               range:NSMakeRange(0, string.length)];

    DatabaseManager *manager = [DatabaseManager sharedManager];
    BookChapter *lastChapter = [manager readLastChapter:self.bookName];

    if (results.count == 0) {

        if (lastChapter == nil) {
            lastChapter = [[BookChapter alloc] init];
            lastChapter.bookName = self.bookName;
            lastChapter.chapterIndex = 1;
            lastChapter.name = @"全文";
            lastChapter.content = @"";
        }

        lastChapter.content = [lastChapter.content stringByAppendingString:string];
        [manager addChapter:lastChapter];
        return;
    }

    [manager beginTransaction];

    NSTextCheckingResult *firstResult =[results objectAtIndex:0];
    NSInteger newIndex = lastChapter.chapterIndex;

    if (firstResult.range.location != 0) {

        if (lastChapter == nil) {
            //前言
            BookChapter *chapter = [[BookChapter alloc] init];
            chapter.bookName = self.bookName;
            chapter.chapterIndex = 1;
            chapter.name = @"前言";
            chapter.content = [string substringToIndex:firstResult.range.location];;
            [manager addChapter:chapter];
            NSLog(@"章节：%@", chapter.name);
            newIndex = 1;
            
        } else {
            //上次解析的最后一章还没完结
            NSString *subString = [string substringToIndex:firstResult.range.location];
            lastChapter.content = [lastChapter.content stringByAppendingString:subString];
            [manager addChapter:lastChapter];
        }
    }

    for (int i = 0; i < results.count; i++) {

        NSRange currentRange = ((NSTextCheckingResult *)[results objectAtIndex:i]).range;

        BookChapter *chapter = [[BookChapter alloc] init];
        chapter.bookName = self.bookName;
        chapter.chapterIndex = newIndex + i + 1;
        chapter.name = [string substringWithRange:currentRange];

        if (i == results.count -1) { //这次解析string最后一章

            chapter.content = [string substringFromIndex:currentRange.location];

        } else { //这次解析string的中间章节

            NSTextCheckingResult *nextResult = [results objectAtIndex:i+1];
            NSRange nextRange = nextResult.range;

            NSRange range = NSMakeRange(currentRange.location, nextRange.location - currentRange.location);
            chapter.content = [string substringWithRange:range];
        }

        NSLog(@"章节：%@", chapter.name);
        [manager addChapter:chapter];
    }
    [manager commit];
}

@end
