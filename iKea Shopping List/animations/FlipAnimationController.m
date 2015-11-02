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
    
    NSArray* fromViewSnapshots = [self createSnapshots:fromVC.view afterScreenUpdates:NO];
    [fromVC.view removeFromSuperview ]; //remove from View from the hirerachy, use the snapshots instead.
    UIView* fromViewLeftSide = fromViewSnapshots[0];
    UIView* fromViewRightSide = fromViewSnapshots[1];
    
    [self updateAnchorPointAndOffset:CGPointMake(1, 1) view:fromViewRightSide];
    [self updateAnchorPointAndOffset:CGPointMake(0, 1) view:fromViewLeftSide];
    
    //toVC.view.layer.transform = CATransform3DMakeScale(1,1,0);
    toVC.view.layer.affineTransform = CGAffineTransformMakeScale(0, 0);
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    [UIView animateKeyframesWithDuration:duration delay:0 options:0 animations:^{
        
        [UIView addKeyframeWithRelativeStartTime:0.0
                                relativeDuration:1
                                      animations:^{
                                          // rotate the from view
                                          fromViewLeftSide.layer.transform = [self rotate:M_PI_2];
                                          fromViewRightSide.layer.transform = [self rotate:-M_PI_2];
                                      }];
        
        [UIView addKeyframeWithRelativeStartTime:0.5
                                relativeDuration:2.0
                                      animations:^{
                                          // scale up the to-view
                                          toVC.view.layer.affineTransform = CGAffineTransformMakeScale(1, 1);
                                      }];
        
    } completion:^(BOOL finished){
        [fromViewLeftSide removeFromSuperview];
        [fromViewRightSide removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];
    
    
}

- (CATransform3D) rotate:(CGFloat) angle {
    return  CATransform3DMakeRotation(angle, 0.0, 1.0, 0.0);
}

// updates the anchor point for the given view
/* Because the position is relative to the anchorPoint of the layer, changing 
 * that anchorPoint while maintaining the same position moves the layer.
 */
- (void)updateAnchorPointAndOffset:(CGPoint)anchorPoint view:(UIView*)view {
//    view.layer.anchorPoint = anchorPoint;
//    float yoffset =  anchorPoint.y - 0.5;
//    view.frame = CGRectOffset(view.frame, 0,yoffset * view.frame.size.height + 65);
    CGPoint oldOrigin = view.frame.origin;
    view.layer.anchorPoint = anchorPoint;
    CGPoint newOrigin = view.frame.origin;
    
    CGPoint transition;
    transition.x = newOrigin.x - oldOrigin.x;
    transition.y = newOrigin.y - oldOrigin.y;
    
    view.center = CGPointMake (view.center.x - transition.x, view.center.y - transition.y);
}

// creates a pair of snapshots from the given view
- (NSArray*)createSnapshots:(UIView*)view afterScreenUpdates:(BOOL) afterUpdates{
    UIView* containerView = view.superview;
    
    // snapshot the left-hand side of the view
    CGRect snapshotRegion = CGRectMake(0, 0, view.frame.size.width / 2, view.frame.size.height);
    UIView *leftHandView = [view resizableSnapshotViewFromRect:snapshotRegion  afterScreenUpdates:afterUpdates withCapInsets:UIEdgeInsetsZero];
    leftHandView.frame = snapshotRegion;
    [containerView addSubview:leftHandView];
    
    // snapshot the right-hand side of the view
    snapshotRegion = CGRectMake(view.frame.size.width / 2, 0, view.frame.size.width / 2, view.frame.size.height);
    UIView *rightHandView = [view resizableSnapshotViewFromRect:snapshotRegion  afterScreenUpdates:afterUpdates withCapInsets:UIEdgeInsetsZero];
    rightHandView.frame = snapshotRegion;
    [containerView addSubview:rightHandView];
    
    // send the view that was snapshotted to the back
    [containerView sendSubviewToBack:view];
    
    return @[leftHandView, rightHandView];
}


@end
