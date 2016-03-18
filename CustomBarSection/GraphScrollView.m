//
//  BarScrollView.m
//  CustomBarSection
//
//  Created by Debanjan Chakraborty on 22/01/15.
//  Copyright (c) 2015 Debanjan Chakraborty. All rights reserved.
//

#import "HeaderView.h"
#import "CustomBar.h"
#import "GraphScrollView.h"
#import "PopView.h"

@interface GraphScrollView()<barDelegate>

@property (nonatomic,readwrite) NSMutableArray *barArray,*linePtsArray;
@property (nonatomic) float minYValue, maxYValue;
@property (nonatomic) CGPoint graphOrigin;
@end

@implementation GraphScrollView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self baseInit];
        
        [self setBounces:NO];
    }
    return self;
}

- (void)baseInit
{
    _yArray = [NSMutableArray array];
    _xArray = [NSMutableArray array];
    _barArray = [NSMutableArray array];
    
    _minYValue = MAXFLOAT;
    _maxYValue = -MAXFLOAT;
    
    _axisWidth = AXIS_WIDTH;
    _barSpace = BAR_SPACE;
    
    _axisUnitHeight = AXIS_UNIT_HEIGHT;
    _graphOrigin = CGPointMake(0, self.bounds.size.height-_axisUnitHeight);
    
}

-(void)setAxisUnitHeight:(float)axisUnitHeight
{
    _axisUnitHeight = axisUnitHeight;
    _graphOrigin = CGPointMake(0, self.bounds.size.height-_axisUnitHeight);
}
#pragma mark get Min and Max of Y Axis
-(void)setYArray:(NSMutableArray *)yArray
{
    _yArray = yArray;
    
    switch (_typeOfGraph)
    {
        case graphTypeBar:
        {
            NSArray *maxMinArray = returnMaxAndMin(_yArray);
            
            _maxYValue = [maxMinArray[0] floatValue];
            _minYValue = [maxMinArray[1] floatValue];
        }
            break;
            
        case graphTypeLine:
        {
            NSMutableArray *tempArray = [NSMutableArray array];
            NSInteger countOfDicts = 0;
           
            for (NSDictionary *dict in _yArray)
            {
                NSString *keyStr = [NSString stringWithFormat:@"Y"];
                NSArray *localArray = dict[keyStr];
    
                NSArray *maxMinArray = returnMaxAndMin(localArray);
                [tempArray addObject:maxMinArray[0]];
                [tempArray addObject:maxMinArray[1]];
                countOfDicts++;
            }
           
             NSArray *maxMinArray = returnMaxAndMin(tempArray);
            _maxYValue = [maxMinArray[0] floatValue];
            _minYValue = [maxMinArray[1] floatValue];
        }
            break;
    }
}
//- (NSArray *)returnMaxAndMind:(NSArray *)arrSortPointsY
//{
//    arrSortPointsY = [arrSortPointsY sortedArrayUsingSelector:@selector(compare:)];
//    NSNumber *maxY=[arrSortPointsY valueForKeyPath:@"@max.doubleValue"];
//    NSNumber *minY=[arrSortPointsY valueForKeyPath:@"@min.doubleValue"];
//    
//    return @[maxY,minY];
//}
-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextClearRect(context, rect);
    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
    CGContextFillRect(context, rect);
    
    CGContextSetLineWidth(context, 2.5f);
  
    switch (_typeOfGraph) {
        case graphTypeBar:
        {
            CGFloat dash[] = {1.75f, 1.75f};
            CGContextSetLineDash(context, 0.0, dash, 2);
            
            for (NSDictionary *dictObj in _barArray)
            {
                barType typeOfBar = [dictObj[@"barType"] integerValue];
                float yPoint = _graphOrigin.y - [dictObj[@"BarHeight"] floatValue];
                
                switch (typeOfBar)
                {
                    case barTypeCurrent:
                    {
                        [self drawTheLineWithContext:context AndColor:BAR_COLOR_CURRENT forYPoint:yPoint];
                    }
                        break;
                        
                    case barTypeHighest:
                    {
                        [self drawTheLineWithContext:context AndColor:BAR_COLOR_HIGHEST forYPoint:yPoint];
                    }
                        break;
                    case barTypeLowest:
                    {
                        [self drawTheLineWithContext:context AndColor:BAR_COLOR_LOWEST forYPoint:yPoint];
                    }
                        break;
                    default:
                        break;
                        
                }
            }
        }
            break;
            
        case graphTypeLine:
        {
        
        }
            break;
    }
}
#pragma mark Draw TheBarLines
-(void)drawTheLineWithContext:(CGContextRef )context AndColor:(UIColor *)lineColor forYPoint:(CGFloat)y
{
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    CGContextMoveToPoint(context, 0,y+BAR_HEADER_HEIGHT);
    
    CGContextAddLineToPoint(context, self.contentSize.width, y+BAR_HEADER_HEIGHT);
    CGContextStrokePath(context);
}
#pragma mark reloadView (This method is available publicly)
- (void)reloadView
{
    [self removePopV];
    [_graphDelegate removeAllPopViews];
    
    _linePtsArray = [NSMutableArray array];
    
    switch (_typeOfGraph)
    {
        case graphTypeBar:
        {
            [self hideTheBars];
            [self populateBars];
            
        }
            break;
            
        case graphTypeLine:
        {
             [self removeTheBars];
             [self populateLines];
        }
            break;
    }
    
    [self setNeedsDisplay];
    
}


