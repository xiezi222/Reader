//
//  TextViewController.m
//  Reader
//
//  Created by xing on 2018/4/28.
//  Copyright © 2018年 xing. All rights reserved.
//

#import "TextViewController.h"
#import "FileLoader.h"

@interface TextViewController ()

@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) FileLoader *loader;

@end

@implementation TextViewController

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
    
    self.loader = [[FileLoader alloc] initWithPath:self.path];
    [self.loader load];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
