//
//  ZYPopoverView.m
//
//  Created by 张毅 on 15/6/16.
//  Copyright (c) 2015年 com.soufun. All rights reserved.
//  仿写 iPad 中的 UIPopoverController


#import "ZYPopoverView.h"
#import "ZYBaseTools.h"

@interface ZYPopoverView ()
{
    struct {
        unsigned int isRespondsProtocolMethod : 1;
    }_ZYPopoverViewFlag;
    
}
@property (nonatomic, assign) CGFloat arrowHeight;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGFloat wordSize;
@property (nonatomic, assign) CGSize size;
@end

@implementation ZYPopoverView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame nameArray:(NSMutableArray *)nameArray imageArray:(NSMutableArray *)imageArray delegate:(id)delegate arrowHeight:(CGFloat)arrowHeight backgroundColor:(UIColor *)backgroundColor separatorColor:(UIColor *)separatorColor alpha:(CGFloat)alpha radius:(CGFloat)radius wordSize:(CGFloat)wordSize
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.alpha  = alpha;
        self.layer.cornerRadius = radius;
        self.arrowHeight = arrowHeight;
        self.radius = radius;
        self.wordSize = wordSize;
        self.size = CGSizeMake(frame.size.width, (frame.size.height - arrowHeight)*1.0/[nameArray count]);
        
        CGRect rect = CGRectMake(0, arrowHeight, frame.size.width, frame.size.height - arrowHeight);
        
        UITableView * table = [[UITableView alloc] initWithFrame: rect style: UITableViewStylePlain];
        self.tableView =table;
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.alpha = alpha;
        self.tableView.layer.cornerRadius = radius;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.scrollEnabled = YES;
        
        self.nameDataSource  = nameArray;
        self.imageDataSource = imageArray;
        self.delegate = delegate;
        
        if (IOS7DEVICE) {
            //            [self.tableView setSeparatorInset:UIEdgeInsetsZero];
            //            self.tableView.separatorInset = UIEdgeInsetsMake(0, -10, 0, 0);
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            self.tableView.separatorColor = separatorColor;
        } else {
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            self.tableView.separatorColor = separatorColor;
        }
        [self addSubview:self.tableView];
        [self initFlags];
    }
    return self;
}

-(void)initFlags
{
    _ZYPopoverViewFlag.isRespondsProtocolMethod = (self.delegate && [self.delegate respondsToSelector:@selector(performZYPopoverViewActionWithIndex:)])?1:0;
}

#pragma mark -
#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.nameDataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"ZYPopoverViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        // 点击背景色
        UIView *selectedBackView = [[UIView alloc] initWithFrame:cell.frame];
        selectedBackView.backgroundColor = [UIColor blackColor];
        selectedBackView.clipsToBounds = YES;
        cell.selectedBackgroundView = selectedBackView;
    }
    
    // 移除已存在控件
    [[cell.contentView subviews] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        [view removeFromSuperview];
    }];

    
    // image
    //    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[self.imageDataSource objectAtIndex: indexPath.row]]];
    //    imageView.backgroundColor = [UIColor clearColor];
    //    imageView.contentMode = UIViewContentModeScaleAspectFill;
    //    imageView.frame = CGRectMake(5, self.size.height/4.0f-5, 30, 30); // CGRectMake(10, self.size.height/4.0f, self.size.width/8.0f, self.size.height/2.0f)
    //    imageView.clipsToBounds = YES;
    //    [cell.contentView addSubview:imageView];
    
    // 分割线
    if (IOS7DEVICE && indexPath.row < [self.nameDataSource count] - 1)
    {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.size.height-0.5f, self.size.width, 0.5f)];
        lineView.backgroundColor = [ZYBaseTools colorWithHexString:@"#6c6c6c"];
        lineView.clipsToBounds = YES;
        [cell.contentView addSubview:lineView];
    }
    
    // label  文字左间距22像素
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20+2, self.size.height/4.0f, self.size.width - 22, self.size.height/2.0f)];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.text = (NSString *)[self.nameDataSource objectAtIndex: indexPath.row];
    textLabel.textAlignment = NSTextAlignmentLeft;
    textLabel.font = [UIFont boldSystemFontOfSize: self.wordSize];
    textLabel.textColor = [UIColor whiteColor];
    textLabel.clipsToBounds = YES;
    [cell.contentView addSubview:textLabel];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    return cell;
}

#pragma mark -
#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView.bounds.size.height*1.0f/[self.nameDataSource count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;  //（这种是点击的时候有效果，返回后效果消失）
    
    if (_ZYPopoverViewFlag.isRespondsProtocolMethod)
    {
        [self.delegate performZYPopoverViewActionWithIndex:indexPath.row];
    }
}


#pragma mark -
#pragma mark -- override drawRect
- (void)drawRect:(CGRect)rect
{
    [self drawInContext:UIGraphicsGetCurrentContext()];
    
    //    self.layer.shadowColor = [UIColor grayColor].CGColor;
    //    self.layer.shadowOpacity = 1.0f;
    //    self.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
}

- (void)drawInContext:(CGContextRef)context
{
    CGContextSetLineWidth(context, 2.0f);
    //CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetRGBFillColor(context, 0.0f, 0.0f, 0.0f, self.alpha);
    CGContextSetStrokeColorWithColor(context, self.backgroundColor.CGColor);
    
    [self getDrawPath:context];
    
    CGContextFillPath(context);
}

- (void)getDrawPath:(CGContextRef)context
{
    CGRect rect = self.bounds;
    
    CGFloat minx = CGRectGetMinX(rect), maxx = CGRectGetMaxX(rect), modifyx = maxx*27/32.0f, miny = CGRectGetMinY(rect) + self.arrowHeight, maxy = CGRectGetMaxY(rect);
    if (IOS7DEVICE) {
        modifyx = maxx*13/16.0f;
    }
    
    CGContextMoveToPoint(context, modifyx - 5.0f, miny);
    CGContextAddLineToPoint(context, modifyx, miny - self.arrowHeight);
    CGContextAddLineToPoint(context, modifyx + 5.0f, miny);
    
    CGContextAddArcToPoint(context, modifyx, miny, maxx, miny, self.radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxy, self.radius);
    CGContextAddArcToPoint(context, maxx, maxy, minx, maxy, self.radius);
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, self.radius);
    CGContextAddArcToPoint(context, minx, miny, modifyx, miny, self.radius);
    
    CGContextClosePath(context);
}
@end
