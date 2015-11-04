//
//  NavigationControllerDelegate.h
//  iKea Shopping List
//
//  Created by Wael Showair on 2015-11-03.
//  Copyright © 2015 show0017@algonquinlive.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwoSidedDoorAnimator.h"

@interface NavigationControllerDelegate : NSObject <UINavigationControllerDelegate>

@property (readonly) TwoSidedDoorAnimator* animator;

@end
