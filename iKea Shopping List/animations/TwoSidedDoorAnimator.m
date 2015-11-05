/*!
 *  @file TwoSidedDoorAnimator.m
 *  implementation file that provides all the needed functionalities for an 
 *  animation controller to open or close a view as two sided door.
 *
 *  @author Wael Showair (showair.wael\@gmail.com)
 *  @version 0.0.1
 *  @copyright 2015. Wael Showair. All rights reserved.
 */

#import "TwoSidedDoorAnimator.h"


@interface TwoSidedDoorAnimator()

/*!
 *  @define SCALE_ANIMATION_KEY_FRAME_DURATION
 *  @abstract Total duration (in seconds) of the scale up/down animation.
 */
#define SCALE_ANIMATION_KEY_FRAME_DURATION                  1.0

/*!
 *  @define ROTATION_ANIMATION_KEY_FRAME_DURATION
 *  @abstract Total duration (in seconds) of the rotation animation.
 */
#define ROTATION_ANIMATION_KEY_FRAME_DURATION               1.0

/*!
 *  @define FIRST_ANIMATION_START_TIME
 *  @abstract Relative start time of the first animation which is rotation (in 
 *  case of forward animation) or scale (in case of reserved animation).
 */
#define FIRST_ANIMATION_START_TIME                          0.0

/*!
 *  @define SECOND_ANIMATION_RELATIVE_START_TIME
 *  @abstract Relative start time of the second animation. It ranges from 0 to 1
 *
 *  The animation might be rotation (in case of forward animation) or scale (in 
 *  case of reserved animation).
 */
#define SECOND_ANIMATION_RELATIVE_START_TIME                0.5

/*!
 *  @define TRANSITION_DURATION
 *  @abstract Total duration of the animation in seconds. It is summation of 
 *  duration of scale animation keyframe and duration of rotation animation 
 *  keyframe.
 */
#define TRANSITION_DURATION (SCALE_ANIMATION_KEY_FRAME_DURATION +\
                            ROTATION_ANIMATION_KEY_FRAME_DURATION)

/*!
 *  @property statusBarHeight
 *  @abstract Height of status bar (in points).
 */
@property CGFloat statusBarHeight;

/*!
 *  @property navigationBarHeight
 *  @abstract Height of navigation bar (in points).
 */
@property CGFloat navigationBarHeight;

/*!
 *  @abstract UIKit asks the animator for the duration (in seconds) of the 
 *  transition animation.
 *  @param transitionContext The context object containing information to use 
 *  during the transition.
 *
 *  @return The duration, in seconds, of the custom transition animation.
 */
-(NSTimeInterval)transitionDuration:
    (id<UIViewControllerContextTransitioning>)transitionContext;

/*!
 *  @abstract UIKit asks the animator to perform the transition animations
 *  @param transitionContext The context object containing information about the
 *  transition.
 */
-(void)animateTransition:
    (id<UIViewControllerContextTransitioning>)transitionContext;

/*!
 *  @abstract Change the anchor point for a specific view.
 *
 *  @param anchorPoint
 *      location of the new anchor point.
 *  @param view
 *      the view object whose anchor point would be changed.
 *  @discussion Because the position in Core Animation is relative to the 
 *  anchorPoint of the layer, changing the anchorPoint while maintaining the 
 *  same position moves the layer. Compensation for such movement is dont with 
 *  taking care of status/navigation bars as well.
 */
- (void)updateAnchorPoint:(CGPoint)anchorPoint forView:(UIView*)view;

/*!
 *  @abstract create a pair of snapshots from the given view.
 *
 *  @param view
 *      the view from which snapshots are taken.
 *  @param afterUpdates
 *      A Boolean value that specifies whether the snapshot should be taken 
 *      after recent changes have been incorporated.
 *
 *  @return snapshots
 *      Array of two snapshots the left-hand side snapshot. of the view is at 
 *      first index while the second index contains the right-hand side snapshot
 *      of the view.
 */
- (NSArray*)createSnapshots:(UIView*)view
         afterScreenUpdates:(BOOL) afterUpdates;
@end


@implementation TwoSidedDoorAnimator



-(NSTimeInterval)transitionDuration:
    (id<UIViewControllerContextTransitioning>)transitionContext
{
    return TRANSITION_DURATION;
}

