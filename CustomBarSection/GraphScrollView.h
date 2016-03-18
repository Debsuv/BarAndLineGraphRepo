//
//  BarScrollView.h
//  CustomBarSection
//
//  Created by Debanjan Chakraborty on 22/01/15.
//  Copyright (c) 2015 Debanjan Chakraborty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UnitView.h"
#import "BarContainer.h"
@protocol graphScrollDelegate<NSObject>
@required
- (void)tappedAtBar:(NSDictionary *)tappedData;
- (void)tappedAtLine:(NSDictionary *)tappedData;
@optional
- (void)removeAllPopViews;
@end
@interface GraphScrollView : UIScrollView<barContainerDelegate>
{
    BarContainer *bContainer;
    UnitView *axisUnitView;
}
@property (nonatomic,readwrite) NSMutableArray *yArray,*xArray;
@property (nonatomic) graphType typeOfGraph;
@property (nonatomic, weak) id <graphScrollDelegate> graphDelegate;
@property (nonatomic) float barSpace,axisUnitHeight,axisWidth;
@property (nonatomic) NSArray *linePropertiesArray;
- (void)reloadView;
@end
