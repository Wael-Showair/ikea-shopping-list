//
//  ShoppingItem.h
//  iKea Shopping List
//
//  Created by Wael Showair on 2015-10-25.
//  Copyright © 2015 showair.wael@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/* Declare public fields of shopping item class. */
@interface ShoppingItem : NSObject

/* Name of the shopping item. */
@property NSString* name;

/* Name of the shopping item image. */
@property NSString* imageName;

/* Price of the item. */
@property NSDecimalNumber* price;

/* Article number of the shopping item. It takes the format xxx.yyy.zz */
@property NSString* articleNumber;

/* Aisle number form which the item is picked up. */
@property NSUInteger asileNumber;

/* Bin number from which the item is picked up. */
@property NSUInteger binNumber;

/* How many times does the user would buy this item? */
@property NSUInteger quantity;

-(instancetype) initWithName:(NSString*) itemName
                       price:(NSDecimalNumber*) itemPrice;


@end
