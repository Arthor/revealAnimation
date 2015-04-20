//
//  LoaderView.h
//  CAShapeLayer
//
//  Created by Artem Abramov on 20/04/15.
//  Copyright (c) 2015 E-Legion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoaderImageView : UIImageView

@property (nonatomic, assign) CGFloat progress;
- (void)reveal;

@end
