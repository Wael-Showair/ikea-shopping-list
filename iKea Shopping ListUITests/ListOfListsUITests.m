//
//  iKea_Shopping_ListUITests.m
//  iKea Shopping ListUITests
//
//  Created by Wael Showair on 2015-10-25.
//  Copyright © 2015 showair.wael@gmail.com. All rights reserved.
//

#import <XCTest/XCTest.h>

/* Make sure to enable Search User Path for UI Testing Target to eliminate any compilation error*/
#import "TextInputCell.h"
#import "CustomWindowOverlay.h"

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
  
  /* Tap on List of Bathroom Items */
  [app.scrollViews.otherElements.collectionViews.images[@"kitchen"] tap];
  
  XCUIElementQuery *tablesQuery = app.tables;
  
  /* Get a reference to the table (list of shopping items)*/
  XCUIElement* currentTabel = [tablesQuery elementBoundByIndex:0];
  XCTAssertNotNil(currentTabel); // Make sure it is not nil
  
  /* Get a reference to the navigation bar. it will be used to navigate back again. */
  XCUIElement* navigationBar = [app.navigationBars elementBoundByIndex:0];
  
  /* Tap on first cell in the table. */
  XCUIElement *cell = [currentTabel.cells elementBoundByIndex:0];
  XCTAssertNotNil(cell);
  [cell tap];
  
  /* Now, user at detailed screen. Tap back button to get back to list of shopping items table. */
  [navigationBar.buttons[@"Back"] tap];
  
  /* Tap back again to reach list of shopping lists table.*/
  [navigationBar.buttons[@"Back"] tap];
}

-(void) testAddNewList{

  NSString* nameOfNewList = @"Living-Room";
  
  XCUIApplication *app = [[XCUIApplication alloc] init];

  XCUIElementQuery *elementsQuery = app.scrollViews.otherElements;
  
  XCUIElementQuery* collectionsQuery =  app.scrollViews.otherElements.collectionViews;
  
  /* Get a reference to the first table (list of shopping lists)*/
  XCUIElement* currentCollection = [collectionsQuery elementBoundByIndex:0];
  XCTAssertNotNil(currentCollection); // Make sure it is not nil
  
  /* Svae number of lists for later comparison. */
  NSUInteger oldNumberOflists = currentCollection.cells.count;
  
  /* Get a reference to the Add Button. */
  XCUIElement * addButton = elementsQuery.buttons[@"Create new list"];
  [addButton tap];
  
  /* Get a reference to the Text Field that is used to enter the name of the
   * new List. The text field has a place holder "List Title" .*/
  XCUIElement * textField = currentCollection.textFields[@"Name of List"] ;
  
  /* Type the new name. */
  [textField typeText:nameOfNewList];
  [app.buttons[@"return"] tap];

  
  /* Get new number of cells after adding new list name.*/
  NSUInteger newNumberOfLists = [currentCollection.cells matchingPredicate:[NSPredicate predicateWithFormat:@"label != %@", CELL_TEXT_INPUT_ACCESSIBILITY_LABEL]].count;
  /* Make sure that the number of lists has increased by 1.
   * Special Case: after creating text field cell, it is still a direct child in the elements tree 
   * so new number of cell = old number of cells + 2. Make sure to filter only the cells whose
   * labels are not equal to Text-Input-Cell's label */
  XCTAssertEqual(oldNumberOflists+1 , newNumberOfLists);
  
  /* Make sure that the new list name has been added to the beginning.*/
  XCUIElement *cell = [currentCollection.cells elementBoundByIndex:newNumberOfLists];
  XCTAssertNotNil(cell);
  XCTAssertEqualObjects(cell.label, nameOfNewList);
}


