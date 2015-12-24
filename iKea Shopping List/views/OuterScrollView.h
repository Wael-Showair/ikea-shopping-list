//
//  OuterScrollView.h
//  iKea Shopping List
//
//  Created by Wael Showair on 2015-12-20.
//  Copyright © 2015 showair.wael@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollingNotificationDelegate.h"

@protocol UIStickyViewDelegate <NSObject>
-(void) viewDidDisappear: (UIView*) stickyView;
-(void) viewWillAppear : (UIView*) stickyView;
@end

@interface OuterScrollView : UIScrollView <UIScrollingNotificationDelegate>
@property (weak, nonatomic) id<UIStickyViewDelegate> stickyDelegate;
@end


