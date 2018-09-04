//
//  TextViewController.m
//  Reader
//
//  Created by xing on 2018/4/28.
//  Copyright © 2018年 xing. All rights reserved.
//

#import "TextViewController.h"
#import "ChapterViewController.h"
#import "Book.h"

@interface TextViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) Book *book;

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSMutableArray *chapterNames;
@property (nonatomic, strong) UIPageViewController *pageViewController;

@end

@implementation TextViewController

- (void)dealloc
{
    NSLog(@"TextViewController dealloc");
}

- (instancetype)initWithPath:(NSString *)path
{
    self = [super init];
    if (self) {
        self.path = path;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];

    _chapterNames = [NSMutableArray arrayWithCapacity:0];

    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"目录" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClicked:)];
    self.navigationItem.rightBarButtonItem = item;

    [self loadFile];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIPageViewController *)pageViewController
{
    if (!_pageViewController) {
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
        _pageViewController.view.frame = self.view.bounds;
        _pageViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _pageViewController;
}

- (void)rightItemClicked:(id)sender
{

}

- (void)loadFile
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    self.book = [[Book alloc] initWithPath:self.path];

    __weak typeof(self) weakSelf = self;
    [self.book prepareToRead:^(BOOL completed) {

        [MBProgressHUD hideHUDForView:self.view animated:YES];

        [self.chapterNames addObjectsFromArray:self.book.chapterNames];

        ChapterViewController *vc = [[ChapterViewController alloc] init];
        vc.chapterIndex = self.index;
        [weakSelf.pageViewController setViewControllers:@[vc]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:NO
                                         completion:^(BOOL finished) {
                                             [vc updataWithBook:weakSelf.book];
                                         }];
    }];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if (self.index >= self.chapterNames.count - 1) {
        return nil;
    }

    ChapterViewController *vc = [[ChapterViewController alloc] init];
    vc.chapterIndex = self.index + 1;
    [vc updataWithBook:self.book];
    return vc;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if (self.index <= 0) {
        return nil;
    }

    ChapterViewController *vc = [[ChapterViewController alloc] init];
    vc.chapterIndex = self.index - 1;
    [vc updataWithBook:self.book];
    return vc;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    ChapterViewController *vc = (ChapterViewController *)pageViewController.viewControllers.firstObject;
    self.index = vc.chapterIndex;
}


@end
