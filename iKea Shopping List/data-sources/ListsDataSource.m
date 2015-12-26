/*
 *
 *  @file ArrayDataSource.m
 *  implementation file that provides all the needed operations for an iKea shopping list.
 *
 *  @author Wael Showair (showair.wael\@gmail.com)
 *  @version 0.0.1
 *  @copyright 2015. Wael Showair. All rights reserved.
 */
#import <UIKit/UIKit.h>
#import "ListsDataSource.h"
#import "ShoppingList.h"

/*!
 *  @define LISTS_CELL_IDENTIFIER
 *  @abstract table view cell tag that is used to idenify the cells for reuse.
 */
#define LISTS_CELL_IDENTIFIER       @"cellForListOfLists"
#define NEW_LIST_INFO_CELL_ID   @"new-list-info-cell"
#define TEXT_FIELD_CELL_NIB     @"text-input-table-view-cell"

@interface ListsDataSource()

@property (strong, nonatomic) NSMutableArray* allItems;
@end

@implementation ListsDataSource

- (instancetype)initWithItems:(NSMutableArray *)items
{
  self = [super init];
  if (self) {
    self.allItems = items;
    self.rowIndexForTextInputCell = INVALID_ROW_INDEX;
  }
  return self;
}

-(id)itemAtIndexPath:(NSIndexPath *)indexPath{
  return [self.allItems objectAtIndex:indexPath.row];
}

-(void) insertObject:(id)object AtIndex:(NSUInteger)index{
  [self.allItems insertObject:object atIndex:index];
  self.rowIndexForTextInputCell = index;
}

-(void) removeObjectAtIndex: (NSUInteger)index{
  [self.allItems removeObjectAtIndex:index];
}

- (void)renameListToTitle:(NSString*) newTitle atIndexPath:(NSIndexPath*) indexPath{
  ShoppingList* list = (ShoppingList*) [self.allItems objectAtIndex:indexPath.row];
  list.title = newTitle;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  UITableViewCell* cell;
  
  if(indexPath.row == self.rowIndexForTextInputCell){
    cell = [tableView dequeueReusableCellWithIdentifier:NEW_LIST_INFO_CELL_ID];
    /* Because the prototype cell is NOT defined in a storyboard, the
     * dequeueReusableCellWithIdentifier: method might NOT return a valid cell.
     * You need to check the return value against nil and create a cell
     * manually.*/
    if(cell == nil){
      
      UINib* nib = [UINib nibWithNibName:TEXT_FIELD_CELL_NIB bundle:nil];
      
      [tableView registerNib:nib forCellReuseIdentifier:NEW_LIST_INFO_CELL_ID];
      
      cell = [tableView dequeueReusableCellWithIdentifier:NEW_LIST_INFO_CELL_ID];
    }
    
  }else{
    /* Because the prototype cell is defined in a storyboard, the
     * dequeueReusableCellWithIdentifier: method always returns a valid cell.
     * You don’t need to check the return value against nil and create a cell
     * manually.*/
     cell = [tableView dequeueReusableCellWithIdentifier:LISTS_CELL_IDENTIFIER];
  }
  return cell;
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
    //Delete object from data array itself.
    [self removeObjectAtIndex:indexPath.row];
    
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
