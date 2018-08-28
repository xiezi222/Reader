//
//  ViewController.m
//  Reader
//
//  Created by xing on 2018/4/28.
//  Copyright © 2018年 xing. All rights reserved.
//

#import "ViewController.h"
#import "TextViewController.h"
#import "FileManager.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *files;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _files = [NSMutableArray array];
    [self loadFiles];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadFiles
{
    NSArray *filePaths = [[FileManager sharedManager] allFiles];
    [_files addObjectsFromArray:filePaths];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.files.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fileCell"];
    NSString *filePath = [self.files objectAtIndex:indexPath.row];
    NSString *name = filePath.lastPathComponent;
    cell.textLabel.text = [name stringByRemovingPercentEncoding];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *path = [self.files objectAtIndex:indexPath.row];
    
    TextViewController *vc = [[TextViewController alloc] initWithPath:path];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
