/*!
 *  @file ListOfItemsTableViewController.m
 *  implementation file that provides required operations for UI Tabel view
 *  controller for list of shopping items.
 *
 *  @author Wael Showair (showair.wael\@gmail.com)
 *  @version 0.0.1
 *  @copyright 2015. Wael Showair. All rights reserved.
 */

#import "ListOfItemsTableViewController.h"
#import "ArrayDataSource.h"
#import "ShoppingItem.h"

@interface ListOfItemsTableViewController ()

/*!
 *  @define LIST_OF_ITEMS_CELL_IDENTIFIER
 *  @abstract table view cell tag that is used to idenify the cells for reuse.
 */
#define LIST_OF_ITEMS_CELL_IDENTIFIER   @"cellForListOfItems"

/*!
 *  @property listOfItemsDataSource
 *  @abstract data source delegate for table view that display list of items.
 *  @discussion separate the model from the view and controller. This is done
 *  by creating separate class for data source delegate of the UITabelView.
 */
@property (nonatomic, strong) ArrayDataSource* listOfItemsDataSource;
@end

@implementation ListOfItemsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    /* Set the title of the table view scene.*/
    self.title = self.shoppingList.title;
    
    /* Get all items that are related to certain shopping list.*/
    NSMutableArray* allItems = [self.shoppingList getItems];
    
    /* Callback block that is used to populate the cells of Table view with
     the shopping item brief information.*/
    TableViewCellConfigureBlock cellConfigurationBlock =
        ^(UITableViewCell* cell, ShoppingItem* shoppingItem){
            cell.textLabel.text = shoppingItem.name;
            cell.detailTextLabel.text = shoppingItem.price.stringValue;
    };
    
    /* Set data source delegate of the table view. */
    self.listOfItemsDataSource = [[ArrayDataSource alloc]
                                  initWithItems: allItems
                                  cellIdentifier: LIST_OF_ITEMS_CELL_IDENTIFIER
                                  configureCellBlock:cellConfigurationBlock];
    self.tableView.dataSource = self.listOfItemsDataSource;

}

- (void)didReceiveMemoryWarning {
   
    self.listOfItemsDataSource = nil;
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
