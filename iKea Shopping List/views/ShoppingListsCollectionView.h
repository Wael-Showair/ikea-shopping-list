//
//  ShoppingListsTableView.h
//  iKea Shopping List
//
//  Created by Wael Showair on 2015-12-21.
//  Copyright © 2015 showair.wael@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollingNotificationDelegate.h"

@interface ShoppingListsCollectionView : UICollectionView <UIScrollViewDelegate>
@property (weak, nonatomic) id<UIScrollingNotificationDelegate> scrollingDelegate;
@property BOOL shouldNotifyDelegate;
@property CGFloat prevContentOffsetY;

-(void)scrollViewDidScroll;

@property BOOL editingMode;
@end

