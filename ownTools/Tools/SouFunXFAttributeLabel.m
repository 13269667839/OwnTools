//
//  AttributeLabel.m
//  SouFun
//
//  Created by zhangjianwei on 15/9/11.
//
//

#import "SouFunXFAttributeLabel.h"
#import <CoreText/CoreText.h>

static NSString* const kEllipsesCharacter = @"\u2026";

@interface SouFunXFAttributeLabel ()

@property (readwrite, nonatomic, strong) NSArray *links;
@property (readwrite, nonatomic, strong) NSTextCheckingResult *activeLink;
@property (nonatomic,assign) NSUInteger matchKeyIdx;
@property (nonatomic,assign) CTFrameRef textFrame;
@property (nonatomic,assign) NSInteger numberOfLines;
@property (nonatomic,strong) CoreTextImageData *imageData;
@property (nonatomic,copy) clickBlock imageBlock;
@property (nonatomic,copy)NSDictionary *imageInfoDic;
@end
@implementation SouFunXFAttributeLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    
    UIGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(userTapGestureDetected:)];
    [self addGestureRecognizer:tapRecognizer];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame attributeString:(NSMutableAttributedString *)attrString
{
    self = [self initWithFrame:frame];
    if (self) {
        _resultAttributedString = attrString;
        self.userInteractionEnabled = YES;
        self.multipleTouchEnabled = NO;
      
    }
    return self;
}

- (void)setText:(NSString *)tx TextColor:(UIColor *)col FontSize:(CGFloat)fSize
{
    if (tx && tx.length > 0) {
        NSMutableAttributedString *mutaString = [[NSMutableAttributedString alloc]initWithString:tx];
        NSRange range = NSMakeRange(0, tx.length);
        [mutaString addAttribute:(NSString *)(kCTForegroundColorAttributeName) value:(id)col.CGColor range:range];
        UIFont *font = [UIFont systemFontOfSize:fSize];
        CTFontRef fontRef = CTFontCreateWithName((CFStringRef)font.fontName, font.pointSize, NULL);
        [mutaString addAttribute:(NSString *)(kCTFontAttributeName) value:(__bridge id)fontRef range:range];
        CFRelease(fontRef);
        
        _resultAttributedString = mutaString;
        [self setNeedsDisplay];
    }
}

- (void)addTextColor:(UIColor *)col FontSize:(CGFloat)fSize range:(NSRange)range imageinfoDic:(NSDictionary *)infoDic
{
    UIFont *font = [UIFont systemFontOfSize:fSize];
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)font.fontName, font.pointSize, NULL);
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)fontRef,kCTFontAttributeName,(__bridge id)col.CGColor,kCTForegroundColorAttributeName,nil ];
    
    [self.resultAttributedString addAttributes:attributes range:range];
    [self addLinkWithTextCheckingResult:[NSTextCheckingResult linkCheckingResultWithRange:range URL:nil]];
    
    if(infoDic){
        self.imageInfoDic = infoDic;
    }
    
    CFRelease(fontRef);
    
}

- (CTFramesetterRef)framesetter
{
    return CTFramesetterCreateWithAttributedString((CFAttributedStringRef)_resultAttributedString);
}

- (CGRect)resetRectAfterSetAttributeFinished
{
    CGRect rect = self.frame;
    rect.size = [self getLLLLabelSize];
    
    self.frame = rect;
    return rect;
}

- (CGSize)getLLLLabelSize
{
    if (!self.resultAttributedString) {
        return CGSizeZero;
    }
    
    CGSize constraints = CGSizeMake(CGRectGetWidth(self.frame), 5000);
    CTFramesetterRef tempCTF = [self framesetter];
    CGSize textSize = CTFramesetterSuggestFrameSizeWithConstraints(tempCTF, CFRangeMake(0, (CFIndex)[self.resultAttributedString length]), NULL,constraints , NULL);
    CFRelease(tempCTF);
    textSize = CGSizeMake(ceil(textSize.width), ceil(textSize.height));
    //    返回实际的宽度，而不是设定的；
    //    textSize.width = CGRectGetWidth(self.frame);
    
    return textSize;
}

