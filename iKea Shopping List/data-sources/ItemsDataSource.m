//
//  ItemsDataSource.m
//  iKea Shopping List
//
//  Created by Wael Showair on 2015-11-09.
//  Copyright © 2015 showair.wael@gmail.com. All rights reserved.
//

#import "ItemsDataSource.h"

@interface ItemsDataSource()
@property NSMutableArray* allItems;
@end

@implementation ItemsDataSource


/*!
 *  @define LIST_OF_ITEMS_CELL_IDENTIFIER
 *  @abstract table view cell tag that is used to idenify the cells for reuse.
 */
#define LIST_OF_ITEMS_CELL_IDENTIFIER   @"item-summary-cell"

#define LIST_TOTAL_PRICE_CELL_IDENTIFIER @"list-total-price-cell"




- (instancetype)initWithItems:(NSMutableArray *)items
{
    self = [super init];
    if (self) {
        self.allItems = items;
    }
    return self;
}

-(id)itemAtIndexPath:(NSIndexPath *)indexPath{
    return [self.allItems objectAtIndex:indexPath.row];
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:LIST_OF_ITEMS_CELL_IDENTIFIER];
    
    return cell;
}

- (NSDecimalNumber *)getTotal{
    return [self.allItems objectAtIndex:0];
}

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section{
    return self.allItems.count;
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
- (void)tableView:(UITableView *)tableView
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

@end
