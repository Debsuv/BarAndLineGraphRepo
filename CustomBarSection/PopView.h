//
//  PopView.h
//  CustomBarSection
//
//  Created by Debanjan Chakraborty on 30/01/15.
//  Copyright (c) 2015 Debanjan Chakraborty. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopView : UIView
@property (nonatomic) lineType typeOfLine;
@property (nonatomic) NSString *valueText;
@property (nonatomic) CGPoint startPt,endPt;
@end
