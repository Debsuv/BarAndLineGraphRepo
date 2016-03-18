//
//  CustomBar.h
//  CustomBarSection
//
//  Created by Debanjan Chakraborty on 20/01/15.
//  Copyright (c) 2015 Debanjan Chakraborty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@protocol barDelegate<NSObject>
@required
- (void)barTapped:(NSDictionary *)tappedData;
@end
@interface CustomBar : UIView
@property (nonatomic,strong) NSDictionary *dataDict;
@property (nonatomic) UIColor *colorToPaint,*txtColor;
@property (nonatomic) NSNumber *cornerRadius;
@property (nonatomic) UIFont *barFont;
@property (nonatomic,readwrite) barType typeOfBar;
@property (nonatomic, weak) id <barDelegate> delegate;
@end

