//
//  ItemsDataSource.h
//  iKea Shopping List
//
//  Created by Wael Showair on 2015-11-09.
//  Copyright © 2015 showair.wael@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface ItemsDataSource : NSObject <UITableViewDataSource>

#define TOTAL_PRICE_ROW_INDEX    0

- (instancetype) initWithItems:(ShoppingList *)items;

- (id) itemAtIndexPath:(NSIndexPath *)indexPath;

- (NSInteger) insertShoppingItem:(ShoppingItem*)newItem
              withAscendingOrder: (BOOL) ascenOrder;

@end
