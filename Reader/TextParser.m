//
//  TextParser.m
//  Reader
//
//  Created by xing on 2018/4/28.
//  Copyright © 2018年 xing. All rights reserved.
//

#import "TextParser.h"
#include "uchardet.h"

@implementation TextParser

//+ (NSStringEncoding)textDatasEncoding:(const char *)filePath {
//    NSFileManager
//    CFStringEncoding cfEncode = 0;
//    FILE* file;
//    char buf[2048];
//    size_t len;
//    uchardet_t ud;
//    file = fopen(filePath, "rt");
//    if (file==NULL) {
//        return cfEncode;
//    }
//    len = fread(buf, sizeof(char), 2048, file);
//    fclose(file);
//
//    ud = uchardet_new();
//    if(uchardet_handle_data(ud, buf, len) != 0) {
//        return cfEncode;
//    }
//    uchardet_data_end(ud);
//    const char *e = uchardet_get_charset(ud);
//    NSString *encodeStr = [[NSString stringWithUTF8String:e] lowercaseString];
//    if ([encodeStr isEqualToString:@"gb18030"]) {
//
//        cfEncode = kCFStringEncodingGB_18030_2000;
//
//    } else if([encodeStr isEqualToString:@"ascii"]){
//
//        //convert to high level
//        cfEncode = CFStringConvertNSStringEncodingToEncoding(0x80000632);
//
//    } else if([encodeStr isEqualToString:@"big5"]){
//
//        cfEncode = kCFStringEncodingBig5;
//
//    } else if([encodeStr isEqualToString:@"utf-8"]){
//
//        //convert to high level
//        cfEncode = kCFStringEncodingUTF8;
//
//    } else if([encodeStr isEqualToString:@"shift_jis"]){
//
//        cfEncode = kCFStringEncodingShiftJIS;
//
//    } else if([encodeStr isEqualToString:@"windows-1252"]){
//
//        //convert to high level
//        cfEncode =  CFStringConvertNSStringEncodingToEncoding(0x80000632);
//
//    } else if([encodeStr isEqualToString:@"x-euc-tw"]){
//
//        cfEncode = kCFStringEncodingEUC_TW;
//
//    } else if([encodeStr isEqualToString:@"euc-kr"]){
//
//        cfEncode = kCFStringEncodingEUC_KR;
//
//    } else if([encodeStr isEqualToString:@"euc-jp"]){
//
//        cfEncode = kCFStringEncodingEUC_JP;
//
//    } else if([encodeStr isEqualToString:@"utf-16"]){
//
//        cfEncode = kCFStringEncodingUTF16;
//
//    } else if ([encodeStr isEqualToString:@"utf-32"]) {
//
//        cfEncode = kCFStringEncodingUTF32;
//
//    }
//
//    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(cfEncode);
//    uchardet_delete(ud);
//
//
//    if (cfEncode == 0 || (cfEncode == kCFStringEncodingUTF8 && len <= 64)) {
//
//        NSData *data = [NSData dataWithBytes:buf length:len];
//        enc = [self otherEncoding:data];
//
//    }
//
//    return enc;
//}
//
//+ (NSStringEncoding)otherEncoding:(NSData *)data {
//
//    NSStringEncoding enc = NSUTF8StringEncoding;
//    NSString *s = [[NSString alloc] initWithData:data encoding:enc];
//
//    if (s.length <= 0) {
//        enc = 0x80000631;
//        s = [[NSString alloc] initWithData:data encoding:enc];
//    }
//
//    if (s.length <= 0) {
//        enc = 0x80000632;
//        s = [[NSString alloc] initWithData:data encoding:enc];
//    }
//
//    if (s.length <= 0) {
//        if (data.length <= 0 || self.safeLength == 10) {
//            self.safeLength = 0;
//            return 0;
//        }
//        self.safeLength++;
//        return [self otherEncoding:[data subdataWithRange:NSMakeRange(0, data.length-1)]];
//    }
//
//    return enc;
//}
//
//+ (NSStringEncoding)fileEncoding:(NSString *)filePath
//{
//    NSStringEncoding encoding = [TextParser textDatasEncoding:[filePath UTF8String]];
//    if (encoding == 0) {
//        encoding = NSUTF8StringEncoding;
//    }
//    return encoding;
//}
//
//+ (NSString *)stringFromData:(NSData *)data encoding:(NSStringEncoding)encoding
//{
//
//}

@end
