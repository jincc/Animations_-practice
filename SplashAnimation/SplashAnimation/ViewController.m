//
//  ViewController.m
//  SplashAnimation
//
//  Created by Jincc on 15/10/22.
//  Copyright © 2015年 Jincc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

{
   __weak UIView *maskBGview;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self animation];
    
    
}
- (void)animation{
    
    //首先这里，我们改了navi.view 一个遮罩物
    __weak UINavigationController *Navi = self.navigationController;
    
    CALayer *maskLayer = [CALayer layer];
    maskLayer.bounds = CGRectMake(0, 0, 100, 100);
    maskLayer.position = Navi.view.center;
    maskLayer.contents = (__bridge id _Nullable)([[UIImage imageNamed:@"logo"] CGImage]);
    Navi.view.layer.mask = maskLayer;
    
    //运行到这里，发现，首先背景是黑色的，还有能够通过mask看到后面的view的内容,所以这里我们首先应该修改window的背景颜色
    
    UIView *bgVIew = [[UIView alloc]initWithFrame:Navi.view.frame];
    bgVIew.backgroundColor = [UIColor whiteColor];
    [Navi.view addSubview:bgVIew];
    [Navi.view bringSubviewToFront:bgVIew];
    
    //logo mask animation
    CAKeyframeAnimation *logoMaskAnimaiton = [CAKeyframeAnimation animationWithKeyPath:@"bounds"];
    logoMaskAnimaiton.duration = 1.0f;
    logoMaskAnimaiton.beginTime = CACurrentMediaTime() + 1.0f;//延迟一秒
    
    CGRect initalBounds = maskLayer.bounds;
    CGRect secondBounds = CGRectMake(0, 0, 50, 50);
    CGRect finalBounds  = CGRectMake(0, 0, 2000, 2000);
    logoMaskAnimaiton.values = @[[NSValue valueWithCGRect:initalBounds],[NSValue valueWithCGRect:secondBounds],[NSValue valueWithCGRect:finalBounds]];
    logoMaskAnimaiton.keyTimes = @[@(0),@(0.5),@(1)];
    logoMaskAnimaiton.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    logoMaskAnimaiton.removedOnCompletion = NO;
    logoMaskAnimaiton.fillMode = kCAFillModeForwards;
    [Navi.view.layer.mask addAnimation:logoMaskAnimaiton forKey:@"logoMaskAnimaiton"];
    
    
    [UIView animateWithDuration:0.1 delay:1.35 options:UIViewAnimationOptionCurveLinear animations:^{
        bgVIew.alpha = 0;
    } completion:^(BOOL finished) {
        [bgVIew removeFromSuperview];
    }];
    
    
    [UIView animateWithDuration:0.1 delay:1.5 options:UIViewAnimationOptionCurveLinear animations:^{
        Navi.view.transform = CGAffineTransformMakeScale(1.05, 1.05);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.1 animations:^{
            Navi.view.transform =  CGAffineTransformIdentity;
        }];
    }];
    
}

@end
