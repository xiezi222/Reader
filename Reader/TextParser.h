//
//  TextParser.h
//  Reader
//
//  Created by xing on 2018/4/28.
//  Copyright © 2018年 xing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TextParser : NSObject

+ (NSStringEncoding)fileEncoding:(NSString *)filePath;
+ (NSString *)stringFromData:(NSData *)data encoding:(NSStringEncoding)encoding;

@end