- (CFIndex)characterIndexAtPoint:(CGPoint)p {
    if (!CGRectContainsPoint(self.bounds, p)) {
        return NSNotFound;
    }
    
    CGRect textRect = self.bounds; //[self textRectForBounds:self.bounds limitedToNumberOfLines:self.numberOfLines];
    if (!CGRectContainsPoint(textRect, p)) {
        return NSNotFound;
    }
    
    p = CGPointMake(p.x, textRect.size.height - p.y);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, textRect);
    CTFramesetterRef tempCTF = [self framesetter];
    CTFrameRef frame = CTFramesetterCreateFrame(tempCTF, CFRangeMake(0, (CFIndex)[self.resultAttributedString length]), path, NULL);
    CFRelease(tempCTF);
    if (frame == NULL) {
        CFRelease(path);
        return NSNotFound;
    }
    
    CFArrayRef lines = CTFrameGetLines(frame);
    NSInteger numberOfLines = CFArrayGetCount(lines);
    
    if (numberOfLines == 0) {
        CFRelease(frame);
        CFRelease(path);
        return NSNotFound;
    }
    
    CFIndex idx = NSNotFound;
    
    CGPoint lineOrigins[numberOfLines];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, numberOfLines), lineOrigins);
    
    for (CFIndex lineIndex = 0; lineIndex < numberOfLines; lineIndex++) {
        CGPoint lineOrigin = lineOrigins[lineIndex];
        CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
        
        // Get bounding information of line
        CGFloat ascent = 0.0f, descent = 0.0f, leading = 0.0f;
        CGFloat width = (CGFloat)CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        CGFloat yMin = (CGFloat)floor(lineOrigin.y - descent);
        CGFloat yMax = (CGFloat)ceil(lineOrigin.y + ascent);
        
        // Check if we've already passed the line
        if (p.y > yMax) {
            break;
        }
        // Check if the point is within this line vertically
        if (p.y >= yMin) {
            // Check if the point is within this line horizontally
            if (p.x >= lineOrigin.x && p.x <= lineOrigin.x + width) {
                // Convert CT coordinates to line-relative coordinates
                CGPoint relativePoint = CGPointMake(p.x - lineOrigin.x, p.y - lineOrigin.y);
                idx = CTLineGetStringIndexForPosition(line, relativePoint);
                break;
            }
        }
    }
    
    CFRelease(frame);
    CFRelease(path);
    
    return idx;
}


- (void)addLinkWithTextCheckingResult:(NSTextCheckingResult *)result
{
    NSMutableArray *mutableLinks = [NSMutableArray arrayWithArray:self.links];
    [mutableLinks addObject:result];
    self.links = [NSArray arrayWithArray:mutableLinks];
}

- (NSTextCheckingResult *)linkAtPoint:(CGPoint)point {
    CFIndex idx = [self characterIndexAtPoint:point];
    if (idx == NSNotFound) {
        self.matchKeyIdx = 0;
        return nil;
    }
    return [self linkAtCharacterIndex:idx];
}

- (NSTextCheckingResult *)linkAtCharacterIndex:(CFIndex)cfIdx {
    self.matchKeyIdx = 0;
    __block NSTextCheckingResult *result = nil;
    [self.links enumerateObjectsUsingBlock:^(NSTextCheckingResult *obj, NSUInteger idx, BOOL *stop) {
        if (NSLocationInRange((NSUInteger)cfIdx, obj.range)) {
            self.matchKeyIdx = idx;
            result = obj;
            *stop = YES;
        }
    }];
    return result;
}

