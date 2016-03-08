//
//  TableViewController.m
//  的顶顶顶顶顶
//
//  Created by 张毅 on 16/3/8.
//  Copyright © 2016年 com.soufun. All rights reserved.
//

#import "TableViewController.h"

typedef void(^ZyBlock)();

@interface TableViewController ()

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@",[NSRunLoop currentRunLoop].currentMode);
//    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
//    
//    NSLog(@"%@",runloop);
    
//    [runloop addObserver:self forKeyPath:@"currentMode" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld  context:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
//    
//    NSLog(@"%@",runloop);
//    
//    [runloop addObserver:self forKeyPath:@"currentMode" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld  context:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    NSLog(@"%@",change);
    
    if ([keyPath isEqualToString:@"currentMode"])
    {
        NSLog(@"%@",change);
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"12321"];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"12321"];
    }
    
    cell.textLabel.text = [NSRunLoop currentRunLoop].currentMode;
    
    ZyBlock myBlock = ^{
        cell.textLabel.text = @"延迟加载图片";
    };
    
    [self performSelector:@selector(setMyText:) withObject:myBlock afterDelay:0.0 inModes:@[NSDefaultRunLoopMode]];
    
    
//    if ([[NSRunLoop currentRunLoop].currentMode isEqualToString:@"NSDefaultRunLoopMode"])
//    {
//        cell.textLabel.text = @"NSDefaultRunLoopMode";
//    }
//    else if ([[NSRunLoop currentRunLoop].currentMode isEqualToString:@"UITrackingRunLoopMode"])
//    {
//        cell.textLabel.text = @"UITrackingRunLoopMode";
//    }
//    else if ([[NSRunLoop currentRunLoop].currentMode isEqualToString:@"NSRunLoopCommonModes"])
//    {
//        cell.textLabel.text = @"NSRunLoopCommonModes";
//    }
    
    
    return cell;
}


-(void)setMyText:(ZyBlock)myBlock
{
    if (myBlock)
    {
        myBlock();
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"aaa%@",[NSRunLoop currentRunLoop]);
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
