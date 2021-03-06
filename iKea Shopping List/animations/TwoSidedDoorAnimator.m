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

#define NAVBAR_ANIMATION_KEY_FRAME_DURATION                 0.3
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

#define NAVBAR_ANIMATION_RELATIVE_START_TIME                0.7
/*!
 *  @define TRANSITION_DURATION
 *  @abstract Total duration of the animation in seconds. It is summation of
 *  duration of scale animation keyframe and duration of rotation animation
 *  keyframe.
 */
#define TRANSITION_DURATION (SCALE_ANIMATION_KEY_FRAME_DURATION +     \
                             ROTATION_ANIMATION_KEY_FRAME_DURATION) + \
                             NAVBAR_ANIMATION_KEY_FRAME_DURATION

@interface TwoSidedDoorAnimator()

@property (weak, nonatomic) UINavigationBar* navigationBarView;
@property (strong, nonatomic) NSArray* snapshotViews;

/*!
 *  @abstract UIKit asks the animator for the duration (in seconds) of the
 *  transition animation.
 *  @param transitionContext The context object containing information to use
 *  during the transition.
 *
 *  @return The duration, in seconds, of the custom transition animation.
 */
-(NSTimeInterval)transitionDuration: (id<UIViewControllerContextTransitioning>)transitionContext;

/*!
 *  @abstract UIKit asks the animator to perform the transition animations
 *  @param transitionContext The context object containing information about the
 *  transition.
 */
-(void)animateTransition: (id<UIViewControllerContextTransitioning>)transitionContext;

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

@end


@implementation TwoSidedDoorAnimator

-(NSTimeInterval)transitionDuration: (id<UIViewControllerContextTransitioning>)transitionContext
{
  return TRANSITION_DURATION;
}

-(void)animateTransition: (id<UIViewControllerContextTransitioning>)transitionContext
{
  
  CGAffineTransform initialScaleTransformationMatrix, finalScaleTransform, translationTransform,
                    combinedTransformationMatrix;
  CGFloat leftSideRotationAngle, rightSideRotationAngle;
  UIView *leftSideView,*rightSideView,*viewToBeRemoved;
  
  UIViewController* fromVC = [transitionContext   viewControllerForKey:UITransitionContextFromViewControllerKey];
  
  UIViewController* toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
  
  UIView* containerView = [transitionContext containerView];
  
  /* Add a perspective transformation matrix to the container view of both to/from views.
   * It represents how much horizontal skewing will be applied to view's layer. */
  CATransform3D skewTransformationMatrix = CATransform3DIdentity;
  skewTransformationMatrix.m34 = -0.002;
  
  /* The sublayerTransform property defines additional transformations that apply only to the
   * sublayers and is used most commonly to add a perspective visual effect to the contents of a 
   * scene. https://goo.gl/0Q51eP */
  [containerView.layer setSublayerTransform:skewTransformationMatrix];
  
  /* Add detination view to the view's hirerachy.*/
  [containerView addSubview:toVC.view];

  // Give both VCs the same start frame
  CGRect initialFrame = [transitionContext initialFrameForViewController:fromVC];
  fromVC.view.frame =  initialFrame;
  toVC.view.frame   = initialFrame;
  
  /* Angle of rotation for the  snapshot views.*/
  leftSideRotationAngle  = M_PI_2;
  rightSideRotationAngle = -M_PI_2;
  
  if(self.isReversed){
    
    initialScaleTransformationMatrix = CGAffineTransformMakeScale(1, 1);
    finalScaleTransform              = CGAffineTransformMakeScale(0, 0);
    
    viewToBeRemoved = toVC.view;

    /* Hide the navigation bar. TODO: Use scale/translation transformation matrix instead. */
    [self.navigationBarView setHidden:YES];
    
    /* Set source view's layer 2D transformation matrix to scale (1,1). This is the initial
     * state before starting animation. */
    fromVC.view.layer.affineTransform = initialScaleTransformationMatrix;
   
    /* No need to rotate the snapshot views of the destination view's layer since both of them
     * are actually kept rotated by the end of the forward animation. */
  }else{
    
    initialScaleTransformationMatrix  = CGAffineTransformMakeScale(0, 0);
    finalScaleTransform               = CGAffineTransformMakeScale(1, 1);
    
    /* Navigation bar has to be animated in the same way as target view's layer (i.e. scaling
     * up from zero to 1 in x,y dimensions). But It also needs to be shifted down to the
     * middle of the screen so that it looks like as if it moves with the target view's layer. 
     * This means that navigation bar view's layer needs to have translation & scale transformations*/
    translationTransform = CGAffineTransformMakeTranslation(0, [[UIScreen mainScreen] bounds].size.height/2);
    combinedTransformationMatrix = CGAffineTransformScale(translationTransform, 0, 0);
    
    /* Take a UIView snapshot from the whole window, dividing it in two parts.*/
    [self takeSnapshotFromMainWindowContainingView:fromVC.view afterScreenUpdates:NO];
    
    viewToBeRemoved = fromVC.view;
    
    /* Set destination view's layer 2D transformation matrix to scale (0,0). This is the initial
     * state before starting animation. */
    toVC.view.layer.affineTransform = initialScaleTransformationMatrix;
    
    /* Show the navigation bar. */
    [self.navigationBarView setHidden:NO];

    /* Set navigation bar view's layer to the combined transoformation matrix. */
    self.navigationBarView.layer.affineTransform = combinedTransformationMatrix;
    
  }

  /* remove to-View from the hirerachy, use the snapshots instead. */
  [viewToBeRemoved removeFromSuperview ];
  leftSideView = self.snapshotViews[0];
  rightSideView = self.snapshotViews[1];

  /* Add snapshot views to the view's hirerachy. */
  [containerView addSubview:leftSideView];
  [containerView addSubview:rightSideView];
  
  /* Set the reference point of transformations that are going to be animated. */
  [self updateAnchorPoint:CGPointMake(1, 1) forView:rightSideView];
  [self updateAnchorPoint:CGPointMake(0, 1) forView:leftSideView];
  
  NSTimeInterval duration = [self transitionDuration:transitionContext];
  
  [UIView animateKeyframesWithDuration:duration delay:0 options:0 animations:^{
    
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
                                      leftSideView.layer.transform = [self rotateAroundYAxisByAngle:0.0];
                                      rightSideView.layer.transform = [self rotateAroundYAxisByAngle:0.0];
                                      
                                    }];
      
    }else{
      
      [UIView addKeyframeWithRelativeStartTime:FIRST_ANIMATION_START_TIME
                              relativeDuration:ROTATION_ANIMATION_KEY_FRAME_DURATION
                                    animations:^{
                                      // rotate the from view
                                      leftSideView.layer.transform =
                                      [self rotateAroundYAxisByAngle:leftSideRotationAngle];
                                      rightSideView.layer.transform =
                                      [self rotateAroundYAxisByAngle:rightSideRotationAngle];
                                    }];
      
      [UIView addKeyframeWithRelativeStartTime:SECOND_ANIMATION_RELATIVE_START_TIME
                              relativeDuration:SCALE_ANIMATION_KEY_FRAME_DURATION
                                    animations:^{
                                      // scale up the to-view
                                      toVC.view.layer.affineTransform = finalScaleTransform;
                                    }];
      
      /* 0.75, 0.25 for 6/6s plus
       * 0.70 0.30  for 6/6s  */
      [UIView addKeyframeWithRelativeStartTime:NAVBAR_ANIMATION_RELATIVE_START_TIME
                              relativeDuration:NAVBAR_ANIMATION_KEY_FRAME_DURATION
                                    animations:^{
                                      self.navigationBarView.layer.affineTransform = finalScaleTransform;
                                    }];
    }/* else */
  } completion:^(BOOL finished){

    /* Remove snapshotviews */
    [leftSideView removeFromSuperview];
    [rightSideView removeFromSuperview];
    
    /* Notifies the system that the transition animation is done.*/
    [transitionContext completeTransition:YES];
    
    if(self.isReversed){
      
      /* Add destination view in the views hirerachy. */
      [containerView addSubview:toVC.view];

      /* Display navigation bar again. */
      [self.navigationBarView setHidden:NO];
    }
  }];
  
  
}


