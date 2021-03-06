/*!
 *  @header ListOfListsTableViewController.h
 *  interface file that provides all the needed operations/properties for list
 *  of iKea shopping lists table view controller.
 *
 *  @author Wael Showair (showair.wael\@gmail.com)
 *  @version 0.0.1
 *  @copyright 2015. Wael Showair. All rights reserved.
 */

#import <UIKit/UIKit.h>
#import "OuterScrollView.h"

@interface ShoppingListsViewController : UIViewController
                                        <UICollectionViewDelegateFlowLayout,
                                        UIStickyViewDelegate,
                                        UITextFieldDelegate>

@end
