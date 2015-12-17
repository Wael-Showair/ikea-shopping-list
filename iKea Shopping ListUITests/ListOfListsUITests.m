//
//  iKea_Shopping_ListUITests.m
//  iKea Shopping ListUITests
//
//  Created by Wael Showair on 2015-10-25.
//  Copyright © 2015 showair.wael@gmail.com. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface iKea_Shopping_ListUITests : XCTestCase

@end

@implementation iKea_Shopping_ListUITests

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
  // Put teardown code here. This method is called after the invocation of each test method in the class.
  [super tearDown];
}

- (void)testNavBarCustomTransition {
  XCUIApplication *app = [[XCUIApplication alloc] init];
  XCUIElementQuery *tablesQuery = app.tables;
  
  /* Get a reference to the first table (list of shopping lists)*/
  XCUIElement* currentTabel = [tablesQuery elementBoundByIndex:0];
  XCTAssertNotNil(currentTabel); // Make sure it is not nil
  
  /* Get a reference to the navigation bar. it will be used to navigate back again. */
  XCUIElement* navigationBar = [app.navigationBars elementBoundByIndex:0];
  
  /* Tap on first list. */
  XCUIElement *cell = [currentTabel.cells elementBoundByIndex:1];
  XCTAssertNotNil(cell);
  [cell tap];
  
  /* Tap on first cell in the second table. Note that current table has been updated
   to list of items table at this point. */
  cell = [currentTabel.cells elementBoundByIndex:0];
  XCTAssertNotNil(cell);
  [cell tap];
  
  /* Now, user at detailed screen. Tap back button to get back to list of shopping items table. */
  [navigationBar.buttons[@"Back"] tap];
  
  /* Tap back again to reach list of shopping lists table.*/
  [navigationBar.buttons[@"Back"] tap];
}

-(void) testAddNewList{
  
  NSString* nameOfNewList = @"Living Room";
  XCUIApplication *app = [[XCUIApplication alloc] init];
  
  /* Get a reference to the navigation bar. it will be used to navigate back again. */
  XCUIElement* navigationBar = [app.navigationBars elementBoundByIndex:0];
  
  XCUIElementQuery *tablesQuery = app.tables;
  
  /* Get a reference to the first table (list of shopping lists)*/
  XCUIElement* currentTabel = [tablesQuery elementBoundByIndex:0];
  XCTAssertNotNil(currentTabel); // Make sure it is not nil
  
  /* Svae number of lists for later comparison. */
  NSUInteger oldNumberOflists = currentTabel.cells.count;
  
  /* Get a reference to the Add Button. */
  XCUIElement * addButton = [navigationBar.buttons elementBoundByIndex:2];
  [addButton tap];
  
  /* Get a reference to the Text Field that is used to enter the name of the
   * new List. The text field has a place holder "List Title" .*/
  XCUIElement * textField = currentTabel.textFields[@"List Title"] ;
  [textField tap];
  
  /* Type the new name. */
  [textField typeText:nameOfNewList];
  [navigationBar.buttons[@"Done"] tap];
  
  /* Get new number of cells after adding new list name.*/
  NSUInteger newNumberOfLists = currentTabel.cells.count;
  /* Make sure that the number of lists has increased by 1. */
  XCTAssertEqual(oldNumberOflists+1, newNumberOfLists);
  
  /* Make sure that the new list name has been added to the beginning.*/
  XCUIElement *cell = [currentTabel.cells elementBoundByIndex:0];
  XCTAssertNotNil(cell);
  XCTAssertEqualObjects(cell.label, nameOfNewList);
}


