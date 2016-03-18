//
//  HostView.m
//  CustomBarSection
//
//  Created by Debanjan Chakraborty on 27/01/15.
//  Copyright (c) 2015 Debanjan Chakraborty. All rights reserved.
//
#import "PopView.h"
#import "GraphScrollView.h"
#import "HostView.h"

@interface HostView()<graphScrollDelegate,UIScrollViewDelegate>
@property (nonatomic) GraphScrollView *scrView;
@property (nonatomic) UILabel *xAxisLbl,*yAxisLbl;
@property (nonatomic) float axisSpace;
@property (nonatomic) UnitView *yAxisUnit;
@property (nonatomic) float chartCanvasHeight;

@end
@implementation HostView
-(instancetype)init
{
    self = [super init];
    if(self)
    {
        [self baseInit];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self baseInit];
    }
    return self;
}
- (void)baseInit
{
    _xArray = [NSMutableArray array];
    _yArray = [NSMutableArray array];
    _typeOfGraph = graphTypeBar;
    _axisFont = [UIFont systemFontOfSize:13.0f];
    
    _xAxisTitle=@"X-Axis";
    _yAxisTitle=@"Y-Axis";
    _axisSpace = 0.0;
    _numOfyDivs = 5;
    _axisColor = [UIColor blackColor];
    [self setClipsToBounds:YES];
}
#pragma mark Set The Arrays
-(void)setXArray:(NSMutableArray *)xArray
{
    _xArray = xArray;
}
-(void)setYArray:(NSMutableArray *)yArray
{
    _yArray = yArray;
}
#pragma mark Draw The Graph
-(void)drawTheGraph
{
    if(!_scrView)
    {
        //        Add The X Axis Label
        _xAxisLbl = [[UILabel alloc] initWithFrame:CGRectMake(100, self.bounds.size.height - 60, self.bounds.size.width-100, 40)];
        [_xAxisLbl setTextAlignment:NSTextAlignmentCenter];
        
        [_xAxisLbl setFont:_axisFont];
        [self addSubview:_xAxisLbl];
        
        
        _scrView = [[GraphScrollView alloc] initWithFrame:CGRectMake(_xAxisLbl.frame.origin.x, POP_VIEW_HEIGHT * 4, _xAxisLbl.bounds.size.width ,  _xAxisLbl.frame.origin.y - (POP_VIEW_HEIGHT * 4))];
        [_scrView setDelegate:self];
        [_scrView setGraphDelegate:self];
        [_scrView setBackgroundColor:[UIColor clearColor]];
        
        [self addSubview:_scrView];
        
        _chartCanvasHeight = (_scrView.frame.size.height -_scrView.axisUnitHeight);
        
       
        
        //        Add The Y Axis Label
        _yAxisLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, _scrView.frame.size.height/2-40, 40, 190)];
        [_yAxisLbl setFont:_axisFont];
        [_yAxisLbl setTextAlignment:NSTextAlignmentCenter];
        
        [_yAxisLbl setTransform:CGAffineTransformMakeRotation(-M_PI_2)];
        [self addSubview:_yAxisLbl];
        
    }
    
    [_scrView setTypeOfGraph:_typeOfGraph];
    
    [_yAxisLbl setText:_yAxisTitle];
    [_xAxisLbl setText:_xAxisTitle];
    
    if(_yArray.count>0)
    {
        [self setNeedsDisplay];
        [self addYAxexUnit];
    }
    
    [_scrView setXArray:_xArray];
    [_scrView setYArray:_yArray];
    [_scrView setLinePropertiesArray:_linePArray];
    [_scrView reloadView];
}

#pragma  mark FOR Y Axis
- (void)addYAxexUnit
{
    //    NSLog(@"_numOfyDivs is %ld",_numOfyDivs);
    //    NSLog(@" _yArray count is %ld",_yArray.count);
    
    float _maxYValue = 0.0f;
    switch (_typeOfGraph)
    {
        case graphTypeBar:
        {
            NSArray *maxMinArray = returnMaxAndMin(_yArray);
            
            _maxYValue = [maxMinArray[0] floatValue];
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
            
        }
            break;
    }
    
    
    float PPU = PPUWithMAX(_chartCanvasHeight,_maxYValue);
    
    _axisSpace = _chartCanvasHeight/_numOfyDivs;
    for (int j = 1; j < _numOfyDivs + 1; j++)
    {
        _yAxisUnit = (UnitView *)[self viewWithTag:kYUNIT_TAG_CONSTANTS+(j+1)];
        if(!_yAxisUnit)
        {
            _yAxisUnit = [[UnitView alloc] init];
            [_yAxisUnit setTypeOfAxis:axisUnitTypeY];
            [_yAxisUnit setIsActive:YES];
            [self addSubview:_yAxisUnit];
        }
        
        [_yAxisUnit setFrame:CGRectMake(30, _scrView.frame.origin.y + (_chartCanvasHeight - (j * _axisSpace + 7.5f)), 60, 15)];
        
        [_yAxisUnit setAxisTxt:[NSString stringWithFormat:@"$%.0f",ceilf((j*_axisSpace)/PPU)]];
    }
    
}


