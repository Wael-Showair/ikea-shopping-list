//
//  OuterScrollView.h
//  iKea Shopping List
//
//  Created by Wael Showair on 2015-12-20.
//  Copyright © 2015 showair.wael@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollingNotificationDelegate.h"
#import "UIScrollView+ObscuringKeyboard.h"


@protocol UIStickyViewDelegate <NSObject>
-(void) stickyViewDidDisappear: (UIView*) stickyView;
-(void) stickyViewWillAppear : (UIView*) stickyView;
@end

@interface OuterScrollView : UIScrollView <UIScrollingNotificationDelegate>
@property (weak, nonatomic) id<UIStickyViewDelegate> stickyDelegate;
@end