#pragma mark Bar Delegate
-(void)barTapped:(NSDictionary *)tappedData
{
    if([_graphDelegate respondsToSelector:@selector(tappedAtBar:)])
        [_graphDelegate tappedAtBar:tappedData];
}

#pragma mark populatingBarGraphs
- (void)populateBars
{
   
    __block CGRect unitFrame = CGRectZero;
    _barArray = [[NSMutableArray alloc] init];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:GregorianCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitMonth) fromDate:[NSDate date]];
    
    [_xArray enumerateObjectsUsingBlock:^(NSNumber *numX, NSUInteger idx, BOOL *stop){
       
//        add XAxisUnit With BarContainer
        axisUnitView = (UnitView *)[self viewWithTag:kXUNIT_TAG_CONSTANTS+(idx+1)];
        
        if(!axisUnitView)
        {
            axisUnitView = [[UnitView alloc] initWithFrame:CGRectMake((idx==0)?unitFrame.origin.x:unitFrame.origin.x+_axisWidth, _graphOrigin.y, _axisWidth, _axisUnitHeight)];
            [axisUnitView setTypeOfAxis:axisUnitTypeX];
            [axisUnitView setTag:kXUNIT_TAG_CONSTANTS+(idx+1)];
            [self addSubview:axisUnitView];
        }
        [axisUnitView setIsActive:NO];
        [axisUnitView setAxisTxt:[NSString stringWithFormat:@"%@",numX]];
        unitFrame = axisUnitView.frame;
        
        
        bContainer = (BarContainer *)[self viewWithTag: kBAR_CONTAINER_TAG_CONSTANTS+(idx+1)];
        if(!bContainer)
        {
            bContainer = [[BarContainer alloc] initWithFrame:CGRectMake(unitFrame.origin.x, 0,  unitFrame.size.width, self.bounds.size.height-unitFrame.size.height)];
            [bContainer setBackgroundColor:[UIColor clearColor]];
            [bContainer setDelegate:self];
            [bContainer setTag:kBAR_CONTAINER_TAG_CONSTANTS+(idx+1)];
            [self addSubview:bContainer];
        }
        
        if(_yArray.count > idx)
        {
            [axisUnitView setIsActive:YES];
            NSNumber *yValue = _yArray[idx];
            
            
            float varHt = PPUWithMAX(_graphOrigin.y, _maxYValue)*yValue.floatValue;
            
            NSNumber *minYValueNumber = [NSNumber numberWithFloat:_minYValue];
            NSNumber *maxYValueNumber = [NSNumber numberWithFloat:_maxYValue];
            
            barType type = ([yValue isEqualToNumber:minYValueNumber]) ? barTypeLowest :(([yValue isEqualToNumber:maxYValueNumber])?barTypeHighest:barTypeDefault);
            
            if(idx+1==[components month])
            {
                type = barTypeCurrent;
            }
            
            NSDictionary *dictForBar = @{@"BarHeight":[NSNumber numberWithFloat:varHt],
                                        @"x_Value" :numX,
                                        @"barType" :[NSNumber numberWithInteger:type],
                                        @"valueToBePrinted":[NSString stringWithFormat:@"$%@",yValue]
                                        };
            [bContainer setBarArray:@[dictForBar]];
            [bContainer setHidden:NO];
            [_barArray addObject:dictForBar];
        }
    }];
//    NSLog(@" _yArray.count is %ld and _barArray count is %ld",_yArray.count,_barArray.count);
//    NSLog(@"_barArray is %@",_barArray);
//    NSLog(@" max is %.2f and min is %.2f",_maxYValue,_minYValue);
    [self setContentSize:CGSizeMake(unitFrame.origin.x+unitFrame.size.width, _graphOrigin.y)];
}
#pragma mark CustomBar methods
- (void)hideTheBars
{
   for (UIView *bar in self.subviews)
   {
       if([bar isKindOfClass:[BarContainer class]])
       {
           [bar setHidden:YES];
       }
   }
}
- (void)removeTheBars
{
    for (UIView *bar in self.subviews)
    {
        if([bar isKindOfClass:[BarContainer class]])
        {
            [bar removeFromSuperview];
        }
    }
}

