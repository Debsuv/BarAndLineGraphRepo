//
//  UIView+Customize.m
//  CustomBarSection
//
//  Created by Debanjan Chakraborty on 21/01/15.
//  Copyright (c) 2015 Debanjan Chakraborty. All rights reserved.
//

#import "UIView+Customize.h"

@implementation UIView (Customize)
//- (void)cornerTheEdgesWithRadius:(CGFloat) cornerRadius
//{
//    UIBezierPath *maskPath;
//    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
//                                     byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
//                                           cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
//    
//    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
//    shapeLayer.frame = self.bounds;
//    shapeLayer.path = maskPath.CGPath;
//    self.layer.mask = shapeLayer;
//}
- (void)cornerTheEdgesWithRadius:(CGFloat) cornerRadius andCorners:(NSArray *)corners
{
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                     byRoundingCorners:([corners[0] integerValue] | [corners[1] integerValue])
                                           cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = self.bounds;
    shapeLayer.path = maskPath.CGPath;
    self.layer.mask = shapeLayer;
}
@end
