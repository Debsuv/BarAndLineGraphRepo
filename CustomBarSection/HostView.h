//
//  HostView.h
//  CustomBarSection
//
//  Created by Debanjan Chakraborty on 27/01/15.
//  Copyright (c) 2015 Debanjan Chakraborty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HostView : UIView
@property (nonatomic) NSMutableArray *xArray,*yArray;
@property (nonatomic) NSArray *linePArray;
@property (nonatomic) graphType typeOfGraph;
@property (nonatomic) NSString *yAxisTitle,*xAxisTitle;
@property (nonatomic) UIFont *axisFont;
@property (nonatomic) NSInteger numOfyDivs;
@property (nonatomic) UIColor *axisColor;
-(void)drawTheGraph;
@end
