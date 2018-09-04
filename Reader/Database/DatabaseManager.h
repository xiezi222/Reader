//
//  DatabaseManager.h
//  Reader
//
//  Created by xing on 2018/9/1.
//  Copyright © 2018年 xing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BookChapter.h"

@interface DatabaseManager : NSObject

+ (instancetype)sharedManager;

- (void)createDB;

- (BOOL)beginTransaction;
- (BOOL)commit;

- (void)addChapter:(BookChapter *)chapter;
- (BookChapter *)readLastChapter:(NSString *)bookName;
- (BookChapter *)readChapterAtChapter:(NSInteger)index;

- (void)addBookHistory:(NSString *)bookName;
- (BOOL)hasParsered:(NSString *)bookName;

- (void)deleteAllHistory;

@end
