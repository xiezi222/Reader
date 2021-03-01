//
//  FileUtils.m
//  Reader
//
//  Created by xing on 2018/8/23.
//  Copyright © 2018年 xing. All rights reserved.
//
/**
 二进制文件和文本文件的区别
 二进制文件： 值编码 一般不可直接读
 文本文件： 字符编码 一般可以直接读
 所以文本文件与二进制文件的区别并不是物理上的，而是逻辑上的。这两者只是在编码层次上有差异
 将文件看作是由一个一个字节(byte) 组成的， 那么文本文件中的每个字节的最高位都是0，
 也就是说文本文件使用了一个字节中的七位来表示所有的信息，
 而二进制文件则是将字节中的所有位都用上了。

 1. txt默认的选项是ANSI，即GBK编码
 2. txt文本文档有四种编码选项：ANSI、Unicode、Unicode big endian、UTF-8
 3. 因此我们读取txt文件可能有时候并不知道其编码格式，所以需要用程序动态判断获取txt文件编码
 ANSI： 无格式定义
 Unicode：  前两个字节为FFFE Unicode文档以0xFFFE开头
 Unicode big endian： 前两字节为FEFF
 UTF-8： 前两字节为EFBB UTF-8以0xEFBBBF开头

*/


#import "FileUtils.h"
#import "uchardet.h"

@implementation FileUtils

+ (NSDictionary *)fileTypeMap
{
    return @{
             @"FFD8FF":                          @"jpg",     //JPEG (jpg)
             @"89504E47":                        @"png",     //PNG (png)
             @"47494638":                        @"gif",     //GIF (gif)
             @"49492A00":                        @"tif",     //TIFF (tif)
             @"424D":                            @"bmp",     //Windows Bitmap (bmp)
             @"41433130":                        @"dwg",     //CAD (dwg)
             @"68746D6C3E":                      @"html",    //HTML (html)
             @"7B5C727466":                      @"rtf",     //Rich Text Format (rtf)
             @"3C3F786D6C":                      @"xml",
             @"504B0304":                        @"zip",
             @"52617221":                        @"rar",
             @"38425053":                        @"psd",     //Photoshop (psd)
             @"44656C69766572792D646174653A":    @"eml",     //Email [thorough only] (eml)
             @"CFAD12FEC5FD746F":                @"dbx",     //Outlook Express (dbx)
             @"2142444E":                        @"pst",     //Outlook (pst)
             @"D0CF11E0":                        @"xls",     //MS Word
             @"D0CF11E0":                        @"doc",     //MS Excel 注意：word 和 excel的文件头一样
             @"5374616E64617264204A":            @"mdb",     //MS Access (mdb)
             @"FF575043":                        @"wpd",     //WordPerfect (wpd)
             @"252150532D41646F6265":            @"eps",
             @"252150532D41646F6265":            @"ps",
             @"255044462D312E":                  @"pdf",     //Adobe Acrobat (pdf)
             @"AC9EBD8F":                        @"qdf",     //Quicken (qdf)
             @"E3828596":                        @"pwl",     //Windows Password (pwl)
             @"57415645":                        @"wav",     //Wave (wav)
             @"41564920":                        @"avi",
             @"2E7261FD":                        @"ram",     //Real Audio (ram)
             @"2E524D46":                        @"rm",      //Real Media (rm)
             @"000001BA":                        @"mpg",     //
             @"6D6F6F76":                        @"mov",     //Quicktime (mov)
             @"3026B2758E66CF11":                @"asf",     //Windows Media (asf)
             @"4D546864":                        @"mid",     //MIDI (mid)
             };
}

+ (BOOL)isValidPath:(NSString *)path {
    BOOL isDirectory = NO;
    if (![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory] || isDirectory) {
        return NO;
    }
    return YES;
}

