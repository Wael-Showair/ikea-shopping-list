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
    BOOL result = [self.shoppingList addNewItem:item];
    XCTAssertEqual(YES, result);
    XCTAssertEqual(1, [self.shoppingList count]);
}

-(void) testGetItemAtIndex {
    /* Add two shopping items to the shopping list. */
    NSDecimalNumber* itemPrice = [NSDecimalNumber decimalNumberWithString:@"19.99"];
    ShoppingItem* item1 = [[ShoppingItem alloc] initWithName:@"Standing Lamp" price:itemPrice];
    ShoppingItem* item2 = [[ShoppingItem alloc] initWithName:@"Dinning Chairs" price:itemPrice];
    
    /* Make sure that bot items are inserted properly and list lenght is 2 */
    BOOL result = [self.shoppingList addNewItem:item1];
    XCTAssertEqual(YES, result);
    result = [self.shoppingList addNewItem:item2];
    XCTAssertEqual(YES, result);
    XCTAssertEqual(2, [self.shoppingList count]);

    /* Make sure that list adds the latest item at the first index.*/
    ShoppingItem* returnedItem = [self.shoppingList itemAtIndex:0];
    XCTAssertEqual(item2.name, returnedItem.name);
    XCTAssertEqual(item2.price, returnedItem.price);
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
