//
//  FileUtils.h
//  Reader
//
//  Created by xing on 2018/8/23.
//  Copyright © 2018年 xing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileUtils : NSObject

+ (BOOL)isValidPath:(NSString *)path;
+ (NSString *)fileTypeWithPath:(NSString *)path;
+ (NSStringEncoding)fileEncodingWithFile:(NSString *)path;

@end
