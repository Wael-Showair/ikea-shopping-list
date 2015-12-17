//
//  ListOfItemsUITests.m
//  iKea Shopping List
//
//  Created by Wael Showair on 2015-11-23.
//  Copyright © 2015 showair.wael@gmail.com. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface ListOfItemsUITests : XCTestCase

@end

@implementation ListOfItemsUITests

- (void)setUp {
  [super setUp];
  
  // Put setup code here. This method is called before the invocation of each test method in the class.
  
  // In UI tests it is usually best to stop immediately when a failure occurs.
  self.continueAfterFailure = NO;
  // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
  [[[XCUIApplication alloc] init] launch];
  
  // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
  [super tearDown];
}

- (void)testRemovingSectionFromTable {
  
  XCUIApplication *app = [[XCUIApplication alloc] init];
  XCUIElementQuery *tablesQuery = app.tables;
  
  XCUIElement* currentTabel = [tablesQuery elementBoundByIndex:0];
  XCTAssertNotNil(currentTabel); // Make sure it is not nil
  
  /* Tap on List of Kitchen Items */
  [currentTabel.staticTexts[@"Kitchen"] tap];
  
  /* Svae number of items for later comparison. */
  NSUInteger oldNumberOfItems = currentTabel.cells.count;
  
  /* Swipe Left the second list. */
  XCUIElement *cell = [currentTabel.cells elementBoundByIndex:1];
  XCTAssertNotNil(cell);
  [cell swipeLeft];
  
  /* Make sure there is one button in the cell with title Delete*/
  XCTAssertEqual(1, cell.buttons.count);
  XCUIElement* deleteBtn = [cell.buttons elementBoundByIndex:0];
  XCTAssertEqualObjects(@"Delete", deleteBtn.label);
  
  /* Delete the list */
  [deleteBtn tap];
  
  /* Get new number of cells after deleting section.*/
  NSUInteger newNumberOfLists = currentTabel.cells.count;
  /* Make sure that the number of lists is decreased by 1. */
  XCTAssertEqual(oldNumberOfItems -1, newNumberOfLists);
  
  /* TODO: check that the table header view  has been updated by the total price */
}

-(void) testRemocingAnItemFromSection{
  
  XCUIApplication *app = [[XCUIApplication alloc] init];
  XCUIElementQuery *tablesQuery = app.tables;
  
  XCUIElement* currentTabel = [tablesQuery elementBoundByIndex:0];
  XCTAssertNotNil(currentTabel); // Make sure it is not nil
  
  /* Tap on List of Bathroom Items */
  [currentTabel.staticTexts[@"Bathroom"] tap];
  
  /* Svae number of items for later comparison. */
  NSUInteger oldNumberOfItems = currentTabel.cells.count;
  
  /* Get reference to a cell in a section that has multiple rows.*/
  XCUIElement *cell = [[[currentTabel childrenMatchingType:XCUIElementTypeCell]
                        matchingIdentifier:@"Faucet, 54.49"]
                       elementBoundByIndex:2];
  
  /* Swipe to delete. */
  [cell swipeLeft];
  /* Make sure there is one button in the cell with title Delete*/
  XCTAssertEqual(1, cell.buttons.count);
  XCUIElement* deleteBtn = [cell.buttons elementBoundByIndex:0];
  XCTAssertEqualObjects(@"Delete", deleteBtn.label);
  
  /* Delete the list */
  [deleteBtn tap];
  
  /* Get new number of cells after deleting the list item.*/
  NSUInteger newNumberOfLists = currentTabel.cells.count;
  /* Make sure that the number of items per list is decreased by 1. */
  XCTAssertEqual(oldNumberOfItems -1, newNumberOfLists);
  
  /* TODO: check that the table header view  has been updated by the total price */
}

@end
