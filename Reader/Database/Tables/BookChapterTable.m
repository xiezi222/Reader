//
//  BookChapterTable.m
//  Reader
//
//  Created by xing on 2018/9/1.
//  Copyright © 2018年 xing. All rights reserved.
//

#import "BookChapterTable.h"

@implementation BookChapterTable

- (void)createTable
{
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ ('book_name' TEXT, 'chapter' INTEGER, 'name' TEXT, 'content' TEXT, primary key(book_name, chapter))", self.tableName];
    BOOL result = [self.db executeUpdate:sql];
    if (result) {
        NSLog(@"create table %@ success", self.tableName);
    }
}

- (void)addChapter:(BookChapter *)chapter
{
    NSString *sql = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ (book_name, chapter, name, content) VALUES (?,?,?,?)", self.tableName];
    [self.db executeUpdate:sql, chapter.bookName, @(chapter.chapterIndex), chapter.name, chapter.content];
}

- (BookChapter *)readLastChapter:(NSString *)bookName
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE book_name='%@' ORDER BY chapter DESC LIMIT 1", self.tableName, bookName];
    FMResultSet *res = [self.db executeQuery:sql];

    if ([res next]) {

        BookChapter *chapter = [[BookChapter alloc] init];
        chapter.bookName = [res stringForColumn:@"book_name"];
        chapter.chapterIndex = [res intForColumn:@"chapter"];
        chapter.name = [res stringForColumn:@"name"];
        chapter.content = [res stringForColumn:@"content"];
        return chapter.bookName.length ? chapter : nil;
    }
    return nil;
}

- (BookChapter *)readChapterAtIndex:(NSInteger)index
{
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE chapter=?", self.tableName];
    FMResultSet *res = [self.db executeQuery: sql, @(index + 1)];

    if ([res next]) {
        BookChapter *chapter = [[BookChapter alloc] init];
        chapter.bookName = [res stringForColumn:@"book_name"];
        chapter.chapterIndex = [res intForColumn:@"chapter"];
        chapter.name = [res stringForColumn:@"name"];
        chapter.content = [res stringForColumn:@"content"];
        return chapter;
    }
    return nil;
}

- (NSArray *)allChapterNames
{
    NSString *sql = [NSString stringWithFormat:@"SELECT name FROM %@ ORDER BY chapter ASC", self.tableName];
    FMResultSet *res = [self.db executeQuery: sql];

    NSMutableArray  *names = [NSMutableArray arrayWithCapacity:0];

    if ([res next]) {
        NSString *name = [res stringForColumn:@"name"];
        [names addObject:name];
    }
    return names;
}

@end
