//
//  BookChapter.m
//  Reader
//
//  Created by xing on 2018/8/28.
//  Copyright © 2018年 xing. All rights reserved.
//

#import "BookChapter.h"
#import <objc/runtime.h>

@implementation BookChapter

//- (void)encodeWithCoder:(NSCoder *)encoder
//{
//    unsigned int count = 0;
//    Ivar *ivars = class_copyIvarList([BookChapter class], &count);
//
//    for (int i = 0; i<count; i++) {
//            // 取出i位置对应的成员变量
//        Ivar ivar = ivars[i];
//            // 查看成员变量
//        const char *name = ivar_getName(ivar);
//            // 归档
//        NSString *key = [NSString stringWithUTF8String:name];
//        id value = [self valueForKey:key];
//        [encoder encodeObject:value forKey:key];
//    }
//    free(ivars);
//}
//
//- (id)initWithCoder:(NSCoder *)decoder
//{
//    if (self = [super init]) {
//        unsigned int count = 0;
//        Ivar *ivars = class_copyIvarList([BookChapter class], &count);
//        for (int i = 0; i<count; i++) {
//                // 取出i位置对应的成员变量
//            Ivar ivar = ivars[i];
//                // 查看成员变量
//            const char *name = ivar_getName(ivar);
//                // 归档
//            NSString *key = [NSString stringWithUTF8String:name];
//            id value = [decoder decodeObjectForKey:key];
//                // 设置到成员变量身上
//            [self setValue:value forKey:key];
//
//        }
//        free(ivars);
//    }
//    return self;
//}


@end
