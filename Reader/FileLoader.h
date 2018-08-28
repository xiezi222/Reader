//
//  FileLoader.h
//  Reader
//
//  Created by xing on 2018/4/28.
//  Copyright © 2018年 xing. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FileLoaderDelegate <NSObject>

- (void)fileLoaderDidLoadString:(NSString *)string;

@end

@interface FileLoader : NSObject

- (instancetype)initWithPath:(NSString *)path;

- (void)load;
- (void)cancel;

@end
