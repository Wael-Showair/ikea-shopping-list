/*!
 *  @header ShoppingList.h
 *  interface file that provides all the needed operations for an iKea shopping
 *  list.
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
 *  @discussion The class wraps the real implementation of the list so that the
 *  maintainability of the code is easier.
 *  @seealso //apple_ref/occ/cl/ShoppingItem ShoppingItem
 */
@interface ShoppingList : NSObject

/*!
 *  @property title
 *  @abstract title of the list.
 */
@property NSString* title;

@property NSDecimalNumber* totalPrice;
/*!
 *  @abstract initialize a list with specific title.
 *
 *  @param title name of the list to be created.
 *
 *  @return instance of ShoppingList.
 */
- (instancetype)initWithTitle: (NSString*) title;

- (instancetype)initWithTitle: (NSString*) title
                        total: (NSDecimalNumber*)total;
/*!
 *  @abstract Add new shopping item to the list.
 *
 *  @param item an object of shopping item.
 */
- (void) addNewItem: (ShoppingItem*) item;

- (void)removeItemAtIndexPath:(NSIndexPath*)index;

/*!
 *  @abstract Get how many shopping aisle numbers are in the given list.
 *
 *  @return non-negative value.
 */
- (NSUInteger)  numberOfAisles;

-(NSUInteger)numberOfItemsAtAisleIndex: (NSUInteger) index;

/*!
 *  @abstract Get shopping item at specific index in the list.
 *
 *  @param indexPath an index within the bounds of the shopping list.
 *
 *  @return shopping item object located at the given index
 *  @discussion if the index is out of bounds, a nil pointer is returned.
 */
- (ShoppingItem *) itemAtAisleIndexPath: (NSIndexPath*) indexPath;


- (id) getAislesCollection;

@end
