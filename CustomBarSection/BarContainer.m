//
//  BarContainer.m
//  CustomBarSection
//
//  Created by Debanjan Chakraborty on 02/02/15.
//  Copyright (c) 2015 Debanjan Chakraborty. All rights reserved.
//
#import "CustomBar.h"
#import "BarContainer.h"
@interface BarContainer()<barDelegate>
{
    CustomBar *barObj;
}
@end
@implementation BarContainer
-(instancetype)init
{
    self = [super init];
    if(self)
    {
        [self baseInit];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self baseInit];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self baseInit];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSInteger barCounts = [_barArray count];
    
    for (NSDictionary *barDict in _barArray)
    {
        NSInteger pos = [_barArray indexOfObject:barDict];
        
        float heightToBeAchieved = [barDict[@"BarHeight"] floatValue];
        
        barObj = (CustomBar *)[self viewWithTag:kBAR_TAG_CONSTANTS+(pos+1)];
        
        if(!barObj)
        {
            barObj = [[CustomBar alloc] initWithFrame:CGRectZero];
            [barObj setDelegate:self];
            [barObj setTag:kBAR_TAG_CONSTANTS+(pos+1)];
            [self addSubview:barObj];
        }
       
        CGRect barFrame = CGRectMake(4, self.bounds.size.height-heightToBeAchieved, (self.bounds.size.width-8.0f)/barCounts, heightToBeAchieved );
        
        [barObj setFrame:barFrame];
        barType type = [barDict[@"barType"] integerValue];
        [barObj setTypeOfBar:type];
        
        [barObj setDataDict:@{
                                @"isHeaderAvailable":type==barTypeDefault?@NO:@YES,
                                @"cornerRadius":[NSNumber numberWithFloat:10.0f],
                                @"value":barDict[@"valueToBePrinted"],
                                @"bartype":[self returnStringForBarType:type]
                                }];

    }
}
#pragma mark Base Init
- (void)baseInit
{
    [self setUserInteractionEnabled:YES];
}
#pragma mark Set Bar Dictionary
- (void)setBarArray:(NSArray *)barArray
{
    _barArray = barArray;
    [self layoutSubviews];
}
#pragma mark Touch Event
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if([_delegate respondsToSelector:@selector(barContainerTapped:)])
    {
        [_delegate barContainerTapped:@{@"tag":[NSNumber numberWithInteger:self.tag]}];
    }
}
#pragma mark Custom Bar Delegate Methods
- (void)barTapped:(NSDictionary *)tappedData
{
    NSLog(@"barActual Data is %@",tappedData);
}
#pragma mark Simple functions
- (NSString *)returnStringForBarType:(int)barType
{
    NSString *returnStr;
    
    switch (barType)
    {
        case barTypeCurrent:
            returnStr = @"barTypeCurrent";
            break;
        case barTypeDefault:
            returnStr = @"barTypeDefault";
            break;
        case barTypeHighest:
            returnStr = @"barTypeHighest";
            break;
        case barTypeLowest:
            returnStr = @"barTypeLowest";
            break;
        default:
            break;
    }
    return returnStr;
}

@end
