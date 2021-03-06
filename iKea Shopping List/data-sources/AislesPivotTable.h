//
//  AislesPivotTable.h
//  iKea Shopping List
//
//  Created by Wael Showair on 2015-11-12.
//  Copyright © 2015 showair.wael@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShoppingList.h"

@interface AislesPivotTable : NSObject

-(instancetype) initWithItems: (ShoppingList *) items;

-(NSInteger) addNewAisleNumber: (NSUInteger) aisleNumber
                forActualIndex: (NSUInteger) index
            withAscendingOrder: (BOOL) ascenOrder;

- (void) removeEntryWithAisleNumber: (NSUInteger) aisleNumber;
- (void) removeEntryWithVirtualIndex: (NSUInteger) index;


- (NSInteger) physicalSecIndexForSection: (NSUInteger) virtualSecNum;
- (NSInteger) virtualSectionForAisleNumber: (NSUInteger) aisleNum;

- (NSUInteger) aisleNumberAtVirtualIndex: (NSUInteger) sectionIndex;
- (NSUInteger) numberOfAisles;
@end
