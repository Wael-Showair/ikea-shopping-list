/*!
 *  @header ListOfItemsTableViewController.h
 *  interface file that provides all the needed operations/properties for an
 *  iKea shopping list items table view controller.
 *
 *  @author Wael Showair (showair.wael\@gmail.com)
 *  @version 0.0.1
 *  @copyright 2015. Wael Showair. All rights reserved.
 */

#import <UIKit/UIKit.h>
#import "ShoppingList.h"
#import "ShoppingItemDelegate.h"
#import "UIScrollingNotificationDelegate.h"

@interface ShoppingItemsViewController : UIViewController
                                        <UITableViewDelegate,
                                         ShoppingItemDelegate,
                                         UIScrollingNotificationDelegate>

/*!
 *  @property shoppingList
 *  @abstract iKea shopping list of items that is passed between tabel view
 *  controllers.
 */
@property (strong,nonatomic) ShoppingList* shoppingList;
@end
