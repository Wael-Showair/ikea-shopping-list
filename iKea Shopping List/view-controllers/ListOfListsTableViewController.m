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
#import "ListAdditionViewController.h"

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


#define ADD_NEW_LIST_SEGUE_ID     @"addNewListInfo"

#define FIRST_INDEX     0

#define FIRST_SECTION_INDEX     0

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
    
    /* Set data source delegate of the table view under control. */
    self.listOfListsDataSource =
        [[ArrayDataSource alloc] initWithItems:allLists
                                cellIdentifier:LISTS_CELL_IDENTIFIER];
    self.tableView.dataSource = self.listOfListsDataSource;
    
    /* set left bar button to default button that toggles its title and 
     associated state between Edit and Done. */
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
}

- (void)didReceiveMemoryWarning {
    
    // Dispose of any resources that can be recreated.
    self.navBarDelegate = nil;
    self.listOfListsDataSource = nil;
    
    [super didReceiveMemoryWarning];
}

- (void)insertNewListWithTitle: (NSString*)title{

    /* add the new list object to the data source. */
    ShoppingList* newList = [[ShoppingList alloc] initWithTitle:title];
    [self.listOfListsDataSource insertObject:newList AtIndex:FIRST_INDEX];
    
    /* add the new list to table view. */
    NSIndexPath* indexPath = [NSIndexPath indexPathForItem:FIRST_INDEX
                                                 inSection:FIRST_SECTION_INDEX];
    [self.tableView insertRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

#pragma table view - delegate
-(void)tableView:(UITableView *)tableView
 willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ShoppingList* shoppingList = [self.listOfListsDataSource
                                    itemAtIndexPath:indexPath];
    cell.textLabel.text = shoppingList.title;
    
}

/* Note that: If the delegate does not implement this method and the 
 * UITableViewCell object is editable (that is, it has its editing property 
 * set to YES), the cell has the UITableViewCellEditingStyleDelete style set for
 * it.*/
//-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView
//          editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return UITableViewCellEditingStyleDelete;
//}

#pragma list addition - delegate
- (void)listInfoDidCreatedWithTitle:(NSString *)title{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"%@",title);
    [self insertNewListWithTitle:title];
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
        
    }else if ([segue.identifier isEqualToString:ADD_NEW_LIST_SEGUE_ID]){
        ListAdditionViewController* modalViewController =
            [segue destinationViewController];
        modalViewController.listInfoCreationDelegate = self;
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