-(void) testCancelAdditionOfNewList{
  
  XCUIApplication *app = [[XCUIApplication alloc] init];
  
  /* Get a reference to the navigation bar. it will be used to navigate back again. */
  XCUIElement* navigationBar = [app.navigationBars elementBoundByIndex:0];
  
  XCUIElementQuery *tablesQuery = app.tables;
  
  /* Get a reference to the first table (list of shopping lists)*/
  XCUIElement* currentTabel = [tablesQuery elementBoundByIndex:0];
  XCTAssertNotNil(currentTabel); // Make sure it is not nil
  
  /* Svae number of lists for later comparison. */
  NSUInteger oldNumberOflists = currentTabel.cells.count;
  
  /* Get a reference to the Add Button. */
  XCUIElement * addButton = [navigationBar.buttons elementBoundByIndex:2];
  [addButton tap];
  
  /* Get a reference to the Text Field that is used to enter the name of the new List.*/
  XCUIElement * textField = currentTabel.textFields[@"List Title"] ;
  [textField tap];
  
  /* Type the new name. */
  [textField typeText:@"Something"];
  [navigationBar.buttons[@"Cancel"] tap];
  
  /* Get new number of cells after canceling the addition of the list name.*/
  NSUInteger newNumberOfLists = currentTabel.cells.count;
  /* Make sure that the number of lists does not change. */
  XCTAssertEqual(oldNumberOflists, newNumberOfLists);
}

-(void) testDeleteListWithSwipe{
  
  XCUIApplication *app = [[XCUIApplication alloc] init];
  XCUIElementQuery *tablesQuery = app.tables;
  
  XCUIElement* currentTabel = [tablesQuery elementBoundByIndex:0];
  XCTAssertNotNil(currentTabel); // Make sure it is not nil
  
  /* Svae number of lists for later comparison. */
  NSUInteger oldNumberOflists = currentTabel.cells.count;
  
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
  
  /* Get new number of cells after canceling the addition of the list name.*/
  NSUInteger newNumberOfLists = currentTabel.cells.count;
  /* Make sure that the number of lists is decreased by 1. */
  XCTAssertEqual(oldNumberOflists -1, newNumberOfLists);
  
}

-(void) testDeleteListWithEditButton{
  
  XCUIApplication *app = [[XCUIApplication alloc] init];
  XCUIElementQuery *tablesQuery = app.tables;
  
  XCUIElement* currentTabel = [tablesQuery elementBoundByIndex:0];
  XCTAssertNotNil(currentTabel); // Make sure it is not nil
  
  /* Get a reference to the navigation bar. */
  XCUIElement* navigationBar = [app.navigationBars elementBoundByIndex:0];
  
  /* Svae number of lists for later comparison. */
  NSUInteger oldNumberOflists = currentTabel.cells.count;
  
  /* Tap on Edit button in the navigation bar.*/
  [navigationBar.buttons[@"Edit"] tap];
  
  /* Make sure that Delete buttons have occured for each cell.*/
  XCTAssertEqual(oldNumberOflists, currentTabel.buttons.count);
  
  /*  Tap on Delete button of the second list. */
  XCUIElement *cell = [currentTabel.cells elementBoundByIndex:1];
  XCTAssertNotNil(cell);
  
  /* Get reference to the delete button in left side of the cell.*/
  XCUIElement* deleteBtn = [cell.buttons elementBoundByIndex:0];
  
  /* Make sure delete button label is equal to "Delete" + cell label */
  XCTAssertEqualObjects([@"Delete " stringByAppendingString:cell.label], deleteBtn.label);
  [deleteBtn tap];
  
  /* Make sure that there are two Delete buttons in the cell. */
  XCTAssertEqual(2, cell.buttons.count);
  
  /* Get a reference to the second delete button. */
  XCUIElement* secondDeleteBtn = [cell.buttons elementBoundByIndex:1];
  XCTAssertEqualObjects(@"Delete", secondDeleteBtn.label);
  
  /* Delete the list */
  [secondDeleteBtn tap];
  
  /* Tap on Done Button. */
  [navigationBar.buttons[@"Done"] tap];
  
  /* Get new number of cells after canceling the addition of the list name.*/
  NSUInteger newNumberOfLists = currentTabel.cells.count;
  /* Make sure that the number of lists is decreased by 1. */
  XCTAssertEqual(oldNumberOflists -1, newNumberOfLists);
}
@end
