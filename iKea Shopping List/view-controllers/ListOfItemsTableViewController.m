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
#define TOTAL_PRICE_PREFIX     @"Total Price: "
#define FIRST_INDEX_INSECTION        0

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
    
    /* Set data source delegate of the table view. */
    self.listOfItemsDataSource = [[ItemsDataSource alloc]
                                  initWithItems: self.shoppingList];
    self.tableView.dataSource = self.listOfItemsDataSource;

    /* make sure to hide remove separators between empty cells */
    self.tableView.tableFooterView = [UIView new];

    /* Load global header having the total price of the list.*/
    [self loadGlobalHeaderView];
}

- (void)didReceiveMemoryWarning {
   
    self.listOfItemsDataSource = nil;
    [super didReceiveMemoryWarning];
}

#pragma global header
-(void) loadGlobalHeaderView {
    
    if (self.globalHeader == nil) {
        NSArray* topLevelObjects = [[NSBundle mainBundle]
                                     loadNibNamed:@"items-table-header-view"
                                            owner:self
                                          options:nil];
        self.globalHeader = [topLevelObjects objectAtIndex:0];
    }
    
    self.globalHeader.text =
        [TOTAL_PRICE_PREFIX stringByAppendingString:
                        self.shoppingList.totalPrice.stringValue];
    
    self.tableView.tableHeaderView = self.globalHeader;
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


- (void)insertNewShoppingItem{
    
    /* add the new list object to the data source. */
    ShoppingItem* newItem =
        [[ShoppingItem alloc]
          initWithName:@"New Name"
                 price:[[NSDecimalNumber alloc] initWithDouble:54.49]
                 image:@"image Name"
           aisleNumber:50
             binNumber:30
         articleNumber:@"113.45.23"
              quantity:1];
    

    /* add new item in the first index of the section */
    NSInteger virtualSectionIndex =
        [self.listOfItemsDataSource insertShoppingItem:newItem];
    
    /* TODO: in case new section is added, reload data is needed. */
    //BOOL flag = [self.listOfItemsDataSource isNewSection:actualSectionNum];

    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0
                                                inSection:virtualSectionIndex];

    /* add the new shopping item to the table view. */
    [self.tableView insertRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

/*
#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