-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextClearRect(context, rect);
    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
    CGContextFillRect(context, rect);
    
    //    printf("%s",[NSStringFromCGRect(_scrView.bounds) UTF8String]);
    if(_scrView)
    {
        CGContextSetLineWidth(context, 1.0f);
        CGContextSetStrokeColorWithColor(context, _axisColor.CGColor);
        CGContextMoveToPoint(context, _scrView.frame.origin.x + 0.25f, _scrView.frame.origin.y);
        CGContextAddLineToPoint(context, _scrView.frame.origin.x + 0.25f, (_scrView.frame.size.height + _scrView.frame.origin.y) - (_scrView.axisUnitHeight));
        CGContextStrokePath(context);
        
        [self drawTheAxesUnitWithContext:context ];
    }
    
}
- (void)drawTheAxesUnitWithContext:(CGContextRef)context
{
    
    CGContextSetLineWidth(context, 1.0f);
    CGContextSetStrokeColorWithColor(context, _axisColor.CGColor);
    
    CGPoint beginPt = _scrView.frame.origin;
    
    _axisSpace = _chartCanvasHeight/_numOfyDivs;
    
    for (int i = 0; i<_numOfyDivs; i++)
    {
        CGContextMoveToPoint(context, beginPt.x, beginPt.y + (i * _axisSpace));
        CGContextAddLineToPoint(context, beginPt.x - 5, beginPt.y + (i * _axisSpace));
        CGContextStrokePath(context);
    }
}
#pragma mark Set Axis Title
-(void)setYAxisTitle:(NSString *)yAxisTitle
{
    _yAxisTitle=yAxisTitle;
}
- (void)setXAxisTitle:(NSString *)xAxisTitle
{
    _xAxisTitle=xAxisTitle;
}
#pragma mark GraphScrollView Delegate
-(void)tappedAtBar:(NSDictionary *)tappedData
{
    
}
-(void)tappedAtLine:(NSDictionary *)tappedData
{
    NSArray *lineData = tappedData[@"dataSent"];
    [self removeSelectedPopViewsWithDict:lineData];
    
    NSMutableArray *popFrameArray = [[self returnArrayOfPopRect] mutableCopy];
    
    for (NSDictionary *pData in lineData)
    {
        NSUInteger posOfData = [lineData indexOfObject:pData];
        
        float yVal = [pData[@"tappedVal"] floatValue];
        float xPos = [pData[@"point"][@"X"] floatValue];
        
        float yPos = [pData[@"point"][@"Y"] floatValue];
        
        float xBeg = [self convertPoint:CGPointMake(xPos, 0) fromView:_scrView].x;
        float yBeg = yPos + _scrView.frame.origin.y;
        
//        Calculation of rect for the popView
        CGFloat yPopView = _scrView.frame.origin.y - (((posOfData + 1) * POP_VIEW_HEIGHT) + 2.5f *posOfData);
        
        CGRect  tempRect = CGRectZero;
        CGRect finalRect = CGRectZero;
        
        tempRect = [self returnTappedRectForPt:CGPointMake(xBeg,yPopView)];

        for (id objRect in popFrameArray)
        {
            CGRect popFrame = CGRectFromString(objRect);
            if(CGRectIntersectsRect(tempRect, popFrame))
            {
                tempRect.origin.y -= (popFrame.size.height + 5);
                break;
            }
            
        }
        
        
        finalRect = tempRect;
        
        lineType typeOfLine = [pData[@"lineType"] integerValue];
        
//       Adding the The Connect lines
       
        CGPoint sPt = CGPointMake(xBeg, finalRect.origin.y + POP_VIEW_HEIGHT);
        CGPoint fPt = CGPointMake(xBeg, yBeg);
        
            [self.layer addSublayer:[self returnLayerForBeginPoint:sPt
                                                     andFinalPoint:fPt
                                                      withLineType:typeOfLine]];

       
        
//        Addition of PopView
        PopView *pView = [[PopView alloc] initWithFrame:finalRect];
        [pView setStartPt:sPt];
        [pView setEndPt:fPt];
        [pView setTypeOfLine:typeOfLine];
        [pView setValueText:[NSString stringWithFormat:@"$%.2f",yVal]];
        [self addSubview:pView];
        
        [popFrameArray addObject:NSStringFromCGRect(finalRect)];
    }
    
    
}
- (NSArray *)returnArrayOfPopRect
{
    NSMutableArray *arrayOfFrame = [NSMutableArray array];
    
    for (UIView *sub in self.subviews)
    {
        if([sub isKindOfClass:[PopView class]])
        {
            [arrayOfFrame addObject:NSStringFromCGRect(sub.frame)];
        }
    }
    
    return arrayOfFrame;
}

