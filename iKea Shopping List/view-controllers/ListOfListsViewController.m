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
#import "ShoppingItem.h"
#import "OuterScrollView.h"
#import "ShoppingListsTableView.h"
#import "TextInputTableViewCell.h"
#import "UIView+Overlay.h"

/*!
 *  @define SHOW_LIST_ITEMS_SEGUE_ID
 *  @abstract Segue identifier that is used to show list of items related
 *  to specific list name.
 */
#define SHOW_LIST_ITEMS_SEGUE_ID    @"showListOfItems"

#define EMPTY_STRING                @""

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
  
  /* Add keyboard listener to display the overlay properly*/
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardDidShow:)
                                               name:UIKeyboardDidShowNotification object:nil];
  
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

- (void)stickyViewDidDisappear: (UIView*) stickyView{
  UIBarButtonItem* addBtn = [[UIBarButtonItem alloc]
                             initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                             target:self
                             action:@selector(onTapAdd:)];
  
  self.navigationItem.leftBarButtonItem = addBtn;
}

-(void) stickyViewWillAppear: (UIView*) stickyView{
  self.navigationItem.leftBarButtonItem = nil;
}

#pragma text field - delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
  /* Set text field that might be obscured by the keyboard. */
  self.outerScrollView.textFieldObscuredByKeyboard = textField;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{

  /* Note that you have to dismiss the keyboard before updating the tableview otherwise you
   * will get an log error message:
   * "no index path for table cell being reused"
   * It makes since because when after you update the tableview, the textInput cell will be replaced
   * by a basic cell. So If I tried to dismiss the keyboard, the whole cell is removed.
   * Thus UIKit complains about that there is no index path for the textInput cell type. */
  
  /* Dismiss keyboard. */
  [textField resignFirstResponder];
  
  NSIndexPath* indexPath = [NSIndexPath indexPathForRow:LAST_INDEX inSection:FIRST_SECTION_INDEX];
  
  /* rename the list to the new name entered by the user. */
  [self.listOfListsDataSource renameListToTitle:textField.text atIndexPath:indexPath];
  
  /* Reload the row whose text label has been changed. */
  [self.listsTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
  
  return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
  
  /* reset any text field that could be obscured by keyboard since keyboard is already disappeared*/
  self.outerScrollView.textFieldObscuredByKeyboard = nil;
  
  /* Remove overvaly*/
  [self.view removeOverlay];
}

#pragma keyboard - notifications
-(void) keyboardDidShow:(NSNotification*) notification{
  /* Display the overlay after showing the keyboard.*/
  [self.view addOverlayExceptAround:self.outerScrollView.textFieldObscuredByKeyboard];

  /* Note that gesture recoginzer should be added only to one view. You can't add the same
   * gesture recognizer to multiple views. */
  UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapOverlay)];
  [self.view.upperOverlayView addGestureRecognizer:tapGesture];
  
  tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapOverlay)];
  [self.view.lowerOverlayView addGestureRecognizer:tapGesture];
}

-(IBAction)onTapOverlay{
  /* Dismiss the keyboard. */
  [self.outerScrollView.textFieldObscuredByKeyboard resignFirstResponder];
  
  /* Delete the newly added list from the lists. */
  NSIndexPath* indexPath = [NSIndexPath indexPathForRow:LAST_INDEX inSection:FIRST_SECTION_INDEX];
  [self.listOfListsDataSource removeListAtIndexPath:indexPath];
  [self.listsTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
  
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
  
  /* Note that the overlay will be added on showing the keyboard. On tap the overlay, dismiss the 
   * keyboard & remove the newest entry from the table view. */
  /* If the user tap Go button, change the cell contents from text field to basic label.*/
  
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
    
  }
}

#pragma data loading
/* Temporary method to populate table with dummy data. */
- (NSMutableArray*) populateTableWithData{

  //shoppingItem;
  ShoppingList* shoppingList;
  
  NSMutableArray* allLists = [[NSMutableArray alloc] init];
  
  NSDictionary *pListDictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"]];
  

  /* Loop through the property list retrieved dictionary. */
  for (NSString* key in pListDictionary) {
    
    /* Add new shopping List */
    shoppingList = [[ShoppingList alloc] initWithTitle:key];
    [allLists addObject:shoppingList];

    /* Get an array for list of items. */
    NSArray* array = [pListDictionary objectForKey:key];
    
    /* Add all shopping items within the given array. */
    [array enumerateObjectsUsingBlock:^(id element, NSUInteger index, BOOL* stop){

      /* Each element in the array is a dictionary, parse it to get the needed values. */
      NSString* name = [element objectForKey:@"name"];
      
      NSNumber* price = [element objectForKey:@"price"];
      NSDecimalNumber* itemPrice = [[NSDecimalNumber alloc] initWithDouble:price.doubleValue];
      
      NSString* fileName = [element objectForKey:@"image"];
      NSNumber* aisleNumber = [element objectForKey:@"aisle_num"];
      
      
      ShoppingItem*  shoppingItem = [[ShoppingItem alloc] initWithName:name
                                                                 price:itemPrice
                                                                 image:fileName
                                                           aisleNumber:aisleNumber.integerValue];
      /* Get index of specific aisle number. */
      [shoppingList addNewItem:shoppingItem];
      
      *stop = NO;
    }];
  }
  
  return allLists;
}

@end
