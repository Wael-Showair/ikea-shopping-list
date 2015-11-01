//
//  FlipAnimationController.m
//  iKea Shopping List
//
//  Created by Wael Showair on 2015-11-01.
//  Copyright © 2015 show0017@algonquinlive.com. All rights reserved.
//

#import "FlipAnimationController.h"

@implementation FlipAnimationController

#define TRANSITION_DURATION 2.5
-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return TRANSITION_DURATION;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{


    UIViewController* fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIViewController* toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView* containerView = [transitionContext containerView];
    
    // Add a perspective transform
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -0.002;
    [containerView.layer setSublayerTransform:transform];
    
    [containerView addSubview:toVC.view];
    // Give both VCs the same start frame
    CGRect initialFrame = [transitionContext initialFrameForViewController:fromVC];
    fromVC.view.frame =  initialFrame;
    toVC.view.frame = initialFrame;
    toVC.view.layer.transform = [self rotate:M_PI_2];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    [UIView animateKeyframesWithDuration:duration delay:0 options:0 animations:^{
    
        [UIView addKeyframeWithRelativeStartTime:0.0
                                relativeDuration:0.5
                                      animations:^{
                                          // rotate the from view
                                          fromVC.view.layer.transform = [self rotate:- M_PI_2];
                                      }];
        [UIView addKeyframeWithRelativeStartTime:0.5
                                relativeDuration:0.5
                                      animations:^{
                                          // rotate the to view
                                          toVC.view.layer.transform =  [self rotate:0.0];
                                      }];
        
    } completion:^(BOOL finished){
        [transitionContext completeTransition:YES];
    }];
    

}





- (CATransform3D) rotate:(CGFloat) angle {
    return  CATransform3DMakeRotation(angle, 0.0, 1.0, 0.0);
}

@end