+ (NSString *)fileTypeWithPath:(NSString *)path {
    
    if (![FileUtils isValidPath:path]) return nil;
    
    NSString *extension = [path pathExtension];
    if (extension.length) return extension;
    
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:path];
    [handle seekToFileOffset:0];
    NSData *headData = [handle readDataOfLength:32];
    [handle closeFile];

    Byte *bytes = (Byte *)headData.bytes;
    NSString *fileHeader = @"";
    for (int i = 0; i < [headData length]; i++) {
        NSString *s = [[NSString alloc] initWithFormat:@"%02hhx", bytes[i]];
        fileHeader = [fileHeader stringByAppendingString:s];
    }

    NSDictionary *fileTypeMap = [FileUtils fileTypeMap];
    fileHeader = [fileHeader uppercaseString];

    for (NSString *key in fileTypeMap.allKeys) {
        if ([fileHeader hasPrefix:key]) {
            return [fileTypeMap objectForKey:key];
        }
    }
    return nil;
}

+ (NSStringEncoding)fileEncodingWithFile:(NSString *)path {
    
    if (![FileUtils isValidPath:path]) return 0;

    char buf[2048];
    CFStringEncoding cfEncode = 0;

    FILE *file = fopen([path UTF8String], "rt");
    if (file==NULL) return cfEncode;

    size_t len = fread(buf, sizeof(char), 2048, file);
    fclose(file);

    uchardet_t ud = uchardet_new();
    if(uchardet_handle_data(ud, buf, len) != 0) {
        return cfEncode;
    }
    uchardet_data_end(ud);

    const char *e = uchardet_get_charset(ud);
    NSString *encodeStr = [[NSString stringWithUTF8String:e] lowercaseString];
    if ([encodeStr isEqualToString:@"gb18030"]) {

        cfEncode = kCFStringEncodingGB_18030_2000;

    } else if([encodeStr isEqualToString:@"ascii"]){

            //convert to high level
        cfEncode = CFStringConvertNSStringEncodingToEncoding(0x80000632);

    } else if([encodeStr isEqualToString:@"big5"]){

        cfEncode = kCFStringEncodingBig5;

    } else if([encodeStr isEqualToString:@"utf-8"]){

            //convert to high level
        cfEncode = kCFStringEncodingUTF8;

    } else if([encodeStr isEqualToString:@"shift_jis"]){

        cfEncode = kCFStringEncodingShiftJIS;

    } else if([encodeStr isEqualToString:@"windows-1252"]){

            //convert to high level
        cfEncode =  CFStringConvertNSStringEncodingToEncoding(0x80000632);

    } else if([encodeStr isEqualToString:@"x-euc-tw"]){

        cfEncode = kCFStringEncodingEUC_TW;

    } else if([encodeStr isEqualToString:@"euc-kr"]){

        cfEncode = kCFStringEncodingEUC_KR;

    } else if([encodeStr isEqualToString:@"euc-jp"]){

        cfEncode = kCFStringEncodingEUC_JP;

    } else if([encodeStr isEqualToString:@"utf-16"]){

        cfEncode = kCFStringEncodingUTF16;

    } else if ([encodeStr isEqualToString:@"utf-32"]) {

        cfEncode = kCFStringEncodingUTF32;
    }

    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(cfEncode);
    uchardet_delete(ud);

    if (cfEncode == 0 || (cfEncode == kCFStringEncodingUTF8 && len <= 64)) {

        //txt分带编码和不带编码两种，带编码的如UTF-8格式txt，不带编码的如ANSI格式txt
        //不带的，可以依次尝试GBK和GB18030编码
        NSData *data = [NSData dataWithBytes:buf length:len];
        enc = [FileUtils otherEncoding:data];
    }
    return enc;
}

+ (NSStringEncoding)otherEncoding:(NSData *)data {

    NSStringEncoding enc = NSUTF8StringEncoding;
    NSString *s = [[NSString alloc] initWithData:data encoding:enc];

    if (s.length <= 0) {
        enc = 0x80000631;
        s = [[NSString alloc] initWithData:data encoding:enc];
    }

    if (s.length <= 0) {
        enc = 0x80000632;
        s = [[NSString alloc] initWithData:data encoding:enc];
    }

    if (s.length <= 0) {
        if (data.length <= 0) {
            return 0;
        }
        return [self otherEncoding:[data subdataWithRange:NSMakeRange(0, data.length-1)]];
    }
    return enc;
}


@end
