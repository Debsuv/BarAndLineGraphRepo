//
//  UnitView.h
//  CustomBarSection
//
//  Created by Debanjan Chakraborty on 27/01/15.
//  Copyright (c) 2015 Debanjan Chakraborty. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UnitView : UIView
@property (nonatomic) axisUnitType typeOfAxis;
@property (nonatomic) UIColor *axisDefaultColor,*axisHighlitedColor,*lineAxisColor;
@property (nonatomic) NSString *axisTxt;
@property (nonatomic) UIFont *axisFont;
@property (nonatomic) BOOL isActive;
@end
