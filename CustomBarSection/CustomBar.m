//
//  CustomBar.m
//  CustomBarSection
//
//  Created by Debanjan Chakraborty on 20/01/15.
//  Copyright (c) 2015 Debanjan Chakraborty. All rights reserved.
//
#import "UIView+Customize.h"
#import "CustomBar.h"
#import "HeaderView.h"

@interface CustomBar()
@property (nonatomic) UILabel *labelValue;
@end;
@implementation CustomBar
-(instancetype)init
{
    self = [super init];
    if(self)
    {
        [self baseInit];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self baseInit];
    }
    return self;
}

- (void)baseInit
{
    _cornerRadius = [NSNumber numberWithFloat:BAR_CORNER_RADIUS];
    _typeOfBar = barTypeDefault;
    _barFont = [UIFont systemFontOfSize:13.0f];
    _txtColor = [UIColor whiteColor];
    [self setUserInteractionEnabled:YES];
    [self setClipsToBounds:YES];
    
    [self addUILabel];
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    switch (_typeOfBar)
    {
        case barTypeDefault:
            _colorToPaint = BAR_COLOR_DEFAULT;
            break;
            
        case barTypeCurrent:
            _colorToPaint = BAR_COLOR_CURRENT;
            break;
        case barTypeHighest:
            _colorToPaint = BAR_COLOR_HIGHEST;
            break;
        case barTypeLowest:
            _colorToPaint = BAR_COLOR_LOWEST;
            break;
    }
    
    [self cornerTheEdgesWithRadius:_cornerRadius.floatValue andCorners:@[[NSNumber numberWithInteger:UIRectCornerTopLeft],[NSNumber numberWithInteger:UIRectCornerTopRight]]];
    
    [_colorToPaint set];
    UIRectFill(rect);
}
-(void)setDataDict:(NSDictionary *)dataDict
{
    _dataDict = dataDict;
    _cornerRadius = dataDict[@"cornerRadius"];
}
-(void)layoutSubviews
{
    [super layoutSubviews];

    CGRect bounds = self.bounds;
    CGFloat headerHeight = 0.0;
    
    BOOL isHeaderAvailable = [_dataDict[@"isHeaderAvailable"] boolValue];
    
    if(isHeaderAvailable)
    {
        bounds.size.height+=BAR_HEADER_HEIGHT;
        
        HeaderView *headerView = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, BAR_HEADER_HEIGHT)];
        [headerView setRad:_cornerRadius];
        [headerView setTypeOfBar:_typeOfBar];
        [self addSubview:headerView];
        
        
        headerHeight = headerView.frame.size.height;
    }
    else
    {
        bounds.size.height-=BAR_HEADER_HEIGHT;
        
        [[self subviews]enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
        {
           if([obj isKindOfClass:[HeaderView class]])
           {
               [obj removeFromSuperview];
           }
        }];
        
    }

    [_labelValue setFrame:CGRectMake(0, headerHeight, self.bounds.size.width, 30)];
    [_labelValue setText:_dataDict[@"value"]];
    [_labelValue setTextColor:_txtColor];
    [_labelValue setNeedsDisplayInRect:CGRectMake(0, headerHeight, self.bounds.size.width, 30)];
    
    [self setNeedsDisplay];
}
- (void)addUILabel
{
    _labelValue = [[UILabel alloc] init];
    [_labelValue setBackgroundColor:[UIColor clearColor]];
    [_labelValue setTextAlignment:NSTextAlignmentCenter];
    [_labelValue setFont:_barFont];
    [self addSubview:_labelValue];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if([[self delegate] respondsToSelector:@selector(barTapped:)])
        [[self delegate ] barTapped:@{@"data":@"touchesEnded",@"labelFrame":NSStringFromCGRect(_labelValue.frame),@"dataDict":_dataDict}];
}

@end
