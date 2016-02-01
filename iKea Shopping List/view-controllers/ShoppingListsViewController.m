/*!
 *  @file ListOflistsCollectionViewController.m
 *  implementation file that provides required operations for UI Tabel view
 *  controller for list of shopping items lists.
 *
 *  @author Wael Showair (showair.wael\@gmail.com)
 *  @version 0.0.1
 *  @copyright 2015. Wael Showair. All rights reserved.
 */

#import "NavigationControllerDelegate.h"
#import "ShoppingListsViewController.h"
#import "ListsDataSource.h"
#import "ShoppingItemsViewController.h"
#import "ShoppingItem.h"
#import "OuterScrollView.h"
#import "ShoppingListsCollectionView.h"
#import "TextInputCell.h"
#import "UIView+Overlay.h"
#import "ShoppingListCell.h"
#import "UIImage+Overlay.h"
#import "UIView+ShakeAnimation.h"
#import "CustomWindowOverlay.h"

/*!
 *  @define SHOW_LIST_ITEMS_SEGUE_ID
 *  @abstract Segue identifier that is used to show list of items related
 *  to specific list name.
 */
#define SHOW_LIST_ITEMS_SEGUE_ID    @"showListOfItems"

#define EMPTY_STRING                @""

#define FIRST_INDEX                 0

#define FIRST_SECTION_INDEX         0

#define NUM_OF_LISTS                [self.listsCollectionView numberOfItemsInSection:0]

#define LAST_INDEX                  NUM_OF_LISTS - 1

@interface ShoppingListsViewController ()

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
@property (weak, nonatomic) IBOutlet ShoppingListsCollectionView *listsCollectionView;
@property (weak, nonatomic) UIView* customOverlay;
@property (strong, nonatomic) NSDictionary* attributesOfTitle;
@end

@implementation ShoppingListsViewController

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
  self.listsCollectionView.dataSource = self.listOfListsDataSource;
  self.listsCollectionView.delegate = self;

  
  /* Set the view controller as a delegate for Sticky Header Protocol. */
  self.outerScrollView.stickyDelegate = self;
  
  /* Set the attributes of the Lists title:
   * 1- Font is predefined with Headline attributes.
   * 2- Fill Color is white.
   * 3- Stroke color is yellow.
   * 4- Stroke width is negative to set both the fill & the stroke properly.https://goo.gl/ege0lH
   */
  self.attributesOfTitle =
  @{            NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline],
     NSForegroundColorAttributeName: [UIColor whiteColor],
         NSStrokeColorAttributeName: [UIColor yellowColor],
         NSStrokeWidthAttributeName: [NSNumber numberWithFloat:-1.5]
    };
}

-(void)viewDidDisappear:(BOOL)animated{
  NSIndexPath* indexPath = [[self.listsCollectionView indexPathsForSelectedItems] objectAtIndex:0];
  [self.listsCollectionView deselectItemAtIndexPath:indexPath animated:NO];
}

- (void)didReceiveMemoryWarning {
  
  // Dispose of any resources that can be recreated.
  self.navBarDelegate = nil;
  self.listOfListsDataSource = nil;
  
  [super didReceiveMemoryWarning];
}

