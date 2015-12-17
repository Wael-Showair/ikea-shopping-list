//
//  AislesPivotTable.m
//  iKea Shopping List
//
//  Created by Wael Showair on 2015-11-12.
//  Copyright © 2015 showair.wael@gmail.com. All rights reserved.
//
#import "ShoppingList.h"
#import "PivotEntry.h"
#import "AislesPivotTable.h"

#define SORTIN_DURING_INSERTION     1

@interface AislesPivotTable()

@property(strong, nonatomic) NSMutableArray* table;

@end

@implementation AislesPivotTable

- (instancetype)initWithItems:(ShoppingList *)items
{
  self = [super init];
  if (self) {
    
    self.table = [[NSMutableArray alloc] init];
    NSInteger i = 0;
    /* Loop through the given items list,
     get first element in each sub-array
     relate the actual index to aisle the number */
    NSMutableArray* aislesCollection = [items getAislesCollection];

    for(NSMutableArray* itemsPerAisle in aislesCollection){
    
      NSUInteger aisleNum = ((ShoppingItem*)[itemsPerAisle objectAtIndex:0]).aisleNumber;
      
      PivotEntry* entry = [[PivotEntry alloc] initWithAisleNum:aisleNum
                                                 PhysicalIndex:i++];
      [self.table addObject:entry];
      
    }
#if SORTIN_DURING_INSERTION
    NSSortDescriptor* aisleDescriptor = [[NSSortDescriptor alloc] initWithKey:@"aisleNum"
                                                                    ascending:YES];

    NSArray* descriptors = [NSArray arrayWithObject:aisleDescriptor];
    
    [self.table sortUsingDescriptors:descriptors];
#endif /* if SORTED*/
    
  }
  return self;
}

-(NSInteger)addNewAisleNumber: (NSUInteger)aisleNumber
               forActualIndex: (NSUInteger)index
           withAscendingOrder: (BOOL) ascenOrder{
  PivotEntry* entry = [[PivotEntry alloc] initWithAisleNum:aisleNumber PhysicalIndex:index];
  [self.table addObject:entry];
  
#if SORTIN_DURING_INSERTION
  /* sort again the pivot table.*/
  NSSortDescriptor* aisleDescriptor = [[NSSortDescriptor alloc] initWithKey:@"aisleNum"
                                                                  ascending:ascenOrder];
  NSArray* descriptors = [NSArray arrayWithObject:aisleDescriptor];
  
  [self.table sortUsingDescriptors:descriptors];
  return [self.table indexOfObject:entry];
#else
  return self.table.count-1;
#endif
}

- (void)removeEntryWithAisleNumber: (NSUInteger)aisleNumber{
  NSUInteger index = [self virtualSectionForAisleNumber:aisleNumber];
  
  if(NSNotFound != index){
    /* update any entry having physical index greater than the index to be
     * removed such that its physical is decreased by 1. */
    NSUInteger physicalIndexToBeRemoved = ((PivotEntry*)self.table[index]).aisleIndex;
    for(PivotEntry* entry in self.table){
      if(entry.aisleIndex > physicalIndexToBeRemoved){
        entry.aisleIndex --;
      }
    }
    [self.table removeObjectAtIndex:index];
  }
}

- (void) removeEntryWithVirtualIndex: (NSUInteger) index{
  /* update any entry having physical index greater than the index to be
   * removed such that its physical is decreased by 1. */
  NSUInteger physicalIndexToBeRemoved = ((PivotEntry*)self.table[index]).aisleIndex;
  for(PivotEntry* entry in self.table){
    if(entry.aisleIndex > physicalIndexToBeRemoved){
      entry.aisleIndex --;
    }
  }
  [self.table removeObjectAtIndex:index];
}

- (NSInteger) physicalSecIndexForSection: (NSUInteger) virtualSecNum{
  
  PivotEntry* entry = self.table[virtualSecNum];
  return entry.aisleIndex;
}

-(NSInteger)virtualSectionForAisleNumber:(NSUInteger)aisleNum{
  /* loop in pivot table, then return the index
   of the given aisle number.
   in case the aisle number is totally new one, return length as new virtual index */
  NSUInteger foundIndex =
  [self.table indexOfObjectPassingTest:
   ^BOOL(id obj, NSUInteger idx, BOOL *stop){
     PivotEntry* entry = (PivotEntry*) obj;
     if(entry.aisleNum == aisleNum){
       *stop = YES;
       return YES;
     }
     return NO;
     
   }];
  
  return foundIndex;
}

- (NSUInteger) aisleNumberAtVirtualIndex: (NSUInteger) sectionIndex{
  PivotEntry* entry = self.table[sectionIndex];
  return entry.aisleNum;
}

- (NSUInteger) numberOfAisles{
  return self.table.count;
}

@end
