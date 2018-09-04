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
    NSString *path = [[NSBundle mainBundle] pathForResource:@"最强特种兵之龙刺" ofType:@"txt"];
    NSData *data = [NSData dataWithContentsOfFile:path];


    NSString *documentPath = [FileManager documentPath];

    [data writeToFile:[documentPath stringByAppendingPathComponent:@"最强特种兵之龙刺.txt"] atomically:YES];



    NSError *error;
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentPath error:&error];

    if (error) {
        NSLog(@"%s_%@", __FUNCTION__, error);
    }

    NSMutableArray *paths = [NSMutableArray arrayWithCapacity:0];
    for (NSString *item in contents) {
        NSString *path = [documentPath stringByAppendingPathComponent:item];
        [paths addObject:path];
    }
    return paths;
}



@end
