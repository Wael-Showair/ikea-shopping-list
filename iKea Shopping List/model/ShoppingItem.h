/*!
 *  @header ShoppingItem.h
 *  interface file that provides all the needed operations for an iKea shopping item.
 *
 *  @author Wael Showair (showair.wael\@gmail.com)
 *  @version 0.0.1
 *  @copyright 2015. Wael Showair. All rights reserved.
 */

#import <Foundation/Foundation.h>

/*!
 *  @class ShoppingItem
 *  @abstract A class that represents an iKea Shopping Item
 *  @discussion All the properties of this class can be modified through setters methods.
 *  @seealso //apple_ref/occ/cl/ShoppingList ShoppingList
 */


@interface ShoppingItem : NSObject

/*!
 *  @property name
 *  @abstract Name of the shopping item.
 */
@property NSString* name;

/*!
 *  @property imageName
 *  @abstract Image name of the shopping item.
 */
@property NSString* imageName;

/*!
 *  @property price
 *  @abstract Price of the item.
 *  @discussion It can be decimal numbers. It does not take into consideration the exact currency.
 */
@property NSDecimalNumber* price;

/*!
 *  @property articleNumber
 *  @abstract Article number of the shopping item. It takes the format xxx.yyy.zz
 *  @discussion Although this is a numeric field by nature but it needn't to be used in any sorting or calculations. It is better from performance point of view to save it in NSString*
 */
@property NSString* articleNumber;

/*!
 *  @property aisleNumber
 *  @abstract Aisle number form which the item is picked up.
 *  @discussion It can't be a negative or a decimal number.
 */
@property NSUInteger aisleNumber;

/*!
 *  @property binNumber
 *  @abstract Bin number from which the item is picked up.
 *  @discussion It can't be a negative or a decimal number.
 */
@property NSUInteger binNumber;

/*!
 *  @property quantity
 *  @abstract How many times does the user would buy the item?
 *  @discussion It can't be a negative or a decimal number.
 */
@property NSUInteger quantity;

/*!
 *  initialize a new shopping item with name & price
 *
 *  @param itemName  The name of the item to be instantiated.
 *  @param itemPrice The price of the item to be instantiated.
 *
 *  @return a new object from ShoppingItem class.
 *  @discussion The currency of the item price is ignored till now.
 */
-(instancetype) initWithName:(NSString*) itemName
                       price:(NSDecimalNumber*) itemPrice;


@end
