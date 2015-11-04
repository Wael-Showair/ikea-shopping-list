//
//  ListOfItemsTableViewController.h
//  iKea Shopping List
//
//  Created by Wael Showair on 2015-11-02.
//  Copyright © 2015 show0017@algonquinlive.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingList.h"
@interface ListOfItemsTableViewController : UITableViewController <UITableViewDataSource>

@property ShoppingList* shoppingList;
@end
