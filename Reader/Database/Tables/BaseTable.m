//
//  BaseTable.m
//  Reader
//
//  Created by xing on 2018/9/1.
//  Copyright © 2018年 xing. All rights reserved.
//

#import "BaseTable.h"

@interface BaseTable ()

@property (nonatomic, strong, readwrite) FMDatabase *db;
@property (nonatomic, strong, readwrite) NSString *tableName;

@end

@implementation BaseTable

+ (instancetype)createTableWithName:(NSString *)tableName database:(FMDatabase *)db
{
    NSString *className = NSStringFromClass([self class]);
    Class c = NSClassFromString(className);
    BaseTable *table = [[c alloc] init];
    table.db = db;
    table.tableName = [tableName stringByDeletingPathExtension];

    [table createTable];
    return table;
}

- (void)createTable
{
}

- (void)deleteAllRows
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@", self.tableName];
    [self.db executeUpdate:sql];
}

@end
