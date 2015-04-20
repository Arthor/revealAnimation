//
//  ViewController.m
//  CAShapeLayer
//
//  Created by Artem Abramov on 20/04/15.
//  Copyright (c) 2015 E-Legion. All rights reserved.
//

#import "ViewController.h"
#import "LoaderImageView.h"
#import <DFImageManager/DFImageManager.h>
#import <DFImageManager/DFImageRequestOptions.h>
#import <DFURLImageFetcher.h>
#import <DFImageManager/DFImageRequest.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet LoaderImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    NSURL *url = [NSURL URLWithString:@"http://www.raywenderlich.com/wp-content/uploads/2015/02/mac-glasses.jpeg"];
    DFImageRequestOptions *options = [DFImageRequestOptions new];
    options.progressHandler = ^(double progress) {
        NSLog(@"Progress: %g", progress);
        self.imageView.progress = progress;
    };
    options.userInfo = @{ DFURLRequestCachePolicyKey : @(NSURLRequestReloadIgnoringCacheData) };
    DFImageRequest *request = [DFImageRequest requestWithResource:url targetSize:self.imageView.bounds.size contentMode:DFImageContentModeAspectFit options:options];
    [[DFImageManager sharedManager] requestImageForRequest:request completion:^(UIImage *image, NSDictionary *info) {
        self.imageView.image = image;
        [self.imageView reveal];
        NSLog(@"Fetched");
    }];
    

    
    CAShapeLayer *test = [CAShapeLayer new];
    test.frame = CGRectMake(10, 300, 100, 100);
    test.strokeColor = [UIColor greenColor].CGColor;
    test.path = [UIBezierPath bezierPathWithOvalInRect:test.bounds].CGPath;
    [self.view.layer addSublayer:test];
    
    CABasicAnimation *increaseStrokeSize = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(lineWidth))];
    increaseStrokeSize.toValue = @(100.0f);
    increaseStrokeSize.duration = 10.0f;
    [test addAnimation:increaseStrokeSize forKey:nil];
}

@end
