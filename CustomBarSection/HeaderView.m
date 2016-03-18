//
//  HeaderView.m
//  CustomBarSection
//
//  Created by Debanjan Chakraborty on 21/01/15.
//  Copyright (c) 2015 Debanjan Chakraborty. All rights reserved.
//

#import "UIView+Customize.h"
#import "HeaderView.h"
@interface IconView:UIView
@property (nonatomic) iconType typeOfIcon;
@property (nonatomic) UIColor *arrowColor;
@end
@implementation IconView

-(instancetype)init
{
    self = [super init];
    if(self)
    {
        _arrowColor = RGB(255.0f, 255.0f, 255.0f);
    }
    return self;
}
-(void)drawRect:(CGRect)rect
{

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextBeginPath(ctx);
    
    switch (_typeOfIcon) {
        case upArrow:
        {
           CGContextMoveToPoint(ctx, CGRectGetMidX(rect), CGRectGetMinY(rect));
           CGContextAddLineToPoint(ctx, CGRectGetMinX(rect),CGRectGetMaxY(rect));
           CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect),CGRectGetMaxY(rect));
           CGContextAddLineToPoint(ctx, CGRectGetMidX(rect), CGRectGetMinY(rect));
          
        }
            break;
            
        case downArrow:
        {
            CGContextMoveToPoint(ctx, CGRectGetMinX(rect), CGRectGetMinY(rect));
            CGContextAddLineToPoint(ctx, CGRectGetMidX(rect),CGRectGetMaxY(rect));
            CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect),CGRectGetMinY(rect));
            CGContextMoveToPoint(ctx, CGRectGetMinX(rect), CGRectGetMinY(rect));
        }
            break;
    }
    
    CGContextSetFillColorWithColor(ctx, _arrowColor.CGColor);
    CGContextFillPath(ctx);
}
@end
@interface HeaderView()
@property (nonatomic) UILabel *labelSub;

@property (nonatomic) IconView *icon;
@end
@implementation HeaderView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self baseInit];
    }
    return self;
}
-(void)baseInit
{
    _rad = [NSNumber numberWithFloat:BAR_CORNER_RADIUS];
    _headerFont = [UIFont systemFontOfSize:13.0f];
    _typeOfBar = barTypeCurrent;
    _txtColor = [UIColor whiteColor];
    
    _labelSub = [[UILabel alloc] init];
    [_labelSub setTextAlignment:NSTextAlignmentCenter];
   
    [_labelSub setBackgroundColor:[UIColor clearColor]];
    [self addSubview:_labelSub];
    

    [self setClipsToBounds:YES];
   
}
-(void)layoutSubviews
{
    [super layoutSubviews];

    NSString *subLblText=@"";
    
    switch (_typeOfBar) {
        case barTypeCurrent:
            subLblText=@"Current";
            break;
        case barTypeHighest:
        {
            subLblText=@"Highest";
            _icon = [[IconView alloc] init];
            [_icon setTypeOfIcon:upArrow];
            [self addSubview:_icon];
        }
            break;
        case barTypeLowest:
        {
            subLblText=@"Lowest";
            _icon = [[IconView alloc] init];
            [_icon setTypeOfIcon:downArrow];
            [self addSubview:_icon];
        }
            
            break;
        default:
            break;
    }
    [_labelSub setFont:_headerFont];
    [_labelSub setText:subLblText];
    
    [_icon setFrame:CGRectMake(_rad.floatValue/2, (self.bounds.size.height-self.bounds.size.height/2)/2, self.bounds.size.height/2, self.bounds.size.height/2)];
    [_icon setBackgroundColor:[UIColor clearColor]];
    
    [_labelSub setFrame:CGRectMake((_typeOfBar==barTypeCurrent)?0:_icon.bounds.origin.x+_icon.bounds.size.width, 0, self.bounds.size.width-(_icon.frame.origin.x+_icon.frame.size.width), self.bounds.size.height)];
    [_labelSub setTextColor:_txtColor];
    
    [self setNeedsDisplay];
}
-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];    
    UIColor *colorToPaint = [UIColor new];
    
    switch (_typeOfBar)
    {
        case barTypeCurrent:
            colorToPaint = BAR_HEADER_COLOR_CURRENT;
            break;
        case barTypeHighest:
            colorToPaint = BAR_HEADER_COLOR_HIGHEST;
            break;
        case barTypeLowest:
            colorToPaint = BAR_HEADER_COLOR_LOWEST;
            break;
            
        default:
            break;
    }
    [colorToPaint setFill];
    UIRectFill(rect);
    
}
@end
