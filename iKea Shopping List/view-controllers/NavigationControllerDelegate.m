//
//  NavigationControllerDelegate.m
//  iKea Shopping List
//
//  Created by Wael Showair on 2015-11-03.
//  Copyright © 2015 show0017@algonquinlive.com. All rights reserved.
//

#import "TwoSidedDoorAnimator.h"
#import "NavigationControllerDelegate.h"

@interface NavigationControllerDelegate()
@property TwoSidedDoorAnimator* animator;
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

- (id<UIViewControllerAnimatedTransitioning>)
    navigationController:(UINavigationController *)navigationController
    animationControllerForOperation:(UINavigationControllerOperation)operation
    fromViewController:(UIViewController *)fromVC
    toViewController:(UIViewController *)toVC{
    
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
    
    if(viewController.navigationController)
        return viewController.navigationController.childViewControllers[0] == viewController;
    else
        return NO;
}

@end
