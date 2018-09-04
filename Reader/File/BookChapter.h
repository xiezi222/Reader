//
//  BookChapter.h
//  Reader
//
//  Created by xing on 2018/8/28.
//  Copyright © 2018年 xing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookChapter : NSObject

@property (nonatomic, strong) NSString *bookName;
@property (nonatomic, assign) NSInteger chapterIndex;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *content;

@end
