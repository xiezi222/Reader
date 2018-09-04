//
//  DatabaseManager.m
//  Reader
//
//  Created by xing on 2018/9/1.
//  Copyright © 2018年 xing. All rights reserved.
//

#import "DatabaseManager.h"
#import "BookChapterTable.h"
#import "BookHistoryTable.h"

NSString *kChapterTableName = @"book_chapter";
NSString *kHistoryTableName = @"book_history";

@interface DatabaseManager ()

@property (nonatomic, strong) FMDatabase *db;
@property (nonatomic, strong) BookChapterTable *chapterTable;
@property (nonatomic, strong) BookHistoryTable *historyTable;

@end

@implementation DatabaseManager

- (void)dealloc
{
    [self.db close];
}

+ (instancetype)sharedManager
{
    static DatabaseManager *_manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[DatabaseManager alloc] init];
    });
    return _manager;
}

- (void)createDB
{
    NSString *libPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0];

    NSString *dbPath = [libPath stringByAppendingPathComponent:@"Database"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dbPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:dbPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    dbPath = [dbPath stringByAppendingPathComponent:@"Reader.db"];
    NSLog(@"dbPath = %@",dbPath);
    self.db = [FMDatabase databaseWithPath:dbPath];
    [self.db open];
    if (![self.db open]) {
        NSLog(@"db open fail");
    }

    [self createTables];
}

- (void)createTables
{
    self.chapterTable = [BookChapterTable createTableWithName:kChapterTableName database:self.db];
    self.historyTable = [BookHistoryTable createTableWithName:kHistoryTableName database:self.db];
}

- (BOOL)beginTransaction
{
    return [self.db beginTransaction];
}

- (BOOL)commit
{
    return [self.db commit];
}

- (void)addChapter:(BookChapter *)chapter
{
    [self.chapterTable addChapter:chapter];
}

- (BookChapter *)readLastChapter:(NSString *)bookName
{
    return [self.chapterTable readLastChapter:bookName];
}

- (BookChapter *)readChapterAtChapter:(NSInteger)index
{
    return [self.chapterTable readChapterAtIndex:index];
}

- (void)deleteAllHistory
{
    [self.chapterTable deleteAllRows];
    [self.historyTable deleteAllRows];
}

- (void)addBookHistory:(NSString *)bookName
{
    [self.historyTable addBook:bookName];
}

- (BOOL)hasParsered:(NSString *)bookName
{
    return [self.historyTable hasParsered:bookName];
}


@end
