/*
 *
 *  @file ShoppingList.m
 *  implementation file that provides all the needed operations for an iKea 
 *  shopping list.
 *
 *  @author Wael Showair (showair.wael\@gmail.com)
 *  @version 0.0.1
 *  @copyright 2015. Wael Showair. All rights reserved.
 */

#import "ShoppingItem.h"
#import "ShoppingList.h"

@interface ShoppingList()

/*
 *  @property allItems
 *  @abstract private property that represents a collection of items that forms 
 *  the shopping list.
 */
@property  NSMutableArray* allItems;
@end

@implementation ShoppingList

- (instancetype)init
{
    return [self initWithTitle:@""];
}

- (instancetype)initWithTitle: (NSString*) title
{
    NSDecimalNumber* price = [NSDecimalNumber decimalNumberWithString:@"0"];
    self = [self initWithTitle:title total:price];
    return self;
}

- (instancetype)initWithTitle: (NSString*) title
                        total:(NSDecimalNumber*)total
{
    self = [super init];
    
    if (self) {
        /* initialize the title of the list. */
        self.title = title;
        
        /* Initialize the pointer to NSMutable array object. */
        self.allItems = [[NSMutableArray alloc] init];
        
        /* Initialize the total price*/
        self.totalPrice = total;
    }
    return self;
}

- (void)addNewItem:(ShoppingItem *)item
{
    [self.allItems insertObject:item atIndex:0];
    self.totalPrice = [self.totalPrice decimalNumberByAdding:item.price];
}

- (void)removeItemAtIndex:(NSUInteger)index
{
    ShoppingItem* item = [self.allItems objectAtIndex:index];
    self.totalPrice = [self.totalPrice decimalNumberBySubtracting:item.price];
    [self.allItems removeObjectAtIndex:index];
    
}

-(ShoppingItem *)itemAtIndex:(int)index{
    @try{
        return [self.allItems objectAtIndex:index];
    }
    @catch(NSException* exception){
        NSLog( @"NSException caught" );
        NSLog( @"Name: %@", exception.name);
        NSLog( @"Reason: %@", exception.reason );
        return nil;
    }
}

-(NSUInteger)count{
    return self.allItems.count;
}

-(id)getItems{
    return self.allItems;
}

@end
