//
//  ShoppingItemsTableView.h
//  iKea Shopping List
//
//  Created by Wael Showair on 2016-01-01.
//  Copyright © 2016 showair.wael@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollingNotificationDelegate.h"


@interface ShoppingItemsTableView : UITableView
@property (weak, nonatomic) id<UIScrollingNotificationDelegate> scrollingDelegate;
@property BOOL shouldNotifyDelegate;

-(void)scrollViewDidScroll;
- (void) updateGlobalHeaderWithTitle: (NSString*) title;
@end