#pragma mark LineGraph Methods
- (void)populateLines
{
    __block CGRect unitFrame = CGRectZero;
    [_xArray enumerateObjectsUsingBlock:^(NSNumber *numX, NSUInteger idx, BOOL *stop){
        
//         add XAxisUnit
        axisUnitView = (UnitView *)[self viewWithTag:kXUNIT_TAG_CONSTANTS+(idx+1)];
        
        if(!axisUnitView)
        {
            axisUnitView = [[UnitView alloc] initWithFrame:CGRectMake((idx==0)?unitFrame.origin.x:unitFrame.origin.x+_axisWidth, _graphOrigin.y, _axisWidth, _axisUnitHeight)];
            [axisUnitView setTypeOfAxis:axisUnitTypeX];
            [axisUnitView setTag:kXUNIT_TAG_CONSTANTS+(idx+1)];
            [self addSubview:axisUnitView];
        }
        [axisUnitView setIsActive:NO];
        [axisUnitView setAxisTxt:[NSString stringWithFormat:@"%@",numX]];
        unitFrame = axisUnitView.frame;
    }];
     [self setContentSize:CGSizeMake(unitFrame.origin.x+unitFrame.size.width, _graphOrigin.y)];
    
    for (NSDictionary *dict in _yArray)
    {
        NSInteger posOfDict = [_yArray indexOfObject:dict];
        NSDictionary *propertyDict = _linePropertiesArray[posOfDict];
       
        NSArray *localYPointArray = dict[@"Y"];
        
        CGPoint prevPt = _graphOrigin;
        
        for (NSNumber *yValue in localYPointArray)
        {
            NSInteger pos = [localYPointArray indexOfObject:yValue];
            
            axisUnitView = (UnitView *)[self viewWithTag:kXUNIT_TAG_CONSTANTS+(pos+1)];
            unitFrame = axisUnitView.frame;
            
            
            lineType typeOfLine = [propertyDict[@"lineType"] integerValue];
            
            [axisUnitView setIsActive:YES];
            
            float newY = PPUWithMAX(_graphOrigin.y, _maxYValue)*yValue.floatValue;
            float newX = unitFrame.origin.x + unitFrame.size.width/2;
            
//            This is done so that two points may not coincide. The value is determined according to the Y position, x position is not important , hence this is implemented.
            newX += (typeOfLine == lineTypeCurrent)?HIT_DIAMETER:(- HIT_DIAMETER);
            
            
            
            CGPoint newPt = CGPointMake(newX, newY);
            
            
            UIBezierPath *pPath = [UIBezierPath bezierPath];
            [pPath moveToPoint:prevPt];
            [pPath addLineToPoint:newPt];
            
            
            CAShapeLayer *lineLayer = [CAShapeLayer layer];
            [lineLayer setPath:[pPath CGPath]];
            [lineLayer setStrokeColor:[(typeOfLine==lineTypeCurrent)?LINE_COLOR_CURRENT:LINE_COLOR_PROJECTED CGColor]];
            lineLayer.lineWidth = 2.5;
            lineLayer.lineJoin = kCALineJoinRound;
            lineLayer.name = (typeOfLine == lineTypeCurrent)?CURRENT_LINE_STR:PROJECTED_LINE_STR;
            
            if([propertyDict[@"isDashed"] boolValue])
            {
                lineLayer.lineDashPattern = @[@2,@2];
            }
            
            
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            shapeLayer.anchorPoint = CGPointMake(newX, newY);
            shapeLayer.path = [[self makeCircleAtLocation:CGPointMake(newX, newY) radius:HIT_RADIUS] CGPath];
            shapeLayer.strokeColor = [(typeOfLine==lineTypeCurrent)?LINE_COLOR_CURRENT:LINE_COLOR_PROJECTED CGColor];
            shapeLayer.fillColor = [(typeOfLine==lineTypeCurrent)?LINE_COLOR_CURRENT:LINE_COLOR_PROJECTED CGColor];
            shapeLayer.lineWidth = HIT_RADIUS;
            shapeLayer.name = CIRCLE_POINT_STR;
            shapeLayer.shouldRasterize = YES;
            
        
            [self.layer addSublayer:shapeLayer];
            [self.layer addSublayer:lineLayer];
            
            prevPt = newPt;
        }
    }
}

#pragma mark Circle at Points
- (UIBezierPath *)makeCircleAtLocation:(CGPoint)location radius:(CGFloat)radius
{
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:location
                    radius:radius
                startAngle:0.0
                  endAngle:M_PI * 2.0
                 clockwise:YES];
    
    return path;
}
#pragma mark Touch Events
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

