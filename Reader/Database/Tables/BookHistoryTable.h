//
//  BookHistoryTable.h
//  Reader
//
//  Created by xing on 2018/9/3.
//  Copyright © 2018年 xing. All rights reserved.
//

#import "BaseTable.h"

@interface BookHistoryTable : BaseTable

- (void)addBook:(NSString *)bookName;
- (BOOL)hasParsered:(NSString *)bookName;

@end
