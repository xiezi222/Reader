//
//  FileManager.m
//  Reader
//
//  Created by xing on 2018/8/24.
//  Copyright © 2018年 xing. All rights reserved.
//

#import "FileManager.h"

@implementation FileManager

+ (instancetype)sharedManager
{
    static FileManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[FileManager alloc] init];
    });
    return _manager;
}

+ (NSString *)documentPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (NSArray *)allOriginalFilePaths {
    
    NSMutableArray *filePaths = [[NSMutableArray alloc] init];
    
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSError *error;
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *paths = [manager contentsOfDirectoryAtPath:documentPath error:&error];
    
    
    for (NSString *path in paths) {
        if ([path hasPrefix:@"."]) continue;
        
        BOOL isDirectory = NO;
        NSString *subPath = [documentPath stringByAppendingPathComponent:path];
        if ([manager fileExistsAtPath:subPath isDirectory:&isDirectory] && !isDirectory) {
            [filePaths addObject:subPath];
        }
    }
    return filePaths;
}

- (void)loadFileWithPath:(NSString *)path complection:(void (^)())complection {
    
}

@end
