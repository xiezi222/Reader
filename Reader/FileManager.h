//
//  FileManager.h
//  Reader
//
//  Created by xing on 2018/8/24.
//  Copyright © 2018年 xing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileManager : NSObject

+ (instancetype)sharedManager;

- (NSArray *)allFiles;

@end
