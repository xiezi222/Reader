//
//  BookHistoryTable.m
//  Reader
//
//  Created by xing on 2018/9/3.
//  Copyright © 2018年 xing. All rights reserved.
//

#import "BookHistoryTable.h"

@implementation BookHistoryTable

- (void)createTable
{
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ ('book_name' TEXT)", self.tableName];
    BOOL result = [self.db executeUpdate:sql];
    if (result) {
        NSLog(@"create table %@ success", self.tableName);
    }
}

- (void)addBook:(NSString *)bookName
{
    NSString *sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ (book_name) VALUES (?)", self.tableName];
    [self.db executeUpdate:sql, bookName];
}

- (BOOL)hasParsered:(NSString *)bookName
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE book_name=?", self.tableName];
    FMResultSet *res = [self.db executeQuery:sql, bookName];
    if ([res next]) {
        NSString *name = [res stringForColumn:@"book_name"];
        return name.length;
    }
    return NO;
}

@end
