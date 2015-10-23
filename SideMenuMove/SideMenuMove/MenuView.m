//
//  MenuView.m
//  SideMenuMove
//
//  Created by Jincc on 15/10/20.
//  Copyright © 2015年 Jincc. All rights reserved.
//

#import "MenuView.h"

CGFloat const kOffSetX =  50;
CGFloat const kDuration  = 0.3;
CGFloat const kHelpViewW = 40;
@interface MenuView()
{
    BOOL _isPush;
    UIWindow *_keyWindow;
    CGFloat _kWindowW;
    CGFloat _kWindowH;
    
    //subviews
    UIVisualEffectView  *_visualView;
    UIView *_helpTopView;
    UIView *_helpCenterView;
    
    NSInteger _animationCount;
    
    CGFloat _helpOffx;
}

@property (nonatomic ,strong)CADisplayLink *displayLink;
@end

@implementation MenuView
-(CADisplayLink *)displayLink{
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkAction)];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
    return _displayLink;
}
-(void)drawRect:(CGRect)rect{
    
    //重绘
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(self.frame.size.width-kOffSetX, 0)];
    
    [path addQuadCurveToPoint:CGPointMake(self.frame.size.width-kOffSetX, self.frame.size.height) controlPoint:CGPointMake(_keyWindow.frame.size.width/2+_helpOffx, _keyWindow.frame.size.height/2)];
    
    [path addLineToPoint:CGPointMake(0, self.frame.size.height)];
    [path closePath];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddPath(context, path.CGPath);
    [[UIColor blueColor] set];
    CGContextFillPath(context);
 
}
-(instancetype)init{
    if (self = [super init]) {
        
        _keyWindow = [[UIApplication sharedApplication]keyWindow];
        _kWindowW = _keyWindow.bounds.size.width;
        _kWindowH = _keyWindow.bounds.size.height;
        _animationCount = 0;
     
        
        //bg
        _visualView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        _visualView.frame = _keyWindow.bounds;
        _visualView.alpha = 0;
        [_keyWindow addSubview:_visualView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(popView)];
        tap.numberOfTapsRequired = 1;
        [_visualView addGestureRecognizer:tap];
        
        _helpTopView = [[UIView alloc]initWithFrame:CGRectMake(-40, 0, 40, 40)];
        _helpTopView.backgroundColor = [UIColor redColor];
        _helpTopView.hidden = YES;
        [_keyWindow addSubview:_helpTopView];
        
        _helpCenterView = [[UIView alloc]initWithFrame:CGRectMake(-40, CGRectGetHeight(_keyWindow.frame)/2 - 20, 40, 40)];
        _helpCenterView.backgroundColor = [UIColor yellowColor];
        _helpCenterView.hidden = YES;
        [_keyWindow addSubview:_helpCenterView];
        
        
        self.frame = CGRectMake(- _keyWindow.frame.size.width/2 - kOffSetX, 0, _keyWindow.frame.size.width/2+kOffSetX, _keyWindow.frame.size.height);
        self.backgroundColor = [UIColor clearColor];
        [_keyWindow insertSubview:self belowSubview:_helpTopView];
    }
    return self;
}

#pragma mark - Public
- (void) pop{
    if (!_isPush) {
        //弹出
        [self pushViewAnimation];
    }else{
        //收回
        [self popViewAnimation];
    }
}
- (void)displayLinkAction{
    
    CALayer *topLayer = _helpTopView.layer.presentationLayer;
    CALayer *cneterLayer = _helpCenterView.layer.presentationLayer;
    
    //frame
    CGRect topFrame = [[topLayer valueForKeyPath:@"frame"]CGRectValue];
    CGRect centerFrame = [[cneterLayer valueForKeyPath:@"frame"]CGRectValue];
    _helpOffx = topFrame.origin.x  - centerFrame.origin.x;
    NSLog(@"%f",_helpOffx);
    
    [self setNeedsDisplay];
}
- (void)pushViewAnimation{
     _isPush = true;
    //push
    [UIView animateWithDuration:kDuration animations:^{
        self.frame = self.bounds;
    }];
    //alph
    [UIView animateWithDuration:kDuration animations:^{
        _visualView.alpha = 1;
    } completion:^(BOOL finished) {

    }];
    //help spring animation
    [self beginAnimation];
    [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.9 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
        _helpTopView.center = CGPointMake(_keyWindow.center.x, _helpTopView.center.y);
    } completion:^(BOOL finished) {
        [self endAnimation];
    }];
     [self beginAnimation];
    [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _helpCenterView.center = CGPointMake(_keyWindow.center.x, _helpCenterView.center.y);
    } completion:^(BOOL finished) {
        [self endAnimation];
    }];

}
- (void)popViewAnimation{
    _isPush = false;
    
    
    CGFloat width = _kWindowW  / 2  + kOffSetX;
    [UIView animateWithDuration:kDuration animations:^{
        self.frame = CGRectMake(- width, 0, width, _kWindowH);
    }];
    [UIView animateWithDuration:kDuration animations:^{
        _visualView.alpha = 0;
    } completion:^(BOOL finished) {
        [_visualView removeFromSuperview];
    }];
    
    //help spring animation

    [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _helpTopView.center = CGPointMake(-kHelpViewW/2, _helpTopView.center.y);
    } completion:^(BOOL finished) {
    }];
    
    [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:2 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _helpCenterView.center = CGPointMake(-kHelpViewW/2, _helpCenterView.center.y);
    } completion:^(BOOL finished) {
  
    }];
    
}
- (void)beginAnimation{
    
    [self displayLink];
    _animationCount ++;
}
- (void)endAnimation{
      _animationCount --;
    if (_animationCount == 0) {
        [_displayLink invalidate];
        _displayLink = nil;
    }
}
- (void)popView{
    [self popViewAnimation];
  
}
@end