- (void)touchesBegan:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    self.activeLink = [self linkAtPoint:[touch locationInView:self]];
    if (!self.activeLink) {
        [super touchesBegan:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.activeLink) {
        [super touchesEnded:touches withEvent:event];
    }else{
        if (self.LLLclickedKeyAttributeBlock) {
            NSString *str = [self.resultAttributedString.string substringWithRange:self.activeLink.range];
            self.LLLclickedKeyAttributeBlock(str,self.matchKeyIdx);
        }
    }
}
- (NSInteger)numberOfDisplayedLines
{
    CFArrayRef lines = CTFrameGetLines(self.textFrame);
    return  CFArrayGetCount(lines);
//    return self.numberOfLines > 0 ? MIN(CFArrayGetCount(lines), self.numberOfLines) : CFArrayGetCount(lines);
}
//从每行画
- (void)drawTextInRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    //将当前context的坐标系进行flip,否则上下颠倒
    CGAffineTransform flipVertical = CGAffineTransformMake(1,0,0,-1,0,self.bounds.size.height);
    CGContextConcatCTM(context, flipVertical);
    //设置字形变换矩阵为CGAffineTransformIdentity，也就是说每一个字形都不做图形变换
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    NSString *attrStr = self.resultAttributedString.string;
    NSRange range = NSMakeRange(0, attrStr.length);
    NSDictionary *dic = [self.resultAttributedString attributesAtIndex:0 effectiveRange:&range];
    NSMutableParagraphStyle *ps =  [dic objectForKey:NSParagraphStyleAttributeName];
    BOOL truncatTail = NO;
    if(ps.lineBreakMode == NSLineBreakByTruncatingTail)
    {
        truncatTail = YES;
    }
    
    NSInteger numberOfLines = [self numberOfDisplayedLines];
    
    CGSize tempSize = self.frame.size;
    CGSize trueSize = [self getLLLLabelSize];
   
    if (_textFrame)
    {
        if (numberOfLines > 0 && tempSize.height < trueSize.height)
        {
            CFArrayRef lines = CTFrameGetLines(_textFrame);
            
            CGPoint lineOrigins[numberOfLines];
            CTFrameGetLineOrigins(_textFrame, CFRangeMake(0, numberOfLines), lineOrigins);
            NSAttributedString *attributedString = self.resultAttributedString;
            for (CFIndex lineIndex = 0; lineIndex < numberOfLines; lineIndex++)
            {
                CGPoint lineOrigin = lineOrigins[lineIndex];
                CGContextSetTextPosition(context, lineOrigin.x, lineOrigin.y);
                CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
                
                BOOL shouldDrawLine = YES;
                if (lineIndex == numberOfLines - 1 )
                {
                    // Does the last line need truncation?
                    CFRange lastLineRange = CTLineGetStringRange(line);
                    if (lastLineRange.location + lastLineRange.length < attributedString.length)
                    {
                        CTLineTruncationType truncationType = kCTLineTruncationEnd;
                        //加省略号的位置
                        NSUInteger truncationAttributePosition = lastLineRange.location + lastLineRange.length - 1;
                        //获取省略号位置的字符串属性
                        NSDictionary *tokenAttributes = [attributedString attributesAtIndex:truncationAttributePosition
                                                                             effectiveRange:NULL];
                        //初始化省略号的属性字符串
                        NSAttributedString *tokenString = [[NSAttributedString alloc] initWithString:kEllipsesCharacter
                                                                                          attributes:tokenAttributes];
                        //创建一行
                        CTLineRef truncationToken = CTLineCreateWithAttributedString((CFAttributedStringRef)tokenString);
                        NSMutableAttributedString *truncationString = [[attributedString attributedSubstringFromRange:NSMakeRange(lastLineRange.location, lastLineRange.length)] mutableCopy];
                        
                        if (lastLineRange.length > 0)
                        {
                            // Remove last token
                            [truncationString deleteCharactersInRange:NSMakeRange(lastLineRange.length - 1, 1)];
                        }
                        [truncationString appendAttributedString:tokenString];
                        
                        //创建省略号的行
                        CTLineRef truncationLine = CTLineCreateWithAttributedString((CFAttributedStringRef)truncationString);
                        // 在省略号行的末尾加上省略号
                        CTLineRef truncatedLine = CTLineCreateTruncatedLine(truncationLine, rect.size.width, truncationType, truncationToken);
                        if (!truncatedLine)
                        {
                            // If the line is not as wide as the truncationToken, truncatedLine is NULL
                            truncatedLine = CFRetain(truncationToken);
                        }
                        CFRelease(truncationLine);//CF得自己释放，ARC的不会释放
                        CFRelease(truncationToken);
                        
                        CTLineDraw(truncatedLine, context);
                        CFRelease(truncatedLine);
                        
                        shouldDrawLine = NO;
                    }
                }
                if(shouldDrawLine)
                {
                    CTLineDraw(line, context);
                }
            }
        }
        else
        {
            CTFrameDraw(_textFrame,context);
        }
    }
    UIImage *image = [UIImage imageNamed:self.imageData.infoDic [@"name"]];
    if(image){
        CGContextDrawImage(context, self.imageData.imagePosition, image.CGImage);
    }
    
    CGContextRestoreGState(context);
}

static CGFloat ascentCallback(void *ref){
    return [(NSNumber*)[(__bridge NSDictionary*)ref objectForKey:@"height"] floatValue];

}

static CGFloat descentCallback(void *ref){
    return 0;
}

static CGFloat widthCallback(void* ref){

    return [(NSNumber*)[(__bridge NSDictionary*)ref objectForKey:@"width"] floatValue];
}

#pragma mark - 图片处理

- (void)setImageInfoDic:(NSDictionary *)imageInfoDic
{
    if(_imageInfoDic) return;
    _imageInfoDic = [imageInfoDic copy];
    if(!self.imageData && imageInfoDic){
        self.imageData = [[CoreTextImageData alloc] init];
        self.imageData.infoDic = imageInfoDic;
        self.imageData.position = [[imageInfoDic objectForKey:@"position"] floatValue];
        NSAttributedString *tempAttributeStr = [SouFunXFAttributeLabel parseImageDataFromNSDictionary:self.imageData.infoDic];
        [_resultAttributedString insertAttributedString:tempAttributeStr atIndex:self.imageData.position];
        [self fillImagePosition];//暂时放这里
    }
    [self setNeedsDisplay];
}

