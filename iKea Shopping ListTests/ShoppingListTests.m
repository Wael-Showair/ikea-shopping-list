//
//  iKea_Shopping_ListTests.m
//  iKea Shopping ListTests
//
//  Created by Wael Showair on 2015-10-25.
//  Copyright © 2015 showair.wael@gmail.com. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "ShoppingItem.h"
#import "ShoppingList.h"

@interface ShoppingListTests : XCTestCase
@property ShoppingList* shoppingList;
@end

@implementation ShoppingListTests

- (void)setUp {
  [super setUp];
  // Put setup code here. This method is called before the invocation of each test method in the class.
  self.shoppingList = [[ShoppingList alloc] init];
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}



-(void) testAddNewItem {
  NSDecimalNumber* itemPrice = [NSDecimalNumber decimalNumberWithString:@"19.99"];
  ShoppingItem* item = [[ShoppingItem alloc] initWithName:@"Standing Lamp" price:itemPrice];
  [self.shoppingList addNewItem:item];
  XCTAssertEqual(1, [self.shoppingList numberOfAisles]);
}

-(void) testAddItemsToTheSameAisleNum {
  /* Add two shopping items to the shopping list. */
  NSDecimalNumber* itemPrice = [NSDecimalNumber decimalNumberWithString:@"19.99"];
  ShoppingItem* item1 = [[ShoppingItem alloc] initWithName:@"Standing Lamp" price:itemPrice];
  ShoppingItem* item2 = [[ShoppingItem alloc] initWithName:@"Dinning Chairs" price:itemPrice];
  
  /* Make sure that bot items are inserted properly and list lenght is 2 */
  [self.shoppingList addNewItem:item1 ];
  [self.shoppingList addNewItem:item2 ];
  XCTAssertEqual(1, [self.shoppingList numberOfAisles]);
  
  NSIndexPath* indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
  ShoppingItem* returnedItem = [self.shoppingList itemAtAisleIndexPath:indexPath];
  
  /* Make sure that list adds the latest item at the first */
  XCTAssertEqual(item2.name, returnedItem.name);
  XCTAssertEqual(item2.price, returnedItem.price);
  
  NSDecimalNumber* totalPrice = [NSDecimalNumber decimalNumberWithString:@"39.98"];
  /* Make sure the total price of the shopping list is correct. */
  XCTAssertEqualWithAccuracy(totalPrice.floatValue, self.shoppingList.totalPrice.floatValue, 0.01);
}

-(void) testAddItemsToNewAisleNum{
  NSDecimalNumber* itemPrice = [NSDecimalNumber decimalNumberWithString:@"10024.99"];
  ShoppingItem* item1 = [[ShoppingItem alloc] initWithName:@"Table" price:itemPrice image:nil aisleNumber:113];
  
  itemPrice = [NSDecimalNumber decimalNumberWithString:@"64"];
  ShoppingItem* item2 = [[ShoppingItem alloc] initWithName:@"Chair" price:itemPrice image:nil aisleNumber:53];
  
  [self.shoppingList addNewItem:item1 ];
  [self.shoppingList addNewItem:item2 ];
  
  NSIndexPath* indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
  ShoppingItem* returnedItem1 = [self.shoppingList itemAtAisleIndexPath:indexPath];
  
  indexPath = [NSIndexPath indexPathForItem:0 inSection:1];
  ShoppingItem* returnedItem2 = [self.shoppingList itemAtAisleIndexPath:indexPath];
  
  XCTAssertEqual(returnedItem1.name, item1.name);
  XCTAssertEqual(returnedItem2.name, item2.name);
  
  NSDecimalNumber* totalPrice = [NSDecimalNumber decimalNumberWithString:@"10088.99"];
  /* Make sure the total price of the shopping list is correct. */
  XCTAssertEqualWithAccuracy(totalPrice.floatValue, self.shoppingList.totalPrice.floatValue, 0.01);
}

- (void) testRetrievingItemAtInvalidIndex{
  NSDecimalNumber* itemPrice = [NSDecimalNumber decimalNumberWithString:@"10024.99"];
  ShoppingItem* item1 = [[ShoppingItem alloc] initWithName:@"Table" price:itemPrice image:nil aisleNumber:113];
  [self.shoppingList addNewItem:item1 ];
  
  NSIndexPath* indexPath = [NSIndexPath indexPathForItem:0 inSection:1];
  
  XCTAssertThrowsSpecificNamed([self.shoppingList itemAtAisleIndexPath:indexPath], NSException, NSRangeException);
}

- (void) testRemoveTheOnlyItemInAisle{
  NSDecimalNumber* itemPrice = [NSDecimalNumber decimalNumberWithString:@"10024.99"];
  ShoppingItem* item1 = [[ShoppingItem alloc] initWithName:@"Table" price:itemPrice image:nil aisleNumber:113];
  
  itemPrice = [NSDecimalNumber decimalNumberWithString:@"64"];
  ShoppingItem* item2 = [[ShoppingItem alloc] initWithName:@"Chair" price:itemPrice image:nil aisleNumber:53];
  
  [self.shoppingList addNewItem:item1 ];
  [self.shoppingList addNewItem:item2 ];
  
  NSIndexPath* indexPath = [NSIndexPath indexPathForItem:0 inSection:1];
  [self.shoppingList removeItemAtIndexPath:indexPath];
  
  NSDecimalNumber* totalPrice = [NSDecimalNumber decimalNumberWithString:@"10024.99"];
  /* Make sure the total price of the shopping list is correct. */
  XCTAssertEqualWithAccuracy(totalPrice.floatValue, self.shoppingList.totalPrice.floatValue, 0.01);
}

- (void) testRemoveItemFromAilse{
  NSDecimalNumber* itemPrice = [NSDecimalNumber decimalNumberWithString:@"10024.99"];
  ShoppingItem* item1 = [[ShoppingItem alloc] initWithName:@"Table" price:itemPrice image:nil aisleNumber:113];
  
  itemPrice = [NSDecimalNumber decimalNumberWithString:@"64"];
  ShoppingItem* item2 = [[ShoppingItem alloc] initWithName:@"Chair" price:itemPrice image:nil aisleNumber:53];
  
  [self.shoppingList addNewItem:item1 ];
  [self.shoppingList addNewItem:item2 ];
  
  NSIndexPath* indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
  NSLog(@"index path row = %ld , section = %ld", indexPath.row, indexPath.section);
  [self.shoppingList removeItemAtIndexPath:indexPath];
  
  NSDecimalNumber* totalPrice = [NSDecimalNumber decimalNumberWithString:@"64"];
  /* Make sure the total price of the shopping list is correct. */
  XCTAssertEqualWithAccuracy(totalPrice.floatValue, self.shoppingList.totalPrice.floatValue, 0.01);
  
}

- (void)testPerformanceExample {
  // This is an example of a performance test case.
  [self measureBlock:^{
    // Put the code you want to measure the time of here.
  }];
}

@end
