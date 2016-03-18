//
//  DropMenu.m
//  CustomBarSection
//
//  Created by Debanjan Chakraborty on 22/01/15.
//  Copyright (c) 2015 Debanjan Chakraborty. All rights reserved.
//

#import "DropMenu.h"

@interface DropMenu()

@end
@implementation DropMenu

- (instancetype)init
{
    self = [super init];
    if(self)
        [self setClipsToBounds:YES];
    return self;
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [[UIColor yellowColor] set];
    UIRectFill(rect);
}
-(void)layoutSubviews
{
    [self clearScreen];
    for (int j=0; j<[_dataArray count]; j++)
    {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, j*DROP_MENU_CELL_HEIGHT, self.bounds.size.width, DROP_MENU_CELL_HEIGHT)];
        [btn setTitle:_dataArray[j] forState:UIControlStateNormal];
        btn.layer.shadowColor = [UIColor grayColor].CGColor;
        btn.layer.shadowOffset = CGSizeMake(0, 1.0);
        btn.layer.shadowOpacity = 1.0;
        btn.layer.shadowRadius = 0.0;
        [self addSubview:btn];
    }
}
-(void)clearScreen
{
    for (UIView *sub in [self subviews])
        [sub removeFromSuperview];
}
@end
