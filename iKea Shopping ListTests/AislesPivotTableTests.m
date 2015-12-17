//
//  AislesPivotTableTests.m
//  iKea Shopping List
//
//  Created by Wael Showair on 2015-11-23.
//  Copyright © 2015 showair.wael@gmail.com. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ShoppingList.h"
#import "PivotEntry.h"
#import "AislesPivotTable.h"

@interface AislesPivotTableTests : XCTestCase
//@property ShoppingList* allItems;
@property AislesPivotTable* pivotTable;
@end

@implementation AislesPivotTableTests

- (void)setUp {
  [super setUp];
  ShoppingItem* shoppingItem ;
  NSMutableArray* allLists = [[NSMutableArray alloc] init];
  
  /* Create Bathroom shopping list. */
  ShoppingList* shoppingList = [[ShoppingList alloc] initWithTitle:@"Bathroom"];
  [allLists addObject:shoppingList];
  /* Add faucet, dish-set & mat to the bathroom shopping list. */
  shoppingItem = [[ShoppingItem alloc]
                  initWithName:@"Faucet"
                  price:[[NSDecimalNumber alloc] initWithDouble:54.49]
                  image:@"faucet"
                  aisleNumber:50];
  [shoppingList addNewItem:shoppingItem AtAisleIndex:0];
  shoppingItem = [[ShoppingItem alloc]
                  initWithName:@"Mat"
                  price:[[NSDecimalNumber alloc] initWithDouble:12.99]
                  image:@"mat"
                  aisleNumber:101];
  [shoppingList addNewItem:shoppingItem AtAisleIndex:1];
  shoppingItem = [[ShoppingItem alloc]
                  initWithName:@"Dish Set"
                  price:[[NSDecimalNumber alloc] initWithDouble:12.99]
                  image:@"dish-set"
                  aisleNumber:43];
  [shoppingList addNewItem:shoppingItem AtAisleIndex:2];
  shoppingItem = [[ShoppingItem alloc]
                  initWithName:@"Bottle"
                  price:[[NSDecimalNumber alloc] initWithDouble:17.69]];
  [shoppingList addNewItem:shoppingItem AtAisleIndex:3];
  
  self.pivotTable = [[AislesPivotTable alloc] initWithItems:shoppingList];
}

- (void)tearDown {
  [super tearDown];
}

- (void)testNumberOfEntries {
  XCTAssertEqual(4, [self.pivotTable numberOfAisles]);
}

-(void) testAislesInAscendingOrder{
  int expectedAisles []= {0,43,50,101};
  
  for(int i =0; i<[self.pivotTable numberOfAisles]; i++){
    XCTAssertEqual(expectedAisles[i], [self.pivotTable aisleNumberAtVirtualIndex:i]);
  }
}

-(void) testAisleNumNotFound {
  /* Ask the pivot table to return the virtual index of an aisle number
   * that does not exist in the pivot table. It should be added to the
   * end of the pivot table. */
  NSUInteger resultIndex = [self.pivotTable virtualSectionForAisleNumber:22];
  XCTAssertEqual(NSNotFound, resultIndex);
}

-(void) testMappingToPhysicalIndex{
  int expectedPhysicalIndeces [] = {3,2,0,1};
  for(int i =0; i<[self.pivotTable numberOfAisles]; i++){
    XCTAssertEqual(expectedPhysicalIndeces[i], [self.pivotTable physicalSecIndexForSection:i]);
  }
}

-(void) testSortAscendingWhileAddingNewAilseNum{
  NSInteger virtualIndex =
  [self.pivotTable addNewAisleNumber:22 forActualIndex:4 withAscendingOrder:YES];
  
  /* Aisle number 22 must be added to 2nd index after aisle number zero
   * and before aisle number 43. */
  XCTAssertEqual(1, virtualIndex);
  
  int expectedAisles []= {0,22,43,50,101};
  for(int i =0; i<[self.pivotTable numberOfAisles]; i++){
    XCTAssertEqual(expectedAisles[i], [self.pivotTable aisleNumberAtVirtualIndex:i]);
  }
}

-(void) testSortDescendingWhileAddingNewAilseNum{
  NSInteger virtualIndex =
  [self.pivotTable addNewAisleNumber:22 forActualIndex:4 withAscendingOrder:NO];
  
  /* Aisle number 22 must be added to 2nd index after aisle number zero
   * and before aisle number 43. */
  XCTAssertEqual(3, virtualIndex);
  
  int expectedAisles []= {101,50,43,22,0};
  for(int i =0; i<[self.pivotTable numberOfAisles]; i++){
    XCTAssertEqual(expectedAisles[i], [self.pivotTable aisleNumberAtVirtualIndex:i]);
  }
}

-(void) testRemoveExistingAisleNumber{
  [self.pivotTable removeEntryWithAisleNumber:43];
  /* Make sure that the remaining aisles numbers are correct. */
  int expectedAisles []= {0,50,101};
  for(int i =0; i<[self.pivotTable numberOfAisles]; i++){
    XCTAssertEqual(expectedAisles[i], [self.pivotTable aisleNumberAtVirtualIndex:i]);
  }
  /* Make sure that the physical indeces have been updated properly. */
  int expectedPhysicalIndeces[] = {2,0,1};
  for(int i =0; i<[self.pivotTable numberOfAisles]; i++){
    XCTAssertEqual(expectedPhysicalIndeces[i], [self.pivotTable physicalSecIndexForSection:i]);
  }
  /* Make sure that number of entreis have been decreased by 1*/
  XCTAssertEqual(3, [self.pivotTable numberOfAisles]);
  
}

-(void) testRemoveNonExistingAisleNumber{
  [self.pivotTable removeEntryWithAisleNumber:13];
  XCTAssertEqual(4, [self.pivotTable numberOfAisles]);
  
  int expectedAisles []= {0,43,50,101};
  for(int i =0; i<[self.pivotTable numberOfAisles]; i++){
    XCTAssertEqual(expectedAisles[i], [self.pivotTable aisleNumberAtVirtualIndex:i]);
  }
  
}

- (void)testPerformanceExample {
  // This is an example of a performance test case.
  [self measureBlock:^{
    // Put the code you want to measure the time of here.
  }];
}

@end
