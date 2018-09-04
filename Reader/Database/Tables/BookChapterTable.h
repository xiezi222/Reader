//
//  BookChapterTable.h
//  Reader
//
//  Created by xing on 2018/9/1.
//  Copyright © 2018年 xing. All rights reserved.
//

#import "BaseTable.h"
#import "BookChapter.h"

@interface BookChapterTable : BaseTable

- (void)addChapter:(BookChapter *)chapter;
- (BookChapter *)readLastChapter:(NSString *)bookName;
- (BookChapter *)readChapterAtIndex:(NSInteger)index;
- (NSArray *)allChapterNames;

@end
