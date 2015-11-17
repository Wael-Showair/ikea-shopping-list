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

@interface ItemsDataSource()
#define FIRST_ROW_INDEX     0
@property ShoppingList* allItems;
@property AislesPivotTable* pivotTable;
@end

@implementation ItemsDataSource


/*!
 *  @define LIST_OF_ITEMS_CELL_IDENTIFIER
 *  @abstract table view cell tag that is used to idenify the cells for reuse.
 */
#define LIST_OF_ITEMS_CELL_IDENTIFIER   @"item-summary-cell"

#define LIST_TOTAL_PRICE_CELL_IDENTIFIER @"list-total-price-cell"


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
    NSInteger physicalSectionIndex = [self.pivotTable
                        physicalSecIndexForSection:indexPath.section];
    
    /* construct the actual index path. */
    NSIndexPath *actualIndexPath =
            [NSIndexPath indexPathForRow:indexPath.row
                               inSection:physicalSectionIndex];
    
    /* Get the item that is stored at the actual index path. */
    return [self.allItems itemAtAisleIndexPath:actualIndexPath];
}

#pragma table view - data source delegate

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell* cell = [tableView
            dequeueReusableCellWithIdentifier:LIST_OF_ITEMS_CELL_IDENTIFIER];
    
    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section{
    
    /* Get actual array index (physical section index) from pivot table.*/
    NSInteger physicalSectionIndex = [self.pivotTable
                                      physicalSecIndexForSection:section];

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
        //TODO: Delete object from data array itself.
        
        
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
        
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

-(NSInteger)insertShoppingItem:(ShoppingItem*)newItem{

    /* Get where exactly the index of the new item's aisle number from
     the pivot table. */
    /* Get actual array index (physical section index) from pivot table.*/
    NSInteger virtualSectionIndex = [self.pivotTable
                            virtualSectionForAisleNumber:newItem.aisleNumber];
    
    /*If the virtual section index is not found, create a new entry in the pivot
     table*/
    if([self isItNewSection:virtualSectionIndex]){
        [self.pivotTable addNewAisleNumber:newItem.aisleNumber
                       forActualIndex:[self.pivotTable numberOfAisles]];
    }
    
    /* Get actual array index (physical section index) from pivot table.
       Currently, Virtual/Physical indeces are the last index in the respective
       arrays. */
    NSInteger physicalSectionIndex = [self.pivotTable
                                physicalSecIndexForSection:virtualSectionIndex];
    
    [self.allItems addNewItem:newItem AtAisleIndex:physicalSectionIndex];
    
    return virtualSectionIndex;
}

-(BOOL) isItNewSection: (NSUInteger) section{
    return section == [self.pivotTable numberOfAisles];
}

@end
