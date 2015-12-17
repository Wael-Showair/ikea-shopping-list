/*!
 *  @file NavigationControllerDelegate.m
 *  implementation file that provides operations of the delegate for the custom
 *  navigation controller.
 *
 *  @author Wael Showair (showair.wael\@gmail.com)
 *  @version 0.0.1
 *  @copyright 2015. Wael Showair. All rights reserved.
 */

#import "TwoSidedDoorAnimator.h"
#import "NavigationControllerDelegate.h"

@interface NavigationControllerDelegate()

/*!
 *  @property animator
 *  @abstract an animator that is used during transition between view
 *  controllers.
 */
@property TwoSidedDoorAnimator* animator;

/*!
 *  @abstract initialize the custom naviagtion controller delegate.
 *
 *  @return instance of navigation controller delegate.
 *  @discussion the custom animator object (that will be used while navigating
 *  throug the scenes) must be initialized otherwise, the default push animation
 *  will be triggered.
 */
- (instancetype)init;

/*!
 *  @abstract get the custom non-interactive animator object that is used during
 *  transition between view controllers.
 *
 *  @param navigationController
 *  The navigation controller whose navigation stack is changing
 *  @param operation
 *  The type of transition operation that is occurring.
 *  @param fromVC
 *  The currently visible view controller.
 *  @param toVC
 *  The view controller that should be visible at the end of the transition.
 *
 *  @return The animator object responsible for managing the transition
 *  animations or nil if you want to use the standard navigation controller
 *  transitions.
 *
 *  @discussion UIKit calls checks whether the transitioning delegate object is
 *  set. If it asks the delegate to return a noninteractive animator object for
 *  use during view controller transitions.
 */
- (id<UIViewControllerAnimatedTransitioning>) navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC;

/*!
 *  @abstract checks whether the given view controller is the root view
 *  controller or not
 *
 *  @param viewController
 *    the view controller that will be examined as a root VC.
 *
 *  @return YES if the given view controller is the root otherwise return NO.
 */
- (BOOL) isRootViewController: (UIViewController*) viewController;
@end


@implementation NavigationControllerDelegate
- (instancetype)init
{
  self = [super init];
  if (self) {
    self.animator = [[TwoSidedDoorAnimator alloc] init];
  }
  return self;
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC
{
  
  TwoSidedDoorAnimator* animator;
  switch (operation) {
    case UINavigationControllerOperationNone:
      NSLog(@"None operation");
      animator = nil;
      break;
    case UINavigationControllerOperationPop:
      NSLog(@"Pop operation");
      if([self isRootViewController:toVC]){
        self.animator.isReversed = YES;
        animator =  self.animator;
      }else{
        animator = nil;
      }
      break;
    case UINavigationControllerOperationPush:
      NSLog(@"Push operation");
      if([self isRootViewController:fromVC]){
        self.animator.isReversed = NO;
        animator =  self.animator;
      }else{
        animator = nil;
      }
      break;
    default:
      NSLog(@"Undefined NavBar operation type: %ld", operation);
      animator = nil;
  }
  
  return animator;
}

- (BOOL) isRootViewController: (UIViewController*) viewController{
  
  if(viewController.navigationController){
    return viewController.navigationController.childViewControllers[0] == viewController;
  }else{
    return NO;
  }
}

@end
