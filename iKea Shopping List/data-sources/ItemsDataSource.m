//
//  ItemsDataSource.m
//  iKea Shopping List
//
//  Created by Wael Showair on 2015-11-09.
//  Copyright © 2015 showair.wael@gmail.com. All rights reserved.
//

#import "ShoppingList.h"
#import "AislesPivotTable.h"
#import "ItemsDataSource.h"

#define FIRST_ROW_INDEX     0

@interface ItemsDataSource()

@property(strong, nonatomic) ShoppingList* allItems;
@property(strong, nonatomic) AislesPivotTable* pivotTable;

@end

/*!
 *  @define LIST_OF_ITEMS_CELL_IDENTIFIER
 *  @abstract table view cell tag that is used to idenify the cells for reuse.
 */
#define LIST_OF_ITEMS_CELL_IDENTIFIER   @"item-summary-cell"

#define LIST_TOTAL_PRICE_CELL_IDENTIFIER @"list-total-price-cell"


@implementation ItemsDataSource

- (instancetype)initWithItems:(ShoppingList *)items
{
  self = [super init];
  if (self) {
    self.allItems = items;
    self.pivotTable = [[AislesPivotTable alloc] initWithItems: items];
  }
  return self;
}

-(id)itemAtIndexPath:(NSIndexPath *)indexPath{
  
  /* Get actual array index (physical section index) from pivot table.*/
  NSInteger physicalSectionIndex = [self.pivotTable physicalSecIndexForSection:indexPath.section];
  
  /* construct the actual index path. */
  NSIndexPath *actualIndexPath = [NSIndexPath indexPathForRow:indexPath.row
                                                    inSection:physicalSectionIndex];
  
  /* Get the item that is stored at the actual index path. */
  return [self.allItems itemAtAisleIndexPath:actualIndexPath];
}

#pragma table view - data source delegate

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
  /* Because the prototype cell is defined in a storyboard, the
   * dequeueReusableCellWithIdentifier: method always returns a valid cell.
   * You don’t need to check the return value against nil and create a cell
   * manually.*/
  UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:LIST_OF_ITEMS_CELL_IDENTIFIER];
  
  return cell;
}


-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section{
  
  /* Get actual array index (physical section index) from pivot table.*/
  NSInteger physicalSectionIndex = [self.pivotTable physicalSecIndexForSection:section];
  
  return [self.allItems numberOfItemsAtAisleIndex: physicalSectionIndex];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*) tableView{
  
  return [self.pivotTable numberOfAisles];
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section{
  
  NSUInteger aisleNum  = [self.pivotTable aisleNumberAtVirtualIndex:section];
  return [NSString stringWithFormat:@"Aisle Number %@", @(aisleNum)];
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView
 canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/* Override to support editing the table view.
 * To enable the swipe-to-delete feature of table views
 */
- (void) tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath {
  
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    /* Delete object from data array itself. */
    NSUInteger physicalIndex = [self.pivotTable physicalSecIndexForSection:indexPath.section];
    NSIndexPath* physicalIndexPath = [NSIndexPath indexPathForRow:indexPath.row
                                                        inSection:physicalIndex];
    
    
    /* If Aisle contains only one item, remove the entry from the pivot table
     * and remove the whole section from the table view. */
    if(1 == [self.allItems numberOfItemsAtAisleIndex:physicalIndex]){
      
      /* Remove the pivot entry. */
      [self.pivotTable removeEntryWithVirtualIndex:indexPath.section];
      
      /* Remove the aisle sub-array from the data array itself. */
      [self.allItems removeItemAtIndexPath:physicalIndexPath];
      
      /* Remove the section from the table view as well. */
      NSIndexSet* sectionToBeRemoved = [NSIndexSet indexSetWithIndex:indexPath.section];
      
      [tableView deleteSections:sectionToBeRemoved
               withRowAnimation:UITableViewRowAnimationBottom];
    }else{
      
      /* Remove item from the aisle sub-array. */
      [self.allItems removeItemAtIndexPath:physicalIndexPath];
      
      [tableView deleteRowsAtIndexPaths:@[indexPath]
                       withRowAnimation:UITableViewRowAnimationFade];
    }
    
    /* Update the total price of the list. */
    ((UILabel*)tableView.tableHeaderView).text =
        [TOTAL_PRICE_PREFIX stringByAppendingString:self.allItems.totalPrice.stringValue];
    
  }
}

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma helper- methods

-(NSInteger)insertShoppingItem: (ShoppingItem*)newItem
            withAscendingOrder: (BOOL) ascenOrder{
  
  /* Get where exactly the index of the new item's aisle number from
   the pivot table. */
  /* Get actual array index (physical section index) from pivot table.*/
  NSInteger virtualSectionIndex = [self.pivotTable virtualSectionForAisleNumber:newItem.aisleNumber];
  
  /*If the virtual section index is not found, create a new entry in the pivot
   table*/
  if([self isItNewSection:virtualSectionIndex]){
    virtualSectionIndex = [self.pivotTable addNewAisleNumber: newItem.aisleNumber
                                              forActualIndex: [self.pivotTable numberOfAisles]
                                          withAscendingOrder: ascenOrder];
  }
  
  /* Get actual array index (physical section index) from pivot table.
   Currently, Virtual/Physical indeces are the last index in the respective
   arrays. */
  NSInteger physicalSectionIndex = [self.pivotTable physicalSecIndexForSection:virtualSectionIndex];
  
  [self.allItems addNewItem:newItem AtAisleIndex:physicalSectionIndex];
  
  return virtualSectionIndex;
}

-(BOOL) isItNewSection: (NSUInteger) section{
  //    return section == [self.pivotTable numberOfAisles];
  return section == NSNotFound;
}

@end
