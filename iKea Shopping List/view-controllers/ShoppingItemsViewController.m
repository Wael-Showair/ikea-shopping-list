/*!
 *  @file ListOfItemsTableViewController.m
 *  implementation file that provides required operations for UI Tabel view
 *  controller for list of shopping items.
 *
 *  @author Wael Showair (showair.wael\@gmail.com)
 *  @version 0.0.1
 *  @copyright 2015. Wael Showair. All rights reserved.
 */
#import "ShoppingItemsViewController.h"
#import "DetailedItemViewController.h"
#import "ItemsDataSource.h"
#import "ShoppingItem.h"
#import "ShoppingItemsTableView.h"

#define FIRST_INDEX_INSECTION        0
#define SHOW_ITEM_DETAILS_SEGUE_ID   @"showItemDetails"
#define ADD_NEW_ITEM_SEGUE_ID        @"addNewItem"

@interface ShoppingItemsViewController ()

/*!
 *  @property listOfItemsDataSource
 *  @abstract data source delegate for table view that display list of items.
 *  @discussion separate the model from the view and controller. This is done
 *  by creating separate class for data source delegate of the UITabelView.
 */
@property (strong,nonatomic) ItemsDataSource* listOfItemsDataSource;
@property (weak, nonatomic) IBOutlet UILabel *pinnedLabel;
@property (weak, nonatomic) IBOutlet  ShoppingItemsTableView* itemsTableView;
@property (weak,nonatomic) IBOutlet UIView* cameraOverlay;
@property (weak,nonatomic) IBOutlet UIButton* manualInputBtn;
@end

@implementation ShoppingItemsViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;
  
  /* Set the title of the table view scene.*/
  self.title = self.shoppingList.title;
  
  /* Set data source delegate of the table view. */
  self.listOfItemsDataSource = [[ItemsDataSource alloc] initWithItems: self.shoppingList];
  self.itemsTableView.dataSource  = self.listOfItemsDataSource;
  self.itemsTableView.scrollingDelegate = self;
  
  /* Set global header of the table view with the total price of the list.*/
  [self.itemsTableView updateGlobalHeaderWithPrice:self.shoppingList.totalPrice.stringValue];
  self.pinnedLabel.text = [TOTAL_PRICE_PREFIX stringByAppendingString:self.shoppingList.totalPrice.stringValue];
  

  self.pinnedLabel.superview.layer.affineTransform = CGAffineTransformMakeTranslation(0, -64);
  self.pinnedLabel.superview.hidden = YES;
  
  self.itemsTableView.transform = CGAffineTransformMakeTranslation(0, -64);
}

-(void)viewDidAppear:(BOOL)animated{
  NSIndexPath* selectedIndexPath = [self.itemsTableView indexPathForSelectedRow];
  [self.itemsTableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
  
  self.listOfItemsDataSource = nil;
  [super didReceiveMemoryWarning];
}

#pragma scroll view - delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
  if(scrollView == self.itemsTableView){
    [self.itemsTableView scrollViewDidScroll];
  }
}

#pragma scroll notification - delegate
- (void)scrollViewDidCrossOverThreshold:(UIScrollView *)scrollView{
    self.pinnedLabel.superview.hidden = NO;
  [UIView animateWithDuration:0.3 animations:^{
    self.itemsTableView.layer.affineTransform = CGAffineTransformMakeTranslation(0, 0);
    self.pinnedLabel.superview.layer.affineTransform = CGAffineTransformMakeTranslation( 0, 0);
  }];
    self.itemsTableView.contentSize = CGSizeMake(self.itemsTableView.contentSize.width, self.itemsTableView.contentSize.height+66.0);
}

-(void)scrollViewDidReturnBelowThreshold:(UIScrollView *)scrollView{
  

  [UIView animateWithDuration:0.3 animations:^{
    self.pinnedLabel.superview.layer.affineTransform = CGAffineTransformMakeTranslation(0, -64.0);
    self.itemsTableView.transform = CGAffineTransformMakeTranslation(0, -64);
  }completion:^(BOOL finished){
      self.pinnedLabel.superview.hidden = YES;
  }];
  
      self.itemsTableView.contentSize = CGSizeMake(self.itemsTableView.contentSize.width, self.itemsTableView.contentSize.height-66.0);
}