-(void)animateTransition:
    (id<UIViewControllerContextTransitioning>)transitionContext
{

    CGAffineTransform initialScaleTransform, finalScaleTransform;
    CGFloat leftSideRotationAngle, rightSideRotationAngle;
    UIView *leftSideView,*rightSideView;

    UIViewController* fromVC =
    [transitionContext
    viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIViewController* toVC =
    [transitionContext
     viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView* containerView = [transitionContext containerView];
    
    // Add a perspective transform
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -0.002;
    [containerView.layer setSublayerTransform:transform];
    
    [containerView addSubview:toVC.view];
    // Give both VCs the same start frame
    CGRect initialFrame = [transitionContext
                           initialFrameForViewController:fromVC];
    fromVC.view.frame =  initialFrame;
    toVC.view.frame = initialFrame;
    
    if(fromVC.navigationController){
        self.navigationBarHeight =
            fromVC.navigationController.navigationBar.frame.size.height;
    }else{
        self.navigationBarHeight = 0;
    }
    
    if(self.isReversed){
        initialScaleTransform  = CGAffineTransformMakeScale(1, 1);
        finalScaleTransform    = CGAffineTransformMakeScale(0, 0);
        leftSideRotationAngle  = M_PI_2;
        rightSideRotationAngle = -M_PI_2;

        NSArray* toViewSnapshots = [self createSnapshots:toVC.view
                                      afterScreenUpdates:NO];

        //remove to-View from the hirerachy, use the snapshots instead.
        [toVC.view removeFromSuperview ];
        leftSideView = toViewSnapshots[0];
        rightSideView = toViewSnapshots[1];

        fromVC.view.layer.affineTransform = initialScaleTransform;
        [self updateAnchorPoint:CGPointMake(1, 1) forView:rightSideView];
        [self updateAnchorPoint:CGPointMake(0, 1) forView:leftSideView];

        leftSideView.layer.transform =
            [self rotateYAxisToAngle:leftSideRotationAngle];
        rightSideView.layer.transform =
            [self rotateYAxisToAngle:rightSideRotationAngle];
        
    }else{
        
        initialScaleTransform = CGAffineTransformMakeScale(0, 0);
        finalScaleTransform   = CGAffineTransformMakeScale(1, 1);
        leftSideRotationAngle = M_PI_2;
        rightSideRotationAngle = -M_PI_2;
        
        NSArray* fromViewSnapshots = [self createSnapshots:fromVC.view
                                        afterScreenUpdates:NO];

        //remove from-View from the hirerachy, use the snapshots instead.
        [fromVC.view removeFromSuperview ];
        leftSideView = fromViewSnapshots[0];
        rightSideView = fromViewSnapshots[1];
        
        toVC.view.layer.affineTransform = initialScaleTransform;
        [self updateAnchorPoint:CGPointMake(1, 1) forView:rightSideView];
        [self updateAnchorPoint:CGPointMake(0, 1) forView:leftSideView];
    }
    

    NSTimeInterval duration = [self transitionDuration:transitionContext];
    

    [UIView animateKeyframesWithDuration:duration
                                   delay:0
                                 options:0
                              animations:^{

        if(self.isReversed){
            [UIView addKeyframeWithRelativeStartTime:FIRST_ANIMATION_START_TIME
                                    relativeDuration:SCALE_ANIMATION_KEY_FRAME_DURATION
                                          animations:^{
                                              // scale down the from-view
                                              fromVC.view.layer.affineTransform = finalScaleTransform;

                                          }];
            
            [UIView addKeyframeWithRelativeStartTime:SECOND_ANIMATION_RELATIVE_START_TIME
                                    relativeDuration:ROTATION_ANIMATION_KEY_FRAME_DURATION
                                          animations:^{
                                              // rotate the to-view
                                              leftSideView.layer.transform = [self rotateYAxisToAngle:0.0];
                                              rightSideView.layer.transform = [self rotateYAxisToAngle:0.0];
                                              
                                          }];
            
        }else{
            
            [UIView addKeyframeWithRelativeStartTime:FIRST_ANIMATION_START_TIME
                                    relativeDuration:ROTATION_ANIMATION_KEY_FRAME_DURATION
                                          animations:^{
                                              // rotate the from view
                                              leftSideView.layer.transform = [self rotateYAxisToAngle:leftSideRotationAngle];
                                              rightSideView.layer.transform = [self rotateYAxisToAngle:rightSideRotationAngle];
                                          }];
        
            [UIView addKeyframeWithRelativeStartTime:SECOND_ANIMATION_RELATIVE_START_TIME
                                    relativeDuration:SCALE_ANIMATION_KEY_FRAME_DURATION
                                          animations:^{
                                              // scale up the to-view
                                              toVC.view.layer.affineTransform = finalScaleTransform;
                                          }];
        }/* else */
    } completion:^(BOOL finished){
        [leftSideView removeFromSuperview];
        [rightSideView removeFromSuperview];
        [transitionContext completeTransition:YES];

        if(self.isReversed){
            [containerView addSubview:toVC.view];
        }
    }];
    
    
}


- (CATransform3D) rotateYAxisToAngle:(CGFloat) angle {
    return  CATransform3DMakeRotation(angle, 0.0, 1.0, 0.0);
}

- (void)updateAnchorPoint:(CGPoint)anchorPoint forView:(UIView*)view{
//    view.layer.anchorPoint = anchorPoint;
//    float yoffset =  anchorPoint.y - 0.5;
// view.frame=CGRectOffset(view.frame, 0,yoffset * view.frame.size.height + 65);
    
    /*
     * Ver importnat note:
     * Because the position in Core Animation is relative to the anchorPoint of 
     * the layer, changing that anchorPoint while maintaining the same position 
     * moves the layer.
     * I have to compensate for this movement. http://goo.gl/20FsJX
     */
    CGPoint oldOrigin = view.frame.origin;
    view.layer.anchorPoint = anchorPoint;
    CGPoint newOrigin = view.frame.origin;
    CGPoint offset;
    offset.x = newOrigin.x - oldOrigin.x;
    offset.y = newOrigin.y - oldOrigin.y;
    
    /* Status/Navigation Bars' height should also be considered after changing anchor point
     * Otherwise, @ the begining of animation, the snapshot views would start from 
     * status bar.
     */
    self.statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    /* Re-center the view again after calculating all offsets.*/
    view.center = CGPointMake (view.center.x - offset.x,
                               view.center.y - offset.y +
                               self.statusBarHeight + self.navigationBarHeight);
}

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
