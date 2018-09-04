//
//  Book.m
//  Reader
//
//  Created by xing on 2018/8/28.
//  Copyright © 2018年 xing. All rights reserved.
//

#import "Book.h"
#import "FileParser.h"
#import "DatabaseManager.h"

@interface Book ()

@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong, readwrite) NSString *bookName;
@property (nonatomic, strong, readwrite) NSMutableArray *chapterNames;
@property (nonatomic, copy) BookPrepared prepared;
@property (nonatomic, strong) FileParser *parser;

@end

@implementation Book

- (instancetype)initWithPath:(NSString *)path
{
    self = [super init];
    if (self) {
        self.path = path;
        self.bookName = [path lastPathComponent];
        _chapterNames = [NSMutableArray arrayWithCapacity:0];
        _currentChapterIndex = 1;
    }
    return self;
}

- (void)prepareToRead:(BookPrepared)prepared
{
    DatabaseManager *manager = [DatabaseManager sharedManager];
    if ([manager hasParsered:self.bookName]) {
        if (prepared) {
            prepared(YES);
        }
    } else {
        self.prepared = prepared;

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fileLoadFinished:) name:kFileParserFinishedNotification object:nil];
        self.parser = [[FileParser alloc] initWithPath:self.path];
        [self.parser load];
    }
}

- (void)fileLoadFinished:(id)sender
{
    if (self.prepared) {
        self.prepared(YES);
    }
}

- (BookChapter *)getChapterAtIndex:(NSInteger)index
{
    return [[DatabaseManager sharedManager] readChapterAtChapter:index];
}

@end
