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
#import "ItemsDataSource.h"
#import "ShoppingItem.h"

@interface ListOfItemsTableViewController ()
#define TOTAL_PRICE     @"Total Price: "
/*!
 *  @property listOfItemsDataSource
 *  @abstract data source delegate for table view that display list of items.
 *  @discussion separate the model from the view and controller. This is done
 *  by creating separate class for data source delegate of the UITabelView.
 */
@property (nonatomic, strong) ItemsDataSource* listOfItemsDataSource;
@property (nonatomic, weak)   UILabel* globalHeader;
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
    
    /* Set data source delegate of the table view. */
    self.listOfItemsDataSource = [[ItemsDataSource alloc]
                                  initWithItems: allItems];
    self.tableView.dataSource = self.listOfItemsDataSource;

    /* make sure to hide remove separators between empty cells */
    self.tableView.tableFooterView = [UIView new];
    
    self.tableView.tableHeaderView = [self getGlobalHeaderView];
}

- (void)didReceiveMemoryWarning {
   
    self.listOfItemsDataSource = nil;
    [super didReceiveMemoryWarning];
}

#pragma global header
-(UIView *) getGlobalHeaderView {
    if (self.globalHeader == nil) {
        NSArray* topLevelObjects = [[NSBundle mainBundle]
                                     loadNibNamed:@"items-table-header-view"
                                            owner:self
                                          options:nil];
        self.globalHeader = [topLevelObjects objectAtIndex:0];
        self.globalHeader.text =
            [TOTAL_PRICE stringByAppendingString:
                            self.shoppingList.totalPrice.stringValue];
    }
    
    return self.globalHeader;
}

#pragma table view - delegate
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ShoppingItem* shoppingItem = [self.listOfItemsDataSource
                                  itemAtIndexPath:indexPath];
    cell.textLabel.text = shoppingItem.name;
    cell.detailTextLabel.text = shoppingItem.price.stringValue;
    
    UIImage* itemImage = [UIImage imageNamed:shoppingItem.imageName];
    [cell.imageView setImage:itemImage];
}

/*
#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
