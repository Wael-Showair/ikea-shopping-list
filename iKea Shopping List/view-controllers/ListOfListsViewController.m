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
#import "ListOfListsViewController.h"
#import "ListsDataSource.h"
#import "ListOfItemsTableViewController.h"
#import "ListAdditionViewController.h"
#import "ShoppingItem.h"
#import "OuterScrollView.h"
#import "ShoppingListsTableView.h"
#import "TextInputTableViewCell.h"

/*!
 *  @define SHOW_LIST_ITEMS_SEGUE_ID
 *  @abstract Segue identifier that is used to show list of items related
 *  to specific list name.
 */
#define SHOW_LIST_ITEMS_SEGUE_ID    @"showListOfItems"
#define EMPTY_STRING                @""

#define ADD_NEW_LIST_SEGUE_ID       @"addNewListInfo"

#define FIRST_INDEX                 0

#define FIRST_SECTION_INDEX         0

#define NUM_OF_LISTS                [self.listsTableView numberOfRowsInSection:0]

#define LAST_INDEX                  NUM_OF_LISTS - 1

@interface ListOfListsViewController ()

/*!
 *  @property navBarDelegate
 *  @abstract navigation controller delegate to control transition between
 *  table view controllers.
 *  @discussion The delegate is used to provide the custom animator object and
 *  to set the animation type while transitioning between view controllers.
 */
@property (strong, nonatomic) NavigationControllerDelegate* navBarDelegate;

/*!
 *  @property listOfListsDataSource
 *  @abstract data source delegate for table view that display list of shopping
 *  lists.
 *  @discussion separate the model from the view and controller. This is done
 *  by creating separate class for data source delegate of the UITabelView.
 */
@property (strong, nonatomic) ListsDataSource* listOfListsDataSource;
@property (weak, nonatomic) IBOutlet OuterScrollView *outerScrollView;
@property (weak, nonatomic) IBOutlet ShoppingListsTableView *listsTableView;
@end

@implementation ListOfListsViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;
  
  
  /* set title of the landing page table. */
  self.title = @"My Lists";
  
  /* Set delegate for navigation controller. TODO: Chech whether you really need
   * this delegate as a property or not? I don't think that it must be a property.*/
  self.navBarDelegate = [[NavigationControllerDelegate alloc] init];
  self.navigationController.delegate = self.navBarDelegate;
  
  /* TODO: Get the main lists' names from permanent storage. */
  NSMutableArray* allLists = [self populateTableWithData];
  
  /* Set data source delegate of the table view under control. */
  self.listOfListsDataSource = [[ListsDataSource alloc] initWithItems:allLists];
  self.listsTableView.dataSource = self.listOfListsDataSource;
  self.listsTableView.delegate = self;
  
  /* set right bar button to default button that toggles its title and
   associated state between Edit and Done. */
  self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
  /* Set the view controller as a delegate for Sticky Header Protocol. */
  self.outerScrollView.stickyDelegate = self;
  
}

- (void)didReceiveMemoryWarning {
  
  // Dispose of any resources that can be recreated.
  self.navBarDelegate = nil;
  self.listOfListsDataSource = nil;
  
  [super didReceiveMemoryWarning];
}

//- (void)insertNewListWithTitle: (NSString*)title{
//  
//  /* add the new list object to the data source. */
//  ShoppingList* newList = [[ShoppingList alloc] initWithTitle:title];
//  [self.listOfListsDataSource insertObject:newList AtIndex:FIRST_INDEX];
//  
//  /* add the new list to table view. */
//  NSIndexPath* indexPath = [NSIndexPath indexPathForRow:FIRST_INDEX inSection:FIRST_SECTION_INDEX];
//  [self.listsTableView insertRowsAtIndexPaths:@[indexPath]
//                             withRowAnimation:UITableViewRowAnimationAutomatic];
//  
//}

#pragma scroll view - delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
  [(ShoppingListsTableView*)scrollView scrollViewDidScroll];
}

#pragma sticky view - delegate

