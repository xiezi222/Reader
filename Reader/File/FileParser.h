//
//  FileParser.h
//  Reader
//
//  Created by xing on 2018/4/28.
//  Copyright © 2018年 xing. All rights reserved.
//

#import <Foundation/Foundation.h>

UIKIT_EXTERN NSNotificationName const kFileParserFinishedNotification;

@protocol FileLoaderDelegate <NSObject>

- (void)fileLoaderDidLoadString:(NSString *)string;

@end

@interface FileParser : NSObject

- (instancetype)initWithPath:(NSString *)path;

- (void)load;
- (void)cancel;

@end