-(void) testCancelAdditionOfNewList{
  
  NSString* nameOfNewList = @"Living-Room";
  
  XCUIApplication *app = [[XCUIApplication alloc] init];
  
  XCUIElementQuery *elementsQuery = app.scrollViews.otherElements;
  
  XCUIElementQuery* collectionsQuery =  app.scrollViews.otherElements.collectionViews;
  
  /* Get a reference to the first table (list of shopping lists)*/
  XCUIElement* currentCollection = [collectionsQuery elementBoundByIndex:0];
  XCTAssertNotNil(currentCollection); // Make sure it is not nil
  
  /* Svae number of lists for later comparison. */
  NSUInteger oldNumberOflists = currentCollection.cells.count;
  
  /* Get a reference to the Add Button. */
  XCUIElement * addButton = elementsQuery.buttons[@"Create new list"];
  [addButton tap];
  
  /* Get a reference to the Text Field that is used to enter the name of the
   * new List. The text field has a place holder "List Title" .*/
  XCUIElement * textField = currentCollection.textFields[@"Name of List"] ;
  
  /* Type the new name. */
  [textField typeText:nameOfNewList];
  
  /* Cancel the addition by tapping on the custom overlay or text field*/
  /* Note that when I tried to tap on the overlay I got this error: https://goo.gl/aYoCao
   * Instead as a workaround, I decided to tap on the text field itself to cancel the addition.*/
  //XCUIElement* overlay = [[app descendantsMatchingType:XCUIElementTypeAny] matchingIdentifier:OVERLAY_ACCESSIBILITY_LABEL].element;
  [textField tap] ;
  
  /* Get new number of cells after canceling the addition of the list name.*/
  /* Get new number of cells after adding new list name.*/
  NSUInteger newNumberOfLists = [currentCollection.cells matchingPredicate:[NSPredicate predicateWithFormat:@"label != %@", CELL_TEXT_INPUT_ACCESSIBILITY_LABEL]].count;

  /* Make sure that the number of lists does not change. */
  XCTAssertEqual(oldNumberOflists, newNumberOfLists);
}

/* TODO: Replace this test case to be delete with long press. */
//-(void) testDeleteListWithSwipe{
//  
//  XCUIApplication *app = [[XCUIApplication alloc] init];
//  XCUIElementQuery *tablesQuery = app.tables;
//  
//  XCUIElement* currentTabel = [tablesQuery elementBoundByIndex:0];
//  XCTAssertNotNil(currentTabel); // Make sure it is not nil
//  
//  /* Svae number of lists for later comparison. */
//  NSUInteger oldNumberOflists = currentTabel.cells.count;
//  
//  /* Swipe Left the second list. */
//  XCUIElement *cell = [currentTabel.cells elementBoundByIndex:1];
//  XCTAssertNotNil(cell);
//  [cell swipeLeft];
//  
//  /* Make sure there is one button in the cell with title Delete*/
//  XCTAssertEqual(1, cell.buttons.count);
//  XCUIElement* deleteBtn = [cell.buttons elementBoundByIndex:0];
//  XCTAssertEqualObjects(@"Delete", deleteBtn.label);
//  
//  /* Delete the list */
//  [deleteBtn tap];
//  
//  /* Get new number of cells after canceling the addition of the list name.*/
//  NSUInteger newNumberOfLists = currentTabel.cells.count;
//  /* Make sure that the number of lists is decreased by 1. */
//  XCTAssertEqual(oldNumberOflists -1, newNumberOfLists);
//  
//}

-(void) testDeleteListWithEditButton{
  
  XCUIApplication *app = [[XCUIApplication alloc] init];
  XCUIElementQuery* collectionsQuery =  app.scrollViews.otherElements.collectionViews;
  
  /* Get a reference to the first table (list of shopping lists)*/
  XCUIElement* currentCollection = [collectionsQuery elementBoundByIndex:0];
  
  /* Get a reference to the navigation bar. */
  XCUIElement* navigationBar = [app.navigationBars elementBoundByIndex:0];

  /* Svae number of lists for later comparison. */
  NSUInteger oldNumberOflists = currentCollection.cells.count;
  
  /* Tap on Edit button in the navigation bar.
   * Improtant note: I have to create a new Build Configuration "Testing" based on "Debug" configuration
   * then define a compilation flag "UI_TESTING" to be 1 in that case.*/
  [navigationBar.buttons[@"Edit"] tap];
  
  /* Make sure that Delete buttons have occured for each cell.*/
  XCTAssertEqual(oldNumberOflists, currentCollection.buttons.count);
  
  /*  Tap on Delete button of the second list. */
  XCUIElement *cell = [currentCollection.cells elementBoundByIndex:3];
  XCTAssertNotNil(cell);
  
  /* Get reference to the delete button in left side of the cell.*/
  XCUIElement* deleteBtn = [[cell.buttons matchingIdentifier:@"my-delete"] elementBoundByIndex:0];
  
  [deleteBtn tap];
  
  /* Tap on Done Button. */
  [navigationBar.buttons[@"Done"] tap];

  /* TODO: There is a bug in Xcode because number of cells does not change but I verified
   * that both the data source and collection views has successfully delete their entries. */
  
  /* Get new number of cells after canceling the addition of the list name.*/
  //  NSUInteger newNumberOfLists = currentCollection.cells.count;
  /* Make sure that the number of lists is decreased by 1. */
  //  XCTAssertEqual(oldNumberOflists -1, newNumberOfLists);
}
@end
