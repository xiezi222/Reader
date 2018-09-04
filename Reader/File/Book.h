//
//  Book.h
//  Reader
//
//  Created by xing on 2018/8/28.
//  Copyright © 2018年 xing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BookChapter.h"

typedef void (^BookPrepared)(BOOL completed);

@interface Book : NSObject

@property (nonatomic, strong, readonly) NSString *bookName;
@property (nonatomic, strong, readonly) NSArray *chapterNames;
@property (nonatomic, assign) NSInteger currentChapterIndex;

- (instancetype)initWithPath:(NSString *)path;

- (void)prepareToRead:(BookPrepared) prepared;
- (BookChapter *)getChapterAtIndex:(NSInteger)index;

@end
