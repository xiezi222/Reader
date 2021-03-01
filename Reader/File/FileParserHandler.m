//
//  FileParserHandler.m
//  Reader
//
//  Created by xing on 2020/11/18.
//  Copyright © 2020 xing. All rights reserved.
//

#import "FileParserHandler.h"

@implementation FileParserHandler

+ (void)parserFileWithPath:(NSString *)path {
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isDirectory = NO;
    if (![manager fileExistsAtPath:path isDirectory:&isDirectory] || isDirectory) {
        return;
    }
    
    
    
    
}

@end
