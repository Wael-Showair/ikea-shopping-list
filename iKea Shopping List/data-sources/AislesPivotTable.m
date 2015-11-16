//
//  AislesPivotTable.m
//  iKea Shopping List
//
//  Created by Wael Showair on 2015-11-12.
//  Copyright © 2015 showair.wael@gmail.com. All rights reserved.
//
#import "ShoppingList.h"
#import "AislesPivotTable.h"

@interface PivotEntry : NSObject
@property NSInteger aisleIndex;
@property NSUInteger aisleNum;
@end

@implementation PivotEntry
- (instancetype)initWithAisleNum: (NSUInteger) number
                   PhysicalIndex: (NSInteger)  index
{
    self = [super init];
    if (self) {
        _aisleNum = number;
        _aisleIndex = index;
    }
    return self;
}


@end

@interface AislesPivotTable()
@property NSMutableArray* table;
@end

@implementation AislesPivotTable

- (instancetype)initWithItems:(ShoppingList *)items
{
    self = [super init];
    if (self) {
        
        _table = [[NSMutableArray alloc] init];
        
        /* Loop through the given items list,
           get first element in each sub-array
           relate the actual index to aisle the number */
        NSMutableArray* aislesCollection = [items getAislesCollection];
        for(int i=0 ;i<aislesCollection.count; i++){
            NSMutableArray* itemsPerAisle = aislesCollection[i];
            NSUInteger aisleNum =
                ((ShoppingItem*)[itemsPerAisle objectAtIndex:0]).aisleNumber;
            
            PivotEntry* entry = [[PivotEntry alloc] initWithAisleNum:aisleNum
                                                       PhysicalIndex:i];
            [_table addObject:entry];
            
        }
    }
    return self;
}

-(void)addNewAisleNumber:(NSUInteger)aisleNumber
     mappedToActualIndex:(NSUInteger)index{
    
}

- (void)removeAisleNumber:(NSUInteger)aisleNumber{
    
}

- (NSInteger) physicalSecIndexForSection: (NSUInteger) virtualSecNum{
    
    PivotEntry* entry = self.table[virtualSecNum];
    return entry.aisleIndex;
}

-(NSInteger)virtualSectionForAisleNumber:(NSUInteger)aisleNum{
    /* loop in pivot table, then return the actual index
     of the given aisle number.
     in case the aisle number is totally new one, return length+1 */
    //    NSUInteger foundIndex =
    //      [self.table indexOfObjectPassingTest:
    //        ^BOOL(id obj, NSUInteger idx, BOOL *stop){
    //            PivotEntry* entry = (PivotEntry*) obj;
    //            if(entry.aisleIndex == virtualSecNum){
    //                *stop = YES;
    //                return idx;
    //            }else
    //                return idx;
    //        
    //    }];
    return 0;
}

- (NSUInteger) aisleNumberAtVirtualIndex: (NSUInteger) sectionIndex{
    PivotEntry* entry = self.table[sectionIndex];
    return entry.aisleNum;
}

- (NSUInteger) numberOfAisles{
    return self.table.count;
}

@end