- (void)removeAllPopViews
{
    for (UIView *sub in self.subviews)
    {
        if([sub isKindOfClass:[PopView class]])
        {
            PopView *pV = (PopView *)sub;
            
            [self removeLineLayerForPath:[self returnbPthWithInitialPoint:pV.startPt
                                                            andFinalPoint:pV.endPt]];
            
            [pV removeFromSuperview];
        }
    }
}
#pragma mark Calculate X Point
- (CGRect)returnTappedRectForPt:(CGPoint )pt
{
    CGRect expectedRectPopOver = CGRectZero;
    
    
    CGFloat lineXOffSet = POP_VIEW_WIDTH/2;  //dotted line shows in middle
   
    CGFloat x = pt.x - lineXOffSet;
   
    expectedRectPopOver = CGRectMake(x, pt.y, POP_VIEW_WIDTH, POP_VIEW_HEIGHT);
    
    CGFloat maxSelfBoundX= CGRectGetMaxX(self.bounds);
    CGFloat minVisiblePopoverX = CGRectGetMinX(expectedRectPopOver);
    CGFloat maxVisiblePopoverX= CGRectGetMaxX(expectedRectPopOver);
    
    CGFloat axisOffsetX = _scrView.frame.origin.x;
    
    if( minVisiblePopoverX <= axisOffsetX)
    {
        //NSLog(@" crosses y Axis");
        // it does cross x axis
        // x of rect will shift to right
      
        x = pt.x;//ptData.x ;//
        x -= HIT_RADIUS;
        
    }
    else if(maxVisiblePopoverX > maxSelfBoundX )
    {
        //NSLog(@" doesn't crosses yAxis");
        // it does cross bound
        // x of rect will shift to left.
        
        x = pt.x - (maxVisiblePopoverX - maxSelfBoundX) -lineXOffSet;
    }
    
    expectedRectPopOver = CGRectMake(x, pt.y, POP_VIEW_WIDTH, POP_VIEW_HEIGHT);
    
    
    return expectedRectPopOver;
}
#pragma mark Line Functions
- (CAShapeLayer *)returnLayerForBeginPoint:(CGPoint)aPt
                             andFinalPoint:(CGPoint)fPt
                              withLineType:(lineType)typeOfLine
{
   
    
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    [lineLayer setPath:[[self returnbPthWithInitialPoint:aPt andFinalPoint:fPt] CGPath]];
    [lineLayer setStrokeColor:[(typeOfLine==lineTypeCurrent)?LINE_COLOR_CURRENT:LINE_COLOR_PROJECTED CGColor]];
    lineLayer.lineWidth = 1.55f;
    lineLayer.lineDashPattern = @[@2,@2];
//    lineLayer.lineDashPattern = (typeOfLine == lineTypeCurrent)?@[]:@[@2,@2];
    
    return lineLayer;
}
- (UIBezierPath *)returnbPthWithInitialPoint:(CGPoint)sPt andFinalPoint:(CGPoint)fPt
{
    UIBezierPath *bPath = [UIBezierPath bezierPath];
    [bPath moveToPoint:sPt];
    [bPath addLineToPoint:fPt];
    return bPath;
    
}
#pragma mark UIScrollView Delegate methods
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeAllPopViews];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}
#pragma mark Remove  PopUpViews
- (void)removeSelectedPopViewsWithDict:(NSArray *)popArray
{
    NSInteger numberOfCurrentPop = 0;
    NSInteger numberOfProjectedPop = 0;
    
    for (NSDictionary *dictObj in popArray)
    {
        switch ([dictObj[@"lineType"] integerValue])
        {
            case lineTypeCurrent:
                numberOfCurrentPop++;
                break;
            case lineTypeProjected:
                numberOfProjectedPop++;
                break;
            default:
                break;
        }
    }
    
    
    if(numberOfCurrentPop>0)
        [self removePopViewForLineType:lineTypeCurrent];
    if (numberOfProjectedPop>0)
        [self removePopViewForLineType:lineTypeProjected];
    
}
#pragma mark remove Selected PopViews And PopLines
- (void)removePopViewForLineType:(lineType)typeOfPop
{
    for (UIView *subV in self.subviews)
    {
        if([subV isKindOfClass:[PopView class]])
        {
            PopView *pV = (PopView *)subV;
            if(pV.typeOfLine == typeOfPop)
            {
                [self removeLineLayerForPath:[self returnbPthWithInitialPoint:pV.startPt
                                                                andFinalPoint:pV.endPt]];
                [pV removeFromSuperview];
            }
        }
    }
   
}
- (void)removeLineLayerForPath:(UIBezierPath *)bPath
{
    for (CAShapeLayer *layerObj in [self.layer.sublayers mutableCopy])
    {
        if([layerObj isKindOfClass:[CAShapeLayer class]] &&
           CGPathEqualToPath(layerObj.path, [bPath CGPath]))
        {
            [layerObj removeFromSuperlayer];
        }
    }
}

@end
