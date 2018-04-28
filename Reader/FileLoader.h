//
//  FileLoader.h
//  Reader
//
//  Created by xing on 2018/4/28.
//  Copyright © 2018年 xing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileLoader : NSObject

- (instancetype)initWithURL:(NSURL *)url;

- (void)loadFileUserBlock:(void (^)(NSString *content, BOOL finished))block;
- (void)cancel;

@end
