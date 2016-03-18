//
//  BarContainer.h
//  CustomBarSection
//
//  Created by Debanjan Chakraborty on 02/02/15.
//  Copyright (c) 2015 Debanjan Chakraborty. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol barContainerDelegate <NSObject>
- (void)barContainerTapped:(NSDictionary *)tappedData;
@end
@interface BarContainer : UIView
@property (nonatomic, weak) id <barContainerDelegate> delegate;
@property (nonatomic,readwrite) NSArray *barArray;
@end