#pragma scroll view - delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
  CGFloat scrollOffsetDifference = 0.0;
  if(scrollView == self.listsCollectionView){
    [(ShoppingListsCollectionView*)scrollView scrollViewDidScroll];
    scrollOffsetDifference = scrollView.contentOffset.y - self.listsCollectionView.prevContentOffsetY;
  }
  else if(scrollView == self.outerScrollView){
    scrollOffsetDifference = scrollView.contentOffset.y -  self.outerScrollView.prevContentOffsetY;
  }

  /* Update the overlay view with the same amount of vertical scrolling offset so that the
   * transparent rectangle always stays on top of the text input cell. Otherwise, it might
   * obscured by the keyboard. */
  if(nil != self.customOverlay){
    CGAffineTransform transform = self.customOverlay.layer.affineTransform;
    self.customOverlay.layer.affineTransform =
        CGAffineTransformTranslate(transform, 0, -scrollOffsetDifference);
  }
  
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
  
  NSIndexPath* indexPath = [NSIndexPath indexPathForItem:LAST_INDEX inSection:FIRST_SECTION_INDEX];
  
  /* rename the list to the new name entered by the user. */
  [self.listOfListsDataSource renameListToTitle:textField.text atIndexPath:indexPath];
  
  /* Reload the row whose text label has been changed. */

  [self.listsCollectionView reloadItemsAtIndexPaths:@[indexPath]];
  
  [self.listsCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
  
  if(self.listsCollectionView.contentOffset.y > 30.0){
    [self.listsCollectionView.scrollingDelegate scrollViewDidCrossOverThreshold:self.listsCollectionView];
  }
  
  return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
  
  /* reset any text field that could be obscured by keyboard since keyboard is already disappeared*/
  self.outerScrollView.textFieldObscuredByKeyboard = nil;
  
  /* Remove overvaly*/
  [self.customOverlay removeFromSuperview];
  self.customOverlay = nil;
}

#pragma collection view - layout flow delegate

/* Determine size of each cell in the collection. */
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
  CGFloat width = [UIScreen mainScreen].bounds.size.width/2 - 5;
  
  CGFloat height = width;

  return CGSizeMake(width, height);
}

/* Determine the inset of the contents for each cell. */
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
  return UIEdgeInsetsMake(0, 5, 0, 5);
}

#pragma collection view - delegate

