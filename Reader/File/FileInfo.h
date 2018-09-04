//
//  FileInfo.h
//  Reader
//
//  Created by xing on 2018/8/23.
//  Copyright © 2018年 xing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileInfo : NSObject

+ (NSString *)fileTypeFromPath:(NSString *)filePath;
+ (NSStringEncoding)encodingForTextFile:(NSString *)filePath;

@end
