//
//  ViewController.m
//  ownTools
//
//  Created by 张毅 on 15-4-8.
//  Copyright (c) 2015年 com.soufun. All rights reserved.
//

#define GET_SF_IMAGE(imageStr) [UIImage imageNamed:imageStr]
#import "ViewController.h"
#import "LLLAttributeLabel.h"
#import "ZYTableViewBase.h"
#import "ZYPopoverView.h"
#import "ZYBaseTools.h"

@interface ViewController ()<ZYTableViewDelegate,ZYPopoverViewDelegate>
@property (nonatomic, strong)ZYTableViewBase *baseTableView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self createLLLLabel];
//    [self createTableView];
//    [self testCustomCategory];
    [self testZYPopoverView];
    
    
    NSLog(@"%d",[ZYBaseTools isValidatePhone:@"13269667839"]);
    
    
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 100, 320, 50)];
    UIImage *imgBtn1=[ZYBaseTools createImageForSize:btn1.frame.size
                                         radius:2.5f
                                      fillColor:[ZYBaseTools colorWithHexString:@"#dddddd"]
                                      roundType:RoundAll
                                    strokeColor:nil
                                strokeLineWidth:0.0f];
    
    [btn1 setBackgroundImage:[imgBtn1 stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    
    [self.view addSubview:btn1];
    
}


-(void)testZYPopoverView
{
    NSMutableArray *nameArray = [[NSMutableArray alloc] initWithObjects:@"更换看房顾问", @"房源推荐",nil];
    NSMutableArray *imageArray = nil;
    
    CGRect frame = CGRectMake(180, 64, 140, 40 * nameArray.count);
    if (IOS7DEVICE) {
        frame = CGRectMake(175, 64, 140, 40 * nameArray.count);
    }
    ZYPopoverView *menu = [[ZYPopoverView alloc] initWithFrame:frame
                                                     nameArray:nameArray
                                                    imageArray:imageArray
                                                      delegate:self
                                                   arrowHeight:5
                                               backgroundColor:[UIColor blackColor]
                                                separatorColor:[ZYBaseTools colorWithHexString:@"6c6c6c"]
                                                         alpha:0.85f
                                                        radius:3.5f
                                                      wordSize:16.0f];
    //self.selectMenuView = menu;
    //self.selectMenuView.hidden = NO;
    [self.view addSubview:menu];
}

-(void)performZYPopoverViewActionWithIndex:(NSInteger)index
{
    NSLog(@"点击第%ld个 条目",(long)index);
}

-(void)testCustomCategory
{
    [NSTimer scheduled_zy_TimerWithTimeInterval:1 repeats:YES block:^{
        NSLog(@"好事");
    }];
}

-(void)createTableView
{
    ZYTableViewBase *base = [[ZYTableViewBase alloc]initWithFrame:MAINSCREEN_APPLICATIONFRAME style:UITableViewStylePlain];
    base.delegate = self;
    [self.view addSubview:base];
    self.baseTableView = base;
    
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 200)];
//    view.backgroundColor = [UIColor greenColor];
//    self.baseTableView.zyTableView.tableHeaderView = view;
//    
//    UIButton *view1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 320, 200)];
//    view1.backgroundColor = [UIColor greenColor];
//    self.baseTableView.zyTableView.tableFooterView = view1;
    
    //这个必须调用 设置section的个数
    [ZYTableViewBase initZYTableSections:base sections:3];
    
    for (NSInteger i = 0; i < 3; i ++)
    {
        [self createSections:i];
    }
    
}

-(void)createSections:(NSInteger)i
{
    ZYTableViewSectionSetting *section = [self.baseTableView.sectionSettings objectAtIndex:i];
    section.classNameForCell = @"hehe";
    for (NSInteger j = 0; j < 7; j ++)
    {
        ZYTableViewRowSetting *row = [[ZYTableViewRowSetting alloc]init];
        
        row.rowHeight = 35;

        [section.rowSettings addObject:row];
    }
}

-(void)createLLLLabel
{
    UIImageView *iv = [[UIImageView alloc]initWithFrame:self.view.bounds];
    iv.image = GET_SF_IMAGE(@"Default-Landscape@2X");
    [self.view addSubview:iv];
    
    //宽度一定要指定，高度随意；（调用这个方法会重设高度 resetRectAfterSetAttributeFinished）
    LLLAttributeLabel *lllLabel = [[LLLAttributeLabel alloc]initWithFrame:CGRectMake(0, 20, 320, 0)attributeString:nil];
    
    NSString *keyWord = @"http://www.fang.com";
    NSString *keyword2 = @"int (^myBlock)(int num1, int num2)";
    NSString *totalStr = @"中国人，不怕流血：http://www.fang.com 中文再解释：返回类型 (^Block的名字)(Block的参数) = ^返回类型(Block的参数) { 这里放代码 }，例：int (^myBlock)(int num1, int num2) = ^int(int num1, int num2){return 100";
    
    [lllLabel setText:totalStr TextColor:[UIColor blackColor] FontSize:14];
    [lllLabel addTextColor:[UIColor blueColor] FontSize:14 range:[totalStr rangeOfString:keyWord]];
    [lllLabel addTextColor:[UIColor orangeColor] FontSize:14 range:[totalStr rangeOfString:keyword2]];
    
    //回调关键词点击；
    lllLabel.LLLclickedKeyAttributeBlock = ^(NSString *keyStr,NSUInteger idx){
        NSLog(@"-----%@---%ld",keyStr,idx);
        NSArray *arr = [keyStr componentsSeparatedByString:@"//"];
        NSString *str = [arr lastObject];
        UIWebView *wb = [[UIWebView alloc]initWithFrame:CGRectMake(0, 200, 320, 200)];
        [self.view addSubview:wb];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:keyStr]];
        [wb loadRequest:request];
        
    };
    
    [lllLabel resetRectAfterSetAttributeFinished];
    [self.view addSubview:lllLabel];
    
    lllLabel.backgroundColor = [UIColor redColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
