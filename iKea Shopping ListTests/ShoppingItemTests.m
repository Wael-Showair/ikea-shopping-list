//
//  iKea_Shopping_ListTests.m
//  iKea Shopping ListTests
//
//  Created by Wael Showair on 2015-10-25.
//  Copyright © 2015 showair.wael@gmail.com. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ShoppingItem.h"

@interface ShoppingItemTests : XCTestCase
@property ShoppingItem* shoppingItem;
@end

@implementation ShoppingItemTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInit {
    self.shoppingItem = [[ShoppingItem alloc] init];
    NSDecimalNumber* expectedPrice = [NSDecimalNumber decimalNumberWithString:@"0"];
    XCTAssertNotNil( self.shoppingItem.name);
    XCTAssertNotNil( self.shoppingItem.imageName);
    XCTAssertEqual(0, self.shoppingItem.aisleNumber);
    XCTAssertEqual(0, self.shoppingItem.binNumber);
    XCTAssertEqualObjects(expectedPrice, self.shoppingItem.price);
    XCTAssertEqual(0,self.shoppingItem.quantity);
}

- (void)testInitWithNameAndPrice {
    NSDecimalNumber* expectedPrice = [NSDecimalNumber decimalNumberWithString:@"599"];

    self.shoppingItem = [[ShoppingItem alloc] initWithName:@"Bed Frame" price:[NSDecimalNumber decimalNumberWithString:@"599"]];
    XCTAssertNotNil( self.shoppingItem.name);
    XCTAssertEqual(@"Bed Frame", self.shoppingItem.name);
    XCTAssertEqualObjects(expectedPrice, self.shoppingItem.price);
    XCTAssertNotNil( self.shoppingItem.imageName);
    XCTAssertEqual(0, self.shoppingItem.aisleNumber);
    XCTAssertEqual(0, self.shoppingItem.binNumber);
    XCTAssertEqual(0,self.shoppingItem.quantity);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