-(void)collectionView:(UICollectionView *)collectionView
      willDisplayCell:(UICollectionViewCell *)cell
   forItemAtIndexPath:(NSIndexPath *)indexPath{
  
  if(indexPath.row == self.listOfListsDataSource.rowIndexForTextInputCell){
    
    ((TextInputCell*)cell).inputText.text = EMPTY_STRING;
    
    /* Set the current view controller as a delegate for the textfield in the cell. */
    ((TextInputCell*)cell).inputText.delegate = self;
    
    /* Add an overlay to the window (to be on top of all views). Make sure to leave the area on top
     * of text input cell to be always transparent.*/
    CustomWindowOverlay* overlay = [[CustomWindowOverlay alloc] initWithFrame:self.view.window.frame
                                                                   aroundView:cell];
    /* Add the overlay view to the main window. */
    [self.view.window addSubview:overlay];
    self.customOverlay = overlay;
    
    /* Note that gesture recoginzer should be added only to one view. You can't add the same
     * gesture recognizer to multiple views. */
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapOverlay)];
    [overlay addGestureRecognizer:tapGesture];
    
    /* populate the keyboard automatically. Note that when the keyboard is shown, the outer scroll 
     * view might be change its scrolling offset (if the input text is obscured by keyboard), hence
     * the overlay view should be shifted up with the same amount of verticall scrolling offset.*/
    [((TextInputCell*)cell).inputText becomeFirstResponder];
    
    /* Inform the data source that it should not use text input anymore. */
    self.listOfListsDataSource.rowIndexForTextInputCell = INVALID_ROW_INDEX;
    
    /* Improve the application accessibility as well as the UI Testing*/
    cell.accessibilityLabel = CELL_TEXT_INPUT_ACCESSIBILITY_LABEL;
  }else{
    
    ShoppingList* shoppingList = [self.listOfListsDataSource itemAtIndexPath:indexPath];
    
    UIImage* image = [UIImage imageNamed:[shoppingList.title lowercaseString]];
    /*image = [image imageWithColorOverlay:[UIColor colorWithRed:0.0 green:0.333 blue:0.659 alpha:0.7]];*/
    ((ShoppingListCell*)cell).backgroundImage.image = image;
    
    
    NSAttributedString* attributedTitle =
      [[NSAttributedString alloc] initWithString:shoppingList.title attributes:self.attributesOfTitle];
    ((ShoppingListCell*)cell).textLabel.attributedText = attributedTitle;
    
    /* Improve the application accessibility as well as the UI Testing*/
    cell.accessibilityLabel = shoppingList.title;
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

#pragma actions

- (IBAction)onTapAdd:(id)sender {
  
  /* add the new list object to the data source. */
  ShoppingList* newList = [[ShoppingList alloc] initWithTitle:@""];
  [self.listOfListsDataSource insertObject:newList AtIndex:LAST_INDEX+1];
  
  /* add the new list row to table view. */
  NSIndexPath* indexPath = [NSIndexPath indexPathForRow:LAST_INDEX+1 inSection:FIRST_SECTION_INDEX];

  [self.listsCollectionView insertItemsAtIndexPaths:@[indexPath]];
  self.listsCollectionView.shouldNotifyDelegate = NO;
  
  [self.listsCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
  
  /* Note that the overlay will be added on showing the keyboard. On tap the overlay, dismiss the 
   * keyboard & remove the newest entry from the table view. */
  /* If the user tap Go button, change the cell contents from text field to basic label.*/
  
}
- (IBAction)onTapEdit:(UIBarButtonItem*)barButton {
  if([barButton.title isEqualToString:@"Edit"]){
    self.listsCollectionView.editingMode = YES;
    barButton.title = @"Done";
    CGFloat delay = 0.0;
    for (ShoppingListCell* cell in self.listsCollectionView.visibleCells) {
      /* Display Circular Delete button */
      cell.deleteBtn.hidden = NO;

      /* Shake the cell of collection view */
      [cell startShakeAnimationWithDelay:delay];
      delay+= 0.05;
    }
    
    
  }else{
    barButton.title = @"Edit";
    for (ShoppingListCell* cell in self.listsCollectionView.visibleCells) {
      cell.deleteBtn.hidden = YES;
      [cell stoptShakeAnimation];
    }
    self.listsCollectionView.editingMode = NO;
  }
}
- (IBAction)onDeleteList:(UIButton*)button {
  /* Get the index path of the cell whose button has been tapped. Make sure to convert
   * the center point of the delete button to the collection view coordinate space first.*/
  CGPoint point = [button convertPoint:button.center toView:self.listsCollectionView];
  NSIndexPath* indexPath = [self.listsCollectionView indexPathForItemAtPoint:point];

  [self.listOfListsDataSource removeListAtIndexPath:indexPath];
  /* When cell is deleted, the ongoing animation of the cells whose index paths are coming next,
   * stop their animation. I have to restart their animation. In this case, I am just restarting
   * all of them. */
  [self.listsCollectionView performBatchUpdates:^{
    [self.listsCollectionView deleteItemsAtIndexPaths:@[indexPath]];
  }completion:^(BOOL finished){
    for (ShoppingListCell* cell in self.listsCollectionView.visibleCells) {
      [cell startShakeAnimationWithDelay:0.0];
    }
  }];


}


-(IBAction)onTapOverlay{
  /* Dismiss the keyboard. */
  [self.outerScrollView.textFieldObscuredByKeyboard resignFirstResponder];
  
  /* Delete the newly added list from the lists. */
  NSIndexPath* indexPath = [NSIndexPath indexPathForRow:LAST_INDEX inSection:FIRST_SECTION_INDEX];
  [self.listOfListsDataSource removeListAtIndexPath:indexPath];
  [self.listsCollectionView deleteItemsAtIndexPaths:@[indexPath] ];
  
}

#pragma mark - Navigation

/* In a storyboard-based application, you will often want to do a little
 preparation before navigation*/
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  
  if([segue.identifier isEqualToString:SHOW_LIST_ITEMS_SEGUE_ID]){
    
    ShoppingItemsViewController* listOfItemsViewController =
    [segue destinationViewController];
    
    NSIndexPath* selectedIndexPath = [[self.listsCollectionView indexPathsForSelectedItems] objectAtIndex:0];
    
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