//    [_graphDelegate removeAllPopViews];
    if(_typeOfGraph== graphTypeLine)
    {
        UITouch *touch = [touches anyObject];
        CGPoint tapLocation = [touch locationInView:self];
        [self checkForPointsWithPoint:tapLocation];
    }
    
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_graphDelegate removeAllPopViews];
}
#pragma mark Draw The DottedLine
- (void)checkForPointsWithPoint:(CGPoint)pt
{
    float maxX = pt.x + (HIT_DIAMETER*0.65);
    float minX = pt.x - (HIT_DIAMETER*0.65);
    
    float minY = pt.y - (HIT_DIAMETER*0.65);
    float maxY = pt.y + (HIT_DIAMETER*0.65);
    
     NSMutableArray *delegateDataArray = [NSMutableArray array];
    
    CGRect tappedRect = CGRectMake(minX, minY, maxX - minX, maxY-minY);
    
    for (CAShapeLayer *layerObj in [self.layer.sublayers mutableCopy])
    {
        if([layerObj isKindOfClass:[CAShapeLayer class]] && [[layerObj name] isEqualToString:CIRCLE_POINT_STR])
        {
            if(CGRectContainsPoint(tappedRect, layerObj.anchorPoint))
            {
                CGPoint ptSelected = layerObj.anchorPoint;
                
                lineType typeOfLine = lineTypeCurrent;
                UIColor *lColor = [UIColor colorWithCGColor:layerObj.strokeColor];
                
                if([lColor isEqual:LINE_COLOR_CURRENT])
                    typeOfLine = lineTypeCurrent;
                else if ([lColor isEqual:LINE_COLOR_PROJECTED])
                    typeOfLine = lineTypeProjected;
                
                float yVal = ((float)(_graphOrigin.y - ptSelected.y)/(float)PPUWithMAX(_graphOrigin.y, _maxYValue));
                
//                UIBezierPath *bPath = [UIBezierPath bezierPath];
//                [bPath moveToPoint:CGPointMake(ptX, ptSelected.y)];
//                [bPath addLineToPoint:CGPointMake(ptX, 0)];
//                
//                CAShapeLayer *lineLayer = [CAShapeLayer layer];
//                [lineLayer setPath:[bPath CGPath]];
//                [lineLayer setStrokeColor:[(typeOfLine==lineTypeCurrent)?LINE_COLOR_CURRENT:LINE_COLOR_PROJECTED CGColor]];
//                lineLayer.lineWidth = 2.5;
//                lineLayer.name = POP_LINE_STR;
//                lineLayer.lineDashPattern = @[@2,@2];
//                [self.layer addSublayer:lineLayer];
                
                
                NSDictionary *dict = @{@"tappedVal":[NSNumber numberWithFloat:yVal],
                                       @"lineType":[NSNumber numberWithInteger:typeOfLine],
                                       @"point":@{
                                               @"X":[NSNumber numberWithFloat:pt.x],
                                               @"Y":[NSNumber numberWithFloat:pt.y]
                                               }
                                       };
                
                [delegateDataArray addObject:dict];
                

            }
        }
    }
 
    if(delegateDataArray.count > 0)
    {
        if([_graphDelegate respondsToSelector:@selector(tappedAtLine:)])
        {
            [_graphDelegate tappedAtLine:@{@"dataSent":delegateDataArray}];
        }
    }
    else
    {
        [_graphDelegate removeAllPopViews];
    }
}



-(BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    NSLog(@"popoverControllerShouldDismissPopover");
    return YES;
}

#pragma mark
-(NSString *)strForTypeOfLine:(lineType)type
{
    return (type==lineTypeCurrent)?@"Current":@"Projected";
}
- (void)removePopV
{
    for (CAShapeLayer *layerObj in [self.layer.sublayers mutableCopy])
    {
        if([layerObj isKindOfClass:[CAShapeLayer class]])
        {
            [layerObj removeFromSuperlayer];
        }
        
    }
//    (_pView)?[_pView removeFromSuperview]:@"";
//    _pView = nil;
    
}
#pragma mark BarContainer Delegate
- (void)barContainerTapped:(NSDictionary *)tappedData
{
    NSLog(@"%@ was tapped",tappedData[@"tag"]);
}
//- (NSInteger )returnPosInArrayForFrame:(CGRect )rectFrame
//{
//    NSInteger tagOfX = 0;
//    UnitView *toReturn = nil;
//    for (UIView *subV in self.subviews)
//    {
//        if(CGRectEqualToRect(subV.frame, rectFrame))
//        {
//            toReturn = (UnitView *)subV;
//            tagOfX = toReturn.tag - (kXUNIT_TAG_CONSTANTS+1);
//        }
//    }
//    return tagOfX;
//}
@end
