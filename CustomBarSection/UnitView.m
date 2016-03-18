//
//  UnitView.m
//  CustomBarSection
//
//  Created by Debanjan Chakraborty on 27/01/15.
//  Copyright (c) 2015 Debanjan Chakraborty. All rights reserved.
//

#import "UnitView.h"

@interface UnitView()
@property (nonatomic) UILabel *axisTextLabl;
@end
@implementation UnitView

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
    self.backgroundColor = [UIColor blackColor];
    _axisTextLabl = [[UILabel alloc] init];
    [_axisTextLabl setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:_axisTextLabl];
    
    
    
    _axisDefaultColor = [UIColor lightGrayColor];
    _axisHighlitedColor = [UIColor blackColor];
    _lineAxisColor = [UIColor blackColor];
    _isActive = NO;
    _axisFont = [UIFont systemFontOfSize:12.0f];
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect axisLblFrame = CGRectZero;
    switch (_typeOfAxis) {
        case axisUnitTypeX:
            axisLblFrame = CGRectMake(1, 1, self.bounds.size.width, self.bounds.size.height);
            break;
            
        case axisUnitTypeY:
            axisLblFrame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
            [_axisTextLabl setBackgroundColor:[UIColor lightGrayColor]];
            break;
    }
    [_axisTextLabl setNumberOfLines:0];
    [_axisTextLabl setFont:_axisFont];
    [_axisTextLabl setText:_axisTxt];
    [_axisTextLabl setTextColor:(_isActive)?_axisHighlitedColor:_axisDefaultColor];
    [_axisTextLabl setFrame:axisLblFrame];
    [_axisTextLabl setBackgroundColor:[UIColor whiteColor]];
  
}
- (void)setIsActive:(BOOL)isActive
{
    _isActive = isActive;
    [self layoutSubviews];
}
-(void)setAxisFont:(UIFont *)axisFont
{
    _axisFont = axisFont;
    [self layoutSubviews];
}
-(void)setAxisTxt:(NSString *)axisTxt
{
    _axisTxt = axisTxt;
    [self layoutSubviews];
}
-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [_lineAxisColor set];
    UIRectFill(rect);
}
@end
