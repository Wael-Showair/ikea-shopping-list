/*!
 *  @header ShoppingList.h
 *  interface file that provides all the needed operations for an iKea shopping list.
 *
 *  @author Wael Showair (showair.wael\@gmail.com)
 *  @version 0.0.1
 *  @copyright 2015. Wael Showair. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import "ShoppingItem.h"

/*!
 *  @class ShoppingList
 *  @abstract A class that represents an iKea Shopping List.
 *  @discussion The class wraps the real implementation of the list so that the maintainability of the code is easier.
 *  @seealso //apple_ref/occ/cl/ShoppingItem ShoppingItem
 */
@interface ShoppingList : NSObject

/*!
 *  @property title
 *  @abstract title of the list.
 */
@property NSString* title;

/*!
 *  initialize a list with specific title.
 *
 *  @param title name of the list to be created.
 *
 *  @return instance of ShoppingList.
 */
- (instancetype)initWithTitle: (NSString*) title;

/*!
 *  Add new shopping item to the list.
 *
 *  @param item an object of shopping item.
 *
 *  @return boolean indicating whether the item has been added succesfully or not.
 */
- (BOOL) addNewItem: (ShoppingItem*) item;

/*!
 *  Get how many shopping items are in the given list.
 *
 *  @return non-negative value.
 */
- (NSUInteger)  count;

/*!
 *  Get shopping item at specific index in the list.
 *
 *  @param index an index within the bounds of the shopping list.
 *
 *  @return shopping item object located at the given index.
 *  @discussion if the index is out of bounds, a nil pointer is returned.
 */
- (ShoppingItem*) itemAtIndex: (int) index;

/*!
 *  Return all shopping items inside the list.
 *
 *  @return all shopping items
 *  @discussion the selector return generic pointer (id) type. Since the class is
 *  wrapping the real implementation of the list.
 */
- (id) getItems;
@end
