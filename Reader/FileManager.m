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

- (NSArray *)allFiles
{
    NSString *docuPath = [FileManager documentPath];

//    NSString *path = [[NSBundle mainBundle] pathForResource:@"a" ofType:@"txt"];
//    NSData *data = [NSData dataWithContentsOfFile:path];
//    [data writeToFile:[docuPath stringByAppendingPathComponent:@"a.txt"] atomically:YES];

    NSError *error;
        // 获取指定路径对应文件夹下的所有文件
    NSArray <NSString *> *fileArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:docuPath error:&error];
    NSLog(@"%s_%@", __FUNCTION__, error);
    return fileArray;
}



@end
