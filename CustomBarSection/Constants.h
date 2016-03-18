//
//  Constants.h
//  CustomBarSection
//
//  Created by Debanjan Chakraborty on 21/01/15.
//  Copyright (c) 2015 Debanjan Chakraborty. All rights reserved.
//

#ifndef CustomBarSection_Constants_h
#define CustomBarSection_Constants_h


typedef NS_ENUM(NSUInteger, barType)
{
    barTypeDefault = 0,
    barTypeCurrent,
    barTypeHighest,
    barTypeLowest
};

typedef NS_ENUM(NSUInteger, graphType)
{
    graphTypeBar = 0,
    graphTypeLine
};

typedef NS_ENUM(NSUInteger, iconType)
{
    upArrow = 0,
    downArrow
};

typedef NS_ENUM(NSUInteger, axisUnitType)
{
    axisUnitTypeX = 0,
    axisUnitTypeY
};
typedef NS_ENUM(NSUInteger, lineType)
{
    lineTypeCurrent = 0,
    lineTypeProjected
};
#define RGB(r,g,b) [UIColor colorWithRed:((float) r/255.0f) green:((float) g/255.0f) blue:((float) b/255.0f) alpha:1.0f]

#define BAR_HEADER_COLOR_CURRENT RGB(35.0f,81.0f,143.0f)
#define BAR_HEADER_COLOR_HIGHEST RGB(17.0f,95.0f,58.0f)
#define BAR_HEADER_COLOR_LOWEST  RGB(112.0f,18.0f,22.0f)

#define BAR_COLOR_DEFAULT RGB(139.0f,139.0f,139.0f)
#define BAR_COLOR_HIGHEST RGB(24.0f,152.0f,89.0f)
#define BAR_COLOR_LOWEST RGB(189.0f,51.0f,55.0f)
#define BAR_COLOR_CURRENT RGB(52.0f,125.0f,220.0f)
#define BAR_TEXT_COLOR RGB(255.0f,255.0f,255.0f)

#define BAR_CORNER_RADIUS 3

#define kBAR_CONTAINER_TAG_CONSTANTS 10000
#define kXUNIT_TAG_CONSTANTS 2000
#define kBAR_TAG_CONSTANTS 3000
#define kSHAPE_LAYER_TAG_CONSTANTS 4000
#define kYUNIT_TAG_CONSTANTS 5000


#define AXIS_WIDTH 170
#define BAR_SPACE 8
#define BAR_HEADER_HEIGHT 20

#define BAR_MIN_HEIGHT 50

#define AXIS_COLOR RGB(0,0,0)
#define AXIS_UNIT_HEIGHT 40
//#define AXIS_Y_SPACE 150

#define LINE_COLOR_CURRENT RGB(94,151,228)
#define LINE_COLOR_PROJECTED RGB(77,181,132)

#define LINE_CURRENT_TITLE @"Sales To Date"
#define LINE_PROJECTED_TITLE @"Projected Sales"

#define PPUWithMAX(h,y) ((float) h/((float) y*1.05f))

#ifdef __IPHONE_8_0
#define GregorianCalendar NSCalendarIdentifierGregorian
#else
#define GregorianCalendar NSGregorianCalendar
#endif


#define POP_VIEW_WIDTH  300
#define POP_VIEW_HEIGHT 25

#define HIT_DIAMETER 15
#define HIT_RADIUS HIT_DIAMETER/2

#define POP_LINE_CURRENT_STR @"PopLineCurrent"
#define POP_LINE_PROJECTED @"PopLineProjected"
#define CIRCLE_POINT_STR @"CirclePoint"
#define CURRENT_LINE_STR @"CurrentLine"
#define PROJECTED_LINE_STR @"ProjectedLine"
CG_INLINE NSArray*
returnMaxAndMin(NSArray *arrSortPointsY)
{
    arrSortPointsY = [arrSortPointsY sortedArrayUsingSelector:@selector(compare:)];
    NSNumber *maxY=[arrSortPointsY valueForKeyPath:@"@max.doubleValue"];
    NSNumber *minY=[arrSortPointsY valueForKeyPath:@"@min.doubleValue"];
    
    return @[maxY,minY];
}

CG_INLINE BOOL
isWithIn(CGFloat valToSearch, CGFloat maxVal, CGFloat minVal, bool includeBoundaries)
{
    if (includeBoundaries)
        return valToSearch <= maxVal && valToSearch >= minVal;
    
     return valToSearch < maxVal && valToSearch > minVal;
}
#endif
