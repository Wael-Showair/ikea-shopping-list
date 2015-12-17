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
#import "DetailedItemViewController.h"
#import "ItemsDataSource.h"
#import "ShoppingItem.h"


@interface ListOfItemsTableViewController ()
#define FIRST_INDEX_INSECTION        0
#define SHOW_ITEM_DETAILS_SEGUE_ID   @"showItemDetails"
#define ADD_NEW_ITEM_SEGUE_ID        @"addNewItem"
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

- (void) updateGlobalHeaderTotalPrice{
    self.globalHeader.text =
    [TOTAL_PRICE_PREFIX stringByAppendingString:
     self.shoppingList.totalPrice.stringValue];
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

- (void)itemDidCreated:(ShoppingItem*)newItem {
    
    /* When the user adds a new shopping item, I need to know
     * whether a new aisle number (i.e. section) has been added or not.
     * I have two choices:
     * 1- To return a boolean flag from insertShoppingItem: method
     * 2- To compare number of sections before and after the insertion.
     * The problem with the first choice is that I need to know the exact value
     * of the new section index to be able to call insertSections method instead
     * of reloadData method for the sake of performance. */
    NSInteger prevNumOfSections = [self.listOfItemsDataSource numberOfSectionsInTableView:self.tableView];
    
    /* add new item in the first index of the section */
    NSInteger virtualSectionIndex =
    [self.listOfItemsDataSource insertShoppingItem:newItem withAscendingOrder:YES];
    
    NSInteger newNumOfSections = [self.listOfItemsDataSource numberOfSectionsInTableView:self.tableView];
    
    NSIndexPath* indexPath;
    /* in case new section is added, reload data is needed. */
    if(newNumOfSections > prevNumOfSections){
        
        NSIndexSet* newSection =
        [NSIndexSet indexSetWithIndex:virtualSectionIndex];
        
        /* If a section already exists at the specified index location, it is
         * moved down one index location. */
        [self.tableView insertSections:newSection
                      withRowAnimation:UITableViewRowAnimationTop];
        
        /* Note: I can use reloadData but for performance considerations
         * I decided to use insertSections only.
         */
        
        indexPath = [NSIndexPath indexPathForRow:0
                                       inSection:virtualSectionIndex];
        
    }else{
        
        indexPath = [NSIndexPath indexPathForRow:0
                                       inSection:virtualSectionIndex];
        
        /* add the new shopping item to the table view. */
        [self.tableView insertRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }
    
    /* Scroll & Select to the new added row so that the user becomes aware of
     * the successfull operation. */
    [self.tableView selectRowAtIndexPath:indexPath
                                animated:YES
                          scrollPosition:UITableViewScrollPositionTop];
    
    [self updateGlobalHeaderTotalPrice];
    
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:SHOW_ITEM_DETAILS_SEGUE_ID]){
        DetailedItemViewController* destViewController = [segue destinationViewController];
        NSIndexPath* selectedIndexPath = [self.tableView indexPathForSelectedRow];
        ShoppingItem* shoppingItem = [self.listOfItemsDataSource itemAtIndexPath:selectedIndexPath];
        destViewController.shoppingItem = shoppingItem;
        destViewController.isNewItem = NO;
        
    }else if ([segue.identifier isEqualToString:ADD_NEW_ITEM_SEGUE_ID]){
        DetailedItemViewController* destViewController = [segue destinationViewController];
        
        ShoppingItem* shoppingItem = [[ShoppingItem alloc] initWithName:@"New Item" price:[NSDecimalNumber decimalNumberWithString:@"0.0"]];
        
        destViewController.shoppingItem = shoppingItem;
        destViewController.isNewItem = YES;
        destViewController.shoppningItemDelegate = self;
        
    }
}


@end
