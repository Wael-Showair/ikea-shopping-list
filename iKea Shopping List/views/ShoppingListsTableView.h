//
//  ShoppingListsTableView.h
//  iKea Shopping List
//
//  Created by Wael Showair on 2015-12-21.
//  Copyright © 2015 showair.wael@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollingNotificationDelegate.h"

@interface ShoppingListsTableView : UICollectionView <UIScrollViewDelegate>
@property (weak, nonatomic) id<UIScrollingNotificationDelegate> scrollingDelegate;
@property BOOL shouldNotifyDelegate;

-(void)scrollViewDidScroll;

@property BOOL editingMode;
@end

