//
//  LoaderView.m
//  CAShapeLayer
//
//  Created by Artem Abramov on 20/04/15.
//  Copyright (c) 2015 E-Legion. All rights reserved.
//

#import "LoaderImageView.h"

static const CGFloat kLoaderViewRadius = 20.0f;

@interface LoaderImageView()

@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end

@implementation LoaderImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configure];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configure];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configure];
    }
    return self;
}

- (void)configure
{
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.lineWidth = 2.0f;
    shapeLayer.strokeEnd = 0.0f;
    shapeLayer.strokeStart = 0.0f;
    
    self.shapeLayer = shapeLayer;
    [self.layer addSublayer:shapeLayer];
}


- (CGRect)loaderFrame
{
    CGRect loaderFrame = CGRectMake(CGRectGetMidX(self.bounds) - CGRectGetMidX(self.shapeLayer.frame),
                                    CGRectGetMidY(self.bounds) - CGRectGetMidY(self.shapeLayer.frame),
                                    2 * kLoaderViewRadius, 2 * kLoaderViewRadius);
    return loaderFrame;
}

- (UIBezierPath *)loaderPath:(CGRect)rect
{
    return [UIBezierPath bezierPathWithOvalInRect:rect];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.shapeLayer.frame = CGRectMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds), kLoaderViewRadius * 2, kLoaderViewRadius * 2);
    self.shapeLayer.path = [self loaderPath:[self loaderFrame]].CGPath;
}

- (CGFloat)progress
{
    return self.shapeLayer.strokeEnd;
}

- (void)setProgress:(CGFloat)progress
{
    if (progress >= 1.0) {
        self.shapeLayer.strokeEnd = 1.0;
    } else if (progress <= 0) {
        self.shapeLayer.strokeEnd = 0;
    } else {
        self.shapeLayer.strokeEnd = progress;
    }
}

- (void)reveal
{
    [self.shapeLayer removeFromSuperlayer];
    [self.shapeLayer removeAllAnimations];
    self.layer.mask = self.shapeLayer;
    
    CGPoint center = self.center;
    CGFloat finalRadius = sqrt((center.x * center.x) + (center.y * center.y));
    CGRect outerRect = CGRectMake(center.x - finalRadius, center.y - finalRadius, finalRadius * 2, finalRadius * 2);
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:outerRect];
    
    CGPathRef fromPath = self.shapeLayer.path;
    CGFloat fromLineWidth = self.shapeLayer.lineWidth;
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    self.shapeLayer.lineWidth = finalRadius * 2;
    self.shapeLayer.path = path.CGPath;
    [CATransaction commit];
    

    CABasicAnimation *lineWidthAnimation = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(lineWidth))];
    lineWidthAnimation.fromValue = @(fromLineWidth);
    lineWidthAnimation.toValue = @(finalRadius * 2);
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(path))];
    pathAnimation.fromValue = (__bridge id)fromPath;
    pathAnimation.toValue = path;
    
    CAAnimationGroup *animatinoGroup = [[CAAnimationGroup alloc] init];
    animatinoGroup.duration = 10.0f;
    animatinoGroup.animations = @[pathAnimation, lineWidthAnimation];
    animatinoGroup.delegate = self;
    animatinoGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.shapeLayer addAnimation:animatinoGroup forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    self.layer.mask = nil;
}

@end