#pragma table view - delegate

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath{
  
  
  ShoppingItem* shoppingItem = [self.listOfItemsDataSource itemAtIndexPath:indexPath];
  
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
  NSInteger prevNumOfSections =
      [self.listOfItemsDataSource numberOfSectionsInTableView:self.itemsTableView];
  
  /* add new item in the first index of the section */
  NSInteger virtualSectionIndex = [self.listOfItemsDataSource insertShoppingItem:newItem
                                                              withAscendingOrder:YES];
  
  NSInteger newNumOfSections =
    [self.listOfItemsDataSource numberOfSectionsInTableView:self.itemsTableView];
  
  NSIndexPath* indexPath;
  /* in case new section is added, reload data is needed. */
  if(newNumOfSections > prevNumOfSections){
    
    NSIndexSet* newSection = [NSIndexSet indexSetWithIndex:virtualSectionIndex];
    
    /* If a section already exists at the specified index location, it is
     * moved down one index location. */
    [self.itemsTableView insertSections:newSection
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
    [self.itemsTableView insertRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
    
  }
  
  /* Scroll & Select to the new added row so that the user becomes aware of
   * the successfull operation. */
  [self.itemsTableView selectRowAtIndexPath:indexPath
                              animated:YES
                        scrollPosition:UITableViewScrollPositionTop];
  
  [self.itemsTableView updateGlobalHeaderWithPrice:self.shoppingList.totalPrice.stringValue];
  self.pinnedLabel.text = [TOTAL_PRICE_PREFIX stringByAppendingString:self.shoppingList.totalPrice.stringValue];
}

#pragma camera

- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                       UINavigationControllerDelegate>) delegate {
  
  if (([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera] == NO)
      || (delegate == nil)
      || (controller == nil))
    return NO;
  
  
  UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
  cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
  
  // Displays a control that allows the user to choose picture or
  // movie capture, if both are available:
  cameraUI.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
  
  // Hides the controls for moving & scaling pictures, or for
  // trimming movies. To instead show the controls, use YES.
  cameraUI.allowsEditing = NO;
  
  //cameraUI.delegate = delegate;
  
  /*
   Load the overlay view from the OverlayView nib file. Self is the File's Owner for the nib file, so the overlayView outlet is set to the main view in the nib. Pass that view to the image picker controller to use as its overlay view, and set self's reference to the view to nil.
   */
  [[NSBundle mainBundle] loadNibNamed:@"camera-overlay" owner:self options:nil];
  self.cameraOverlay.frame = cameraUI.cameraOverlayView.frame;
  cameraUI.cameraOverlayView = self.cameraOverlay;
  
  cameraUI.cameraOverlayView.alpha = 0.8;
  self.cameraOverlay = nil;
  
  [controller presentViewController:cameraUI animated:YES completion:nil];
  return YES;
}
- (IBAction)onTapAddNewItem:(id)sender {
  [self startCameraControllerFromViewController: self usingDelegate: self];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  
  if([segue.identifier isEqualToString:SHOW_ITEM_DETAILS_SEGUE_ID]){
    
    DetailedItemViewController* destViewController = [segue destinationViewController];
    NSIndexPath* selectedIndexPath = [self.itemsTableView indexPathForSelectedRow];
    ShoppingItem* shoppingItem = [self.listOfItemsDataSource itemAtIndexPath:selectedIndexPath];
    destViewController.shoppingItem = shoppingItem;
    destViewController.isNewItem = NO;
    
  }else if ([segue.identifier isEqualToString:ADD_NEW_ITEM_SEGUE_ID]){
    
//    DetailedItemViewController* destViewController = [segue destinationViewController];
//    
//    ShoppingItem* shoppingItem =
//      [[ShoppingItem alloc] initWithName:@"New Item"
//                                   price:[NSDecimalNumber decimalNumberWithString:@"0.0"]];
//    
//    destViewController.shoppingItem = shoppingItem;
//    destViewController.isNewItem = YES;
//    destViewController.shoppningItemDelegate = self;
    
  }
}


@end
