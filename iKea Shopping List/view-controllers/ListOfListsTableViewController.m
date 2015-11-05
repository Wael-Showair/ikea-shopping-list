/*!
 *  @file ListOfListsTableViewController.m
 *  implementation file that provides required operations for UI Tabel view
 *  controller for list of shopping items lists.
 *
 *  @author Wael Showair (showair.wael\@gmail.com)
 *  @version 0.0.1
 *  @copyright 2015. Wael Showair. All rights reserved.
 */

#import "NavigationControllerDelegate.h"
#import "ListOfListsTableViewController.h"
#import "ArrayDataSource.h"
#import "ListOfItemsTableViewController.h"

#import "ShoppingItem.h"

@interface ListOfListsTableViewController ()


/*!
 *  @define LISTS_CELL_IDENTIFIER
 *  @abstract table view cell tag that is used to idenify the cells for reuse.
 */
#define LISTS_CELL_IDENTIFIER       @"cellForListOfLists"


/*!
 *  @define SHOW_LIST_ITEMS_SEGUE_ID
 *  @abstract Segue identifier that is used to show list of items related
 *  to specific list name.
 */
#define SHOW_LIST_ITEMS_SEGUE_ID    @"showListOfItems"

/*!
 *  @property navBarDelegate
 *  @abstract navigation controller delegate to control transition between
 *  table view controllers.
 *  @discussion The delegate is used to provide the custom animator object and
 *  to set the animation type while transitioning between view controllers.
 */
@property NavigationControllerDelegate* navBarDelegate;

/*!
 *  @property listOfListsDataSource
 *  @abstract data source delegate for table view that display list of shopping 
 *  lists.
 *  @discussion separate the model from the view and controller. This is done
 *  by creating separate class for data source delegate of the UITabelView.
 */
@property (nonatomic, strong) ArrayDataSource* listOfListsDataSource;

@end

@implementation ListOfListsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    /* set title of the landing page table. */
    self.title = @"My Lists";
    
    /* Set delegate for navigation controller. */
    self.navBarDelegate = [[NavigationControllerDelegate alloc] init];
    self.navigationController.delegate = self.navBarDelegate;
    
    /* TODO: Get the main lists' names from permanent storage. */
    NSMutableArray* allLists = [self populateTableWithData];
    
    /* Callback block that is used to populate the cells of Table view with
     the shopping list title.*/
    TableViewCellConfigureBlock cellConfigurationBlock =
        ^(UITableViewCell* cell, ShoppingList* shoppingList){
            cell.textLabel.text = shoppingList.title;
    };

    /* Set data source delegate of the table view under control. */
    self.listOfListsDataSource =
        [[ArrayDataSource alloc] initWithItems:allLists
                                cellIdentifier:LISTS_CELL_IDENTIFIER
                            configureCellBlock:cellConfigurationBlock];
    self.tableView.dataSource = self.listOfListsDataSource;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

/* In a storyboard-based application, you will often want to do a little
preparation before navigation*/
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if([segue.identifier isEqualToString:SHOW_LIST_ITEMS_SEGUE_ID]){
        
        ListOfItemsTableViewController* listOfItemsViewController =
            [segue destinationViewController];
        
        NSIndexPath* selectedIndexPath =
            [self.tableView indexPathForSelectedRow];

        ShoppingList* selectedShoppingList =
            [self.listOfListsDataSource itemAtIndexPath:selectedIndexPath];

        [listOfItemsViewController setShoppingList:selectedShoppingList];
    }
}

#pragma data loading
/* Temporary method to populate table with dummy data. */
- (NSMutableArray*) populateTableWithData{
    ShoppingItem* shoppingItem ;
    NSMutableArray* allLists = [[NSMutableArray alloc] init];

    /* Create Kitchen shopping List and add it to all data mutable array. */
    ShoppingList* shoppingList = [[ShoppingList alloc] initWithTitle:@"Kitchen"];
    [allLists addObject:shoppingList];
    /* Add spoons and forms to the kitchen shopping list. */
    shoppingItem = [[ShoppingItem alloc]
                        initWithName:@"Spoons"
                        price:[[NSDecimalNumber alloc] initWithDouble:12.3]];
    [shoppingList addNewItem:shoppingItem];
    shoppingItem = [[ShoppingItem alloc]
                        initWithName:@"Forks"
                        price:[[NSDecimalNumber alloc] initWithDouble:14.5]];
    [shoppingList addNewItem:shoppingItem];
    
    /* Create Bathrrom Shopping list and add it to all data mutable array. */
    shoppingList = [[ShoppingList alloc] initWithTitle:@"Bathroom"];
    [allLists addObject:shoppingList];
    /* Add tissues, soap & shampoo to the bathroom shopping list. */
    shoppingItem = [[ShoppingItem alloc]
                        initWithName:@"Tissues"
                    price:[[NSDecimalNumber alloc] initWithDouble:12.3]];
    [shoppingList addNewItem:shoppingItem];
    shoppingItem = [[ShoppingItem alloc]
                    initWithName:@"Soap"
                    price:[[NSDecimalNumber alloc] initWithDouble:34.5]];
    [shoppingList addNewItem:shoppingItem];
    shoppingItem = [[ShoppingItem alloc]
                    initWithName:@"Shampoo"
                    price:[[NSDecimalNumber alloc] initWithDouble:156.5]];
    
    [shoppingList addNewItem:shoppingItem];
    
    return allLists;
}

@end