- (CATransform3D) rotateAroundYAxisByAngle:(CGFloat) angle {
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
  
  /* Re-center the view again after calculating all offsets.*/
  view.center = CGPointMake (view.center.x - offset.x,
                             view.center.y - offset.y);
}


- (void)takeSnapshotFromMainWindowContainingView:(UIView*) view afterScreenUpdates:(BOOL) afterUpdates{
  
  UIWindow * mainWindow = [UIApplication sharedApplication].windows.firstObject;
  UIView* containerView = view.superview;
  
  // snapshot the left-hand side of the view
  CGRect snapshotRegion = CGRectMake(0, 0, mainWindow.frame.size.width / 2, mainWindow.frame.size.height);
  
  UIView *leftHandView = [mainWindow resizableSnapshotViewFromRect:snapshotRegion
                                                afterScreenUpdates:afterUpdates
                                                     withCapInsets:UIEdgeInsetsZero];
  leftHandView.frame = snapshotRegion;
  
  // snapshot the right-hand side of the view
  snapshotRegion = CGRectMake(mainWindow.frame.size.width / 2, 0,
                              mainWindow.frame.size.width / 2, mainWindow.frame.size.height);
  
  UIView *rightHandView = [mainWindow resizableSnapshotViewFromRect:snapshotRegion
                                                 afterScreenUpdates:afterUpdates
                                                      withCapInsets:UIEdgeInsetsZero];
  rightHandView.frame = snapshotRegion;
  
  // send the view that was snapshotted to the back
  [containerView sendSubviewToBack:view];
  
  /* Hide navigation bar since it is a subview for container view. */
  UINavigationBar* navbarView = [mainWindow viewWithTag:20];
  [navbarView setHidden:YES];
  self.navigationBarView = navbarView;
  
  self.snapshotViews =  @[leftHandView, rightHandView];
  
}

@end
