//
//  ChapterViewController.m
//  Reader
//
//  Created by xing on 2018/9/4.
//  Copyright © 2018年 xing. All rights reserved.
//

#import "ChapterViewController.h"
#import "DatabaseManager.h"

@interface ChapterViewController ()

@property (nonatomic, strong) UITextView *textView;

@end

@implementation ChapterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.textView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:self.view.bounds];
        _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _textView.contentInset = UIEdgeInsetsMake(20, 20, 20, 20);
    }
    return _textView;
}

- (void)updataWithBook:(Book *)book
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        BookChapter *chapter = [book getChapterAtIndex:self.chapterIndex];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.textView.text = chapter.content;
        });
    });
}


@end
