//
//  UIScrollViewCommunicatorDelegate.h
//  iKea Shopping List
//
//  Created by Wael Showair on 2015-12-21.
//  Copyright © 2015 showair.wael@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UIScrollingNotificationDelegate <NSObject>
@required
-(void) scrollViewDidCrossOverThreshold: (UIScrollView*) scrollView;
-(void) scrollViewDidReturnBelowThreshold: (UIScrollView*) scrollView;
@end
