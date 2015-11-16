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

    /* Get a reference to the first table (list os shopping lists)*/
    XCUIElement* currentTabel = [tablesQuery elementBoundByIndex:0];
    XCTAssertNotNil(currentTabel); // Make sure it is not nil
    
    /* Get a reference to the navigation bar. it will be used to navigate back again. */
    XCUIElement* navigationBar = [app.navigationBars elementBoundByIndex:0];
    
    /* Tap on first list. */
    XCUIElement *cell = [currentTabel.cells elementBoundByIndex:0];
    XCTAssertNotNil(cell);
    [cell tap];
    
    /* Tap on first cell in the second table. Note that current table has been updated
     to list of items table at this point. */
    cell = [currentTabel.cells elementBoundByIndex:0];
    XCTAssertNotNil(cell);
    [cell tap];

    /* Now, user at detailed screen. Tap back button to get back to list of shopping items table. */
    [navigationBar.buttons[@"Back"] tap];

    /* Tap back again to reach list os shopping lists table.*/
    [navigationBar.buttons[@"Back"] tap];
}

@end
