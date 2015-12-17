//
//  ItemsDataSource.h
//  iKea Shopping List
//
//  Created by Wael Showair on 2015-11-09.
//  Copyright © 2015 showair.wael@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define TOTAL_PRICE_PREFIX     @"Total Price: "

#define TOTAL_PRICE_ROW_INDEX    0

@interface ItemsDataSource : NSObject <UITableViewDataSource>

- (instancetype) initWithItems:(ShoppingList *)items;

- (id) itemAtIndexPath:(NSIndexPath *)indexPath;

- (NSInteger) insertShoppingItem: (ShoppingItem*)newItem
              withAscendingOrder: (BOOL) ascenOrder;

@end