+ (NSAttributedString *)parseImageDataFromNSDictionary:(NSDictionary *)dict
                                                 {
    CTRunDelegateCallbacks callbacks;
    memset(&callbacks, 0, sizeof(CTRunDelegateCallbacks));
    callbacks.version = kCTRunDelegateVersion1;
    callbacks.getAscent = ascentCallback;
    callbacks.getDescent = descentCallback;
    callbacks.getWidth = widthCallback;
    CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, (__bridge void *)(dict));
    
    // 使用0xFFFC作为空白的占位符
    unichar objectReplacementChar = 0xFFFC;
    NSString * content = [NSString stringWithCharacters:&objectReplacementChar length:1];
    NSDictionary * attributes = [NSDictionary dictionary];//[self attributesWithConfig:config];
    NSMutableAttributedString * space = [[NSMutableAttributedString alloc] initWithString:content
                                                                               attributes:attributes];
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)space, CFRangeMake(0, 1),
                                   kCTRunDelegateAttributeName, delegate);
    CFRelease(delegate);
    return space;
}

- (void)fillImagePosition {
   
    NSArray *lines = (NSArray *)CTFrameGetLines(self.textFrame);
    NSUInteger lineCount = [lines count];
    CGPoint lineOrigins[lineCount];
    CTFrameGetLineOrigins(self.textFrame, CFRangeMake(0, 0), lineOrigins);
    
    CoreTextImageData * imageData = self.imageData;
    
    for (int i = 0; i < lineCount; ++i) {
        if (imageData == nil) {
            break;
        }
        CTLineRef line = (__bridge CTLineRef)lines[i];
        NSArray * runObjArray = (NSArray *)CTLineGetGlyphRuns(line);
        for (id runObj in runObjArray) {
            CTRunRef run = (__bridge CTRunRef)runObj;
            __autoreleasing NSDictionary *runAttributes = (NSDictionary *)CTRunGetAttributes(run);
            CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)[runAttributes valueForKey:(id)kCTRunDelegateAttributeName];
            if (delegate == nil) {
                continue;
            }
            
            NSDictionary * metaDic = CTRunDelegateGetRefCon(delegate);
            if (![metaDic isKindOfClass:[NSDictionary class]]) {
                continue;
            }
            
            CGRect runBounds;
            CGFloat ascent;
            CGFloat descent;
            runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);
            runBounds.size.height = ascent + descent;
            
            CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
            runBounds.origin.x = lineOrigins[i].x + xOffset;
            runBounds.origin.y = lineOrigins[i].y;
            runBounds.origin.y -= descent;
            
            CGPathRef pathRef = CTFrameGetPath(self.textFrame);
            CGRect colRect = CGPathGetBoundingBox(pathRef);
            
            CGRect delegateBounds = CGRectOffset(runBounds, colRect.origin.x, colRect.origin.y);
            
            imageData.imagePosition = delegateBounds;
        }
    }
}

//点击图片
- (void)clickImageWithBlock:(clickBlock)block
{
    if(block){
        self.imageBlock = block;
    }
}


- (void)userTapGestureDetected:(UIGestureRecognizer *)recognizer {
    CGPoint point = [recognizer locationInView:self];
    
            // 翻转坐标系，因为imageData中的坐标是CoreText的坐标系
            CGRect imageRect = self.imageData.imagePosition;
            CGPoint imagePosition = imageRect.origin;
            imagePosition.y = self.bounds.size.height - imageRect.origin.y - imageRect.size.height;
            CGRect rect = CGRectMake(imagePosition.x, imagePosition.y, imageRect.size.width, imageRect.size.height);
            // 检测点击位置 Point 是否在rect之内
            if (CGRectContainsPoint(rect, point)) {
                NSLog(@"hint image");
                // 在这里处理点击后的逻辑
                self.imageBlock();
                return;
            }else{
                if (!self.activeLink) {
                    
                }else{
                    if (self.LLLclickedKeyAttributeBlock) {
                        NSString *str = [self.resultAttributedString.string substringWithRange:self.activeLink.range];
                        self.LLLclickedKeyAttributeBlock(str,self.matchKeyIdx);
                    }
                }
            }
        
    
}
#pragma mark - setter / getter
- (CTFrameRef )textFrame
{
    if(!_textFrame){
        CTFramesetterRef framesetter = [self framesetter];
        CGMutablePathRef pathRef = CGPathCreateMutable();
        CGPathAddRect(pathRef,NULL , CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));
        _textFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), pathRef,NULL );
    }
    return _textFrame;
}
@end

@implementation CoreTextImageData

@end
