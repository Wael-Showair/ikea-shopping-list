//
//  OuterScrollView.h
//  iKea Shopping List
//
//  Created by Wael Showair on 2015-12-20.
//  Copyright © 2015 showair.wael@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollingNotificationDelegate.h"

@interface OuterScrollView : UIScrollView <UIScrollingNotificationDelegate>
@property (weak, nonatomic) UIView* stickyHeader;
@end
