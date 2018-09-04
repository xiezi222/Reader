//
//  ChapterViewController.h
//  Reader
//
//  Created by xing on 2018/9/4.
//  Copyright © 2018年 xing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"

@interface ChapterViewController : UIViewController
@property (nonatomic, assign) NSInteger chapterIndex;

- (void)updataWithBook:(Book *)book;

@end
