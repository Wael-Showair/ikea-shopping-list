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

@interface ListsDataSource()

/*!
 *  @define LISTS_CELL_IDENTIFIER
 *  @abstract table view cell tag that is used to idenify the cells for reuse.
 */
#define LISTS_CELL_IDENTIFIER       @"cellForListOfLists"

@property NSMutableArray* allItems;
@end

@implementation ListsDataSource

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

-(void) insertObject:(id)object AtIndex:(NSUInteger)index{
    [self.allItems insertObject:object
                        atIndex:index];
}

-(void) removeObjectAtIndex: (NSUInteger)index{
    [self.allItems removeObjectAtIndex:index];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:LISTS_CELL_IDENTIFIER];

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
