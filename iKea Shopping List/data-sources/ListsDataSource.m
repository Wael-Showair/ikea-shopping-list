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
#import "TextInputCell.h"

/*!
 *  @define LISTS_CELL_IDENTIFIER
 *  @abstract table view cell tag that is used to idenify the cells for reuse.
 */
#define LISTS_CELL_IDENTIFIER       @"cellForListOfLists"



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

-(void) removeListAtIndexPath: (NSIndexPath*) indexPath{
  [self.allItems removeObjectAtIndex:indexPath.row];
}

- (void)renameListToTitle:(NSString*) newTitle atIndexPath:(NSIndexPath*) indexPath{
  ShoppingList* list = (ShoppingList*) [self.allItems objectAtIndex:indexPath.row];
  list.title = newTitle;
}

#pragma collection view - data source



-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

  UICollectionViewCell* cell;
  
  if(indexPath.row == self.rowIndexForTextInputCell){
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:NEW_LIST_INFO_CELL_ID forIndexPath:indexPath ];
    /* Because the prototype cell is being registered with a nib file, the
     * dequeueReusableCellWithIdentifier: method will alwyas return a valid cell.
     */
    
  }else{
    /* Because the prototype cell is defined in a storyboard, the
     * dequeueReusableCellWithIdentifier: method always returns a valid cell.
     * You don’t need to check the return value against nil and create a cell
     * manually.*/
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:LISTS_CELL_IDENTIFIER forIndexPath:indexPath];
  }
  return cell;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
  return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section{
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
    [self removeListAtIndexPath:indexPath];
    
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
