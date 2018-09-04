//
//  BaseTable.h
//  Reader
//
//  Created by xing on 2018/9/1.
//  Copyright © 2018年 xing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>

@interface BaseTable : NSObject

@property (nonatomic, strong, readonly) FMDatabase *db;
@property (nonatomic, strong, readonly) NSString *tableName;

+ (instancetype)createTableWithName:(NSString *)tableName database:(FMDatabase *)db;
- (void)createTable;
- (void)deleteAllRows;

@end