- (void)viewDidDisappear: (UIView*) stickyView{
  UIBarButtonItem* addBtn = [[UIBarButtonItem alloc]
                             initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                             target:self
                             action:@selector(onTapAdd:)];
  
  self.navigationItem.leftBarButtonItem = addBtn;
}

-(void) viewWillAppear: (UIView*) stickyView{
  self.navigationItem.leftBarButtonItem = nil;
}

#pragma text field - delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
  self.outerScrollView.textFieldObscuredByKeyboard = textField;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
  NSIndexPath* indexPath = [NSIndexPath indexPathForRow:LAST_INDEX inSection:FIRST_SECTION_INDEX];
    [self.listOfListsDataSource renameListToTitle:textField.text atIndexPath:indexPath];
    [self.listsTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
  /* Hide Overlay view */
  NSLog(@"%s", __PRETTY_FUNCTION__);
  self.outerScrollView.textFieldObscuredByKeyboard = nil;
}

#pragma table view - delegate
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath{
  
  if(indexPath.row == self.listOfListsDataSource.rowIndexForTextInputCell){

    ((TextInputTableViewCell*)cell).inputText.text = EMPTY_STRING;
    
    /* Set the current view controller as a delegate for the textfield in the cell. */
    ((TextInputTableViewCell*)cell).inputText.delegate = self;
    
    /* populate the keyboard automatically. */
    [((TextInputTableViewCell*)cell).inputText becomeFirstResponder];
    
    /* Inform the data source that it should not use text input anymore. */
    self.listOfListsDataSource.rowIndexForTextInputCell = INVALID_ROW_INDEX;
  }else{
    ShoppingList* shoppingList = [self.listOfListsDataSource itemAtIndexPath:indexPath];
    cell.textLabel.text = shoppingList.title;
  }
  
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

- (IBAction)onTapAdd:(id)sender {
  
  /* add the new list object to the data source. */
  ShoppingList* newList = [[ShoppingList alloc] initWithTitle:@""];
  [self.listOfListsDataSource insertObject:newList AtIndex:LAST_INDEX+1];
  
  /* add the new list row to table view. */
  NSIndexPath* indexPath = [NSIndexPath indexPathForRow:LAST_INDEX+1 inSection:FIRST_SECTION_INDEX];
  [self.listsTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
  [self.listsTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
  
  /* Add a light overlay to the whole list view. On tap the overlay, dismiss the keyboard
   * & remove the newest entry from the table view. */
  /* If the user tap Go button, change the cell contents from text field to basic label.*/
  
}

- (void)listInfoDidCreatedWithTitle:(NSString *)title{
  NSLog(@"%s", __PRETTY_FUNCTION__);
  NSLog(@"%@",title);
  //[self insertNewListWithTitle:title];
}

#pragma mark - Navigation

/* In a storyboard-based application, you will often want to do a little
 preparation before navigation*/
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  
  if([segue.identifier isEqualToString:SHOW_LIST_ITEMS_SEGUE_ID]){
    
    ListOfItemsTableViewController* listOfItemsViewController =
    [segue destinationViewController];
    
    NSIndexPath* selectedIndexPath = [self.listsTableView indexPathForSelectedRow];
    
    ShoppingList* selectedShoppingList =
    [self.listOfListsDataSource itemAtIndexPath:selectedIndexPath];
    
    [listOfItemsViewController setShoppingList:selectedShoppingList];
    
  }else if ([segue.identifier isEqualToString:ADD_NEW_LIST_SEGUE_ID]){
    ListAdditionViewController* modalViewController = [segue destinationViewController];
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
                  initWithName:@"Refrigerator"
                  price:[[NSDecimalNumber alloc] initWithDouble:1999.00]
                  image:@"refrigerator"
                  aisleNumber: 50 ];
  [shoppingList addNewItem:shoppingItem AtAisleIndex:0];
  shoppingItem = [[ShoppingItem alloc]
                  initWithName:@"Mug"
                  price:[[NSDecimalNumber alloc] initWithDouble:12.99]
                  image:@"mug-turquoise"];
  [shoppingList addNewItem:shoppingItem AtAisleIndex:1];
  
  /* Create Bathrrom Shopping list and add it to all data mutable array. */
  shoppingList = [[ShoppingList alloc] initWithTitle:@"Bathroom"];
  [allLists addObject:shoppingList];
  /* Add faucet, dish-set & mat to the bathroom shopping list. */
  shoppingItem = [[ShoppingItem alloc]
                  initWithName:@"Faucet"
                  price:[[NSDecimalNumber alloc] initWithDouble:54.49]
                  image:@"faucet"
                  aisleNumber:50];
  [shoppingList addNewItem:shoppingItem AtAisleIndex:0];
  shoppingItem = [[ShoppingItem alloc]
                  initWithName:@"Mat"
                  price:[[NSDecimalNumber alloc] initWithDouble:12.99]
                  image:@"mat"
                  aisleNumber:101];
  [shoppingList addNewItem:shoppingItem AtAisleIndex:1];
  shoppingItem = [[ShoppingItem alloc]
                  initWithName:@"Dish Set"
                  price:[[NSDecimalNumber alloc] initWithDouble:12.99]
                  image:@"dish-set"
                  aisleNumber:43];
  [shoppingList addNewItem:shoppingItem AtAisleIndex:2];
  
  shoppingItem = [[ShoppingItem alloc]
                  initWithName:@"Faucet"
                  price:[[NSDecimalNumber alloc] initWithDouble:54.49]
                  image:@"faucet"
                  aisleNumber:33];
  [shoppingList addNewItem:shoppingItem AtAisleIndex:3];
  shoppingItem = [[ShoppingItem alloc]
                  initWithName:@"Mat"
                  price:[[NSDecimalNumber alloc] initWithDouble:12.99]
                  image:@"mat"
                  aisleNumber:101];
  [shoppingList addNewItem:shoppingItem AtAisleIndex:1];
  shoppingItem = [[ShoppingItem alloc]
                  initWithName:@"Dish Set"
                  price:[[NSDecimalNumber alloc] initWithDouble:12.99]
                  image:@"dish-set"
                  aisleNumber:33];
  [shoppingList addNewItem:shoppingItem AtAisleIndex:3];
  
  shoppingItem = [[ShoppingItem alloc]
                  initWithName:@"Faucet"
                  price:[[NSDecimalNumber alloc] initWithDouble:54.49]
                  image:@"faucet"
                  aisleNumber:43];
  [shoppingList addNewItem:shoppingItem AtAisleIndex:2];
  shoppingItem = [[ShoppingItem alloc]
                  initWithName:@"Mat"
                  price:[[NSDecimalNumber alloc] initWithDouble:12.99]
                  image:@"mat"
                  aisleNumber:33];
  [shoppingList addNewItem:shoppingItem AtAisleIndex:3];
  shoppingItem = [[ShoppingItem alloc]
                  initWithName:@"Dish Set"
                  price:[[NSDecimalNumber alloc] initWithDouble:12.99]
                  image:@"dish-set"
                  aisleNumber:50];
  [shoppingList addNewItem:shoppingItem AtAisleIndex:0];
  
  shoppingItem = [[ShoppingItem alloc]
                  initWithName:@"Faucet"
                  price:[[NSDecimalNumber alloc] initWithDouble:54.49]
                  image:@"faucet"
                  aisleNumber:50];
  [shoppingList addNewItem:shoppingItem AtAisleIndex:0];
  shoppingItem = [[ShoppingItem alloc]
                  initWithName:@"Mat"
                  price:[[NSDecimalNumber alloc] initWithDouble:12.99]
                  image:@"mat"
                  aisleNumber:101];
  [shoppingList addNewItem:shoppingItem AtAisleIndex:1];
  shoppingItem = [[ShoppingItem alloc]
                  initWithName:@"Dish Set"
                  price:[[NSDecimalNumber alloc] initWithDouble:12.99]
                  image:@"dish-set"];
  [shoppingList addNewItem:shoppingItem AtAisleIndex:4];
  
  shoppingItem = [[ShoppingItem alloc]
                  initWithName:@"Faucet"
                  price:[[NSDecimalNumber alloc] initWithDouble:54.49]
                  image:@"faucet"
                  aisleNumber:50];
  [shoppingList addNewItem:shoppingItem AtAisleIndex:0];
  shoppingItem = [[ShoppingItem alloc]
                  initWithName:@"Mat"
                  price:[[NSDecimalNumber alloc] initWithDouble:12.99]
                  image:@"mat"
                  aisleNumber:33];
  [shoppingList addNewItem:shoppingItem AtAisleIndex:3];
  shoppingItem = [[ShoppingItem alloc]
                  initWithName:@"Dish Set"
                  price:[[NSDecimalNumber alloc] initWithDouble:12.99]
                  image:@"dish-set"
                  aisleNumber:43];
  [shoppingList addNewItem:shoppingItem AtAisleIndex:2];
  
  shoppingItem = [[ShoppingItem alloc]
                  initWithName:@"Faucet"
                  price:[[NSDecimalNumber alloc] initWithDouble:54.49]
                  image:@"faucet"
                  aisleNumber:50];
  [shoppingList addNewItem:shoppingItem AtAisleIndex:0];
  shoppingItem = [[ShoppingItem alloc]
                  initWithName:@"Mat"
                  price:[[NSDecimalNumber alloc] initWithDouble:12.99]
                  image:@"mat"
                  aisleNumber:50];
  [shoppingList addNewItem:shoppingItem AtAisleIndex:0];
  shoppingItem = [[ShoppingItem alloc]
                  initWithName:@"Dish Set"
                  price:[[NSDecimalNumber alloc] initWithDouble:12.99]
                  image:@"dish-set"
                  aisleNumber:50];
  [shoppingList addNewItem:shoppingItem AtAisleIndex:0];
  
  shoppingItem = [[ShoppingItem alloc]
                  initWithName:@"Faucet"
                  price:[[NSDecimalNumber alloc] initWithDouble:54.49]
                  image:@"faucet"
                  aisleNumber:43];
  [shoppingList addNewItem:shoppingItem AtAisleIndex:2];
  shoppingItem = [[ShoppingItem alloc]
                  initWithName:@"Mat"
                  price:[[NSDecimalNumber alloc] initWithDouble:12.99]
                  image:@"mat"
                  aisleNumber:33];
  [shoppingList addNewItem:shoppingItem AtAisleIndex:3];
  shoppingItem = [[ShoppingItem alloc]
                  initWithName:@"Dish Set"
                  price:[[NSDecimalNumber alloc] initWithDouble:12.99]
                  image:@"dish-set"
                  aisleNumber:33];
  [shoppingList addNewItem:shoppingItem AtAisleIndex:3];
  
  shoppingItem = [[ShoppingItem alloc]
                  initWithName:@"Faucet"
                  price:[[NSDecimalNumber alloc] initWithDouble:54.49]
                  image:@"faucet"
                  aisleNumber:33];
  [shoppingList addNewItem:shoppingItem AtAisleIndex:3];
  shoppingItem = [[ShoppingItem alloc]
                  initWithName:@"Mat"
                  price:[[NSDecimalNumber alloc] initWithDouble:12.99]
                  image:@"mat"
                  aisleNumber:43];
  [shoppingList addNewItem:shoppingItem AtAisleIndex:2];
  shoppingItem = [[ShoppingItem alloc]
                  initWithName:@"Dish Set"
                  price:[[NSDecimalNumber alloc] initWithDouble:12.99]
                  image:@"dish-set"
                  aisleNumber:101];
  [shoppingList addNewItem:shoppingItem AtAisleIndex:1];
  
  shoppingItem = [[ShoppingItem alloc]
                  initWithName:@"Faucet"
                  price:[[NSDecimalNumber alloc] initWithDouble:54.49]
                  image:@"faucet"];
  [shoppingList addNewItem:shoppingItem AtAisleIndex:4];
  shoppingItem = [[ShoppingItem alloc]
                  initWithName:@"Mat"
                  price:[[NSDecimalNumber alloc] initWithDouble:12.99]
                  image:@"mat"
                  aisleNumber:101];
  [shoppingList addNewItem:shoppingItem AtAisleIndex:1];
  shoppingItem = [[ShoppingItem alloc]
                  initWithName:@"Dish Set"
                  price:[[NSDecimalNumber alloc] initWithDouble:12.99]
                  image:@"dish-set"
                  aisleNumber:33];
  [shoppingList addNewItem:shoppingItem AtAisleIndex:3];
  
  shoppingItem = [[ShoppingItem alloc]
                  initWithName:@"Faucet"
                  price:[[NSDecimalNumber alloc] initWithDouble:54.49]
                  image:@"faucet"
                  aisleNumber:43];
  [shoppingList addNewItem:shoppingItem AtAisleIndex:2];
  shoppingItem = [[ShoppingItem alloc]
                  initWithName:@"Mat"
                  price:[[NSDecimalNumber alloc] initWithDouble:12.99]
                  image:@"mat"
                  aisleNumber:50];
  [shoppingList addNewItem:shoppingItem AtAisleIndex:0];
  shoppingItem = [[ShoppingItem alloc]
                  initWithName:@"Dish Set"
                  price:[[NSDecimalNumber alloc] initWithDouble:12.99]
                  image:@"dish-set"
                  aisleNumber:50];
  [shoppingList addNewItem:shoppingItem AtAisleIndex:0];
  shoppingItem = [[ShoppingItem alloc]
                  initWithName:@"Faucet"
                  price:[[NSDecimalNumber alloc] initWithDouble:54.49]
                  image:@"faucet"
                  aisleNumber:33];
  [shoppingList addNewItem:shoppingItem AtAisleIndex:3];
  shoppingItem = [[ShoppingItem alloc]
                  initWithName:@"Mat"
                  price:[[NSDecimalNumber alloc] initWithDouble:12.99]
                  image:@"mat"
                  aisleNumber:43];
  [shoppingList addNewItem:shoppingItem AtAisleIndex:2];
  shoppingItem = [[ShoppingItem alloc]
                  initWithName:@"Dish Set"
                  price:[[NSDecimalNumber alloc] initWithDouble:12.99]
                  image:@"dish-set"
                  aisleNumber:43];
  [shoppingList addNewItem:shoppingItem AtAisleIndex:2];
  shoppingItem = [[ShoppingItem alloc]
                  initWithName:@"Faucet"
                  price:[[NSDecimalNumber alloc] initWithDouble:54.49]
                  image:@"faucet"
                  aisleNumber:43];
  [shoppingList addNewItem:shoppingItem AtAisleIndex:2];
  shoppingItem = [[ShoppingItem alloc]
                  initWithName:@"Mat"
                  price:[[NSDecimalNumber alloc] initWithDouble:12.99]
                  image:@"mat"
                  aisleNumber:33];
  [shoppingList addNewItem:shoppingItem AtAisleIndex:3];
  shoppingItem = [[ShoppingItem alloc]
                  initWithName:@"Dish Set"
                  price:[[NSDecimalNumber alloc] initWithDouble:12.99]
                  image:@"dish-set"
                  aisleNumber:101];
  [shoppingList addNewItem:shoppingItem AtAisleIndex:1];
  
  shoppingList = [[ShoppingList alloc] initWithTitle:@"Living"];
  [allLists addObject:shoppingList];
  
  shoppingList = [[ShoppingList alloc] initWithTitle:@"WishList"];
  [allLists addObject:shoppingList];
  
  shoppingList = [[ShoppingList alloc] initWithTitle:@"Gifts"];
  [allLists addObject:shoppingList];
  
  shoppingList = [[ShoppingList alloc] initWithTitle:@"Living"];
  [allLists addObject:shoppingList];
  
  shoppingList = [[ShoppingList alloc] initWithTitle:@"WishList"];
  [allLists addObject:shoppingList];
  
  shoppingList = [[ShoppingList alloc] initWithTitle:@"Gifts33"];
  [allLists addObject:shoppingList];
  return allLists;
}

@end
