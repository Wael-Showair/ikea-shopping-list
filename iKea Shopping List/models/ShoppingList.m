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

#import <UIKit/UIKit.h>
#import "ShoppingItem.h"
#import "ShoppingList.h"

@interface ShoppingList()

/*
 *  @property allItems
 *  @abstract private property that represents a collection of items that forms
 *  the shopping list.
 */
@property  (strong, nonatomic) NSMutableArray* aisleNumbers;
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
    self.aisleNumbers = [[NSMutableArray alloc] init];
    
    /* Initialize the total price*/
    self.totalPrice = total;
  }
  return self;
}

- (void) addNewItem: (ShoppingItem*) item
{
  NSMutableArray* array;
  NSUInteger index = [self getListIndexOfAisleNumber:item.aisleNumber];

  if(NSNotFound == index)
  {
    array = [[NSMutableArray alloc] init];
    [self.aisleNumbers addObject:array];

  }
  else
  {
    array = self.aisleNumbers[index];
  }
  
  [array insertObject:item atIndex:0];
  self.totalPrice = [self.totalPrice decimalNumberByAdding:item.price];
}

- (void)removeItemAtIndexPath:(NSIndexPath*)indexPath
{
  ShoppingItem* item = [self itemAtAisleIndexPath:indexPath];
  self.totalPrice = [self.totalPrice decimalNumberBySubtracting:item.price];
  
  NSMutableArray* itemsPerAisle = self.aisleNumbers[indexPath.section];
  if(itemsPerAisle.count == 1)
  {
    [self.aisleNumbers removeObjectAtIndex:indexPath.section];
  }
  else
  {
    [itemsPerAisle removeObjectAtIndex:indexPath.row];
  }
}

-(ShoppingItem *)itemAtAisleIndexPath: (NSIndexPath*) indexPath{
  
  return self.aisleNumbers[indexPath.section][indexPath.row];
  
}

-(NSUInteger)numberOfAisles{
  
  return self.aisleNumbers.count;
}

- (NSUInteger)numberOfItemsAtAisleIndex:(NSUInteger)index{
  
  NSMutableArray* array =  self.aisleNumbers[index];
  return array.count;
}

- (id) getAislesCollection{
  
  return self.aisleNumbers;
}

- (NSUInteger) getListIndexOfAisleNumber: (NSUInteger) requiredAisleNum{
  NSUInteger foundIndex =
  [self.aisleNumbers indexOfObjectPassingTest:
   ^BOOL(id itemsPerAisle, NSUInteger idx, BOOL *stop){
     ShoppingItem* shoppingItem = [itemsPerAisle objectAtIndex:0];
     if(requiredAisleNum == shoppingItem.aisleNumber){
       *stop = YES;
       return YES;
     }else{
       *stop = NO;
       return NO;
     }
     
   }];
  
  return foundIndex;


}
@end
