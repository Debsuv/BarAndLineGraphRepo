//
//  PopView.m
//  CustomBarSection
//
//  Created by Debanjan Chakraborty on 30/01/15.
//  Copyright (c) 2015 Debanjan Chakraborty. All rights reserved.
//
#import "UIView+Customize.h"
#import "PopView.h"
@interface PopView()
@property (nonatomic) UILabel *titleLbl,*dataLbl;
@end
@implementation PopView
-(instancetype)init
{
    self = [super init];
    if(self)
    {
        [self baseInit];
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
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

- (void) baseInit
{
    _titleLbl = [[UILabel alloc] init];
    _dataLbl = [[UILabel alloc] init];
    
    [_titleLbl setFont:[UIFont systemFontOfSize:13.0f]];
    [_dataLbl setFont:[UIFont systemFontOfSize:13.0f]];
    
    [_dataLbl setBackgroundColor:[UIColor clearColor]];
    [_titleLbl setBackgroundColor:[UIColor clearColor]];
    
    [_dataLbl setTextColor:[UIColor whiteColor]];
    [_titleLbl setTextColor:[UIColor whiteColor]];
    
    [_dataLbl setTextAlignment:NSTextAlignmentCenter];
    [_titleLbl setTextAlignment:NSTextAlignmentCenter];
    
    [_dataLbl setText:@"Data here"];
    [_titleLbl setText:@"Title here"];
    
    _typeOfLine = lineTypeCurrent;
    
    self.backgroundColor = [UIColor clearColor];
}
-(void)setTypeOfLine:(lineType)typeOfLine
{
    _typeOfLine = typeOfLine;
    [self layoutSubviews];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [_dataLbl setFrame: CGRectMake((self.bounds.size.width/2)+0.5f, 0, (self.bounds.size.width/2)-1.0f, self.bounds.size.height)];
    [_titleLbl setFrame: CGRectMake(0.5f, 0, (self.bounds.size.width/2)-0.5f, self.bounds.size.height)];
    
    [_titleLbl cornerTheEdgesWithRadius:5.0f
                            andCorners:@[[NSNumber numberWithInteger:UIRectCornerTopLeft],[NSNumber numberWithInteger:UIRectCornerBottomLeft]]];
    [_dataLbl cornerTheEdgesWithRadius:5.0f
                             andCorners:@[[NSNumber numberWithInteger:UIRectCornerTopRight],[NSNumber numberWithInteger:UIRectCornerBottomRight]]];
    
    UIColor *bgColor;
    NSString *title;
    switch (_typeOfLine)
    {
        case lineTypeCurrent:
            bgColor = LINE_COLOR_CURRENT;
            title = LINE_CURRENT_TITLE;
            break;
            
        case lineTypeProjected:
            bgColor = LINE_COLOR_PROJECTED;
            title = LINE_PROJECTED_TITLE;
            break;
    }
    [_titleLbl setText:title];
    [_dataLbl setText:_valueText];
    
    
    [_dataLbl setBackgroundColor:bgColor];
    [_titleLbl setBackgroundColor:bgColor];
    
    [self addSubview:_dataLbl];
    [self addSubview:_titleLbl];
}
-(void)setValueText:(NSString *)valueText
{
    _valueText = valueText;
}
-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
   
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, self.backgroundColor.CGColor);
    CGContextFillRect(ctx, rect);
}
@end
