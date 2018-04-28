//
//  ViewController.m
//  Reader
//
//  Created by xing on 2018/4/28.
//  Copyright © 2018年 xing. All rights reserved.
//

#import "ViewController.h"
#import "TextViewController.h"

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
    NSArray *urls = [[NSBundle mainBundle] URLsForResourcesWithExtension:@"txt" subdirectory:nil];
    [_files addObjectsFromArray:urls];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.files.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fileCell"];
    NSURL *url = [self.files objectAtIndex:indexPath.row];
    cell.textLabel.text = url.resourceSpecifier;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSURL *url = [self.files objectAtIndex:indexPath.row];
    TextViewController *vc = [[TextViewController alloc] initWithURL:url];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
