//
//  TextFileManager.m
//  Reader
//
//  Created by xing on 2018/4/28.
//  Copyright © 2018年 xing. All rights reserved.
//

#import "TextFileManager.h"
#import "FileLoader.h"

@interface TextFileManager ()

@property (nonatomic, strong) NSURL *url;

@end

@implementation TextFileManager

- (instancetype)initWithURL:(NSURL *)url
{
    self = [super init];
    if (self) {
        self.url = url;
    }
    return self;
}

@end
