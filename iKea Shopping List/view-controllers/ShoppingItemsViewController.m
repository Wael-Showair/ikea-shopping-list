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
#define OPEN_CAMERA_SEGUE_ID         @"openCamera"
#define ITEM_ADDITION_TEXT           @" Add new item to the list by pointing the camera to the tag of the item"

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
  
  /* Make sure that the total price is visible (during two-sided door animation)if the list has any items */
  if(0 < self.shoppingList.numberOfAisles){
    [self updatePinnedLabelAndGlobalHeader];
  }
  
  self.pinnedLabel.superview.layer.affineTransform = CGAffineTransformMakeTranslation(0, -64);
  self.pinnedLabel.superview.hidden = YES;
  
  self.itemsTableView.transform = CGAffineTransformMakeTranslation(0, -64);
}

-(void)viewDidAppear:(BOOL)animated{
  
  if (0 == self.shoppingList.numberOfAisles) {
    [self updatePinnedLabelAndGlobalHeader];
  }
  
  NSIndexPath* selectedIndexPath = [self.itemsTableView indexPathForSelectedRow];
  [self.itemsTableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
  
  self.listOfItemsDataSource = nil;
  [super didReceiveMemoryWarning];
}

-(void) updatePinnedLabelAndGlobalHeader{
  /* Set global header of the table view with the total price of the list.*/
  if(0< self.shoppingList.numberOfAisles){
    NSString* totalPrice = [TOTAL_PRICE_PREFIX stringByAppendingString:self.shoppingList.totalPrice.stringValue];
    [self.itemsTableView updateGlobalHeaderWithTitle:totalPrice];
    self.pinnedLabel.text = totalPrice;
  }else{
    
    [self.itemsTableView updateGlobalHeaderWithTitle:ITEM_ADDITION_TEXT];
    self.pinnedLabel.text = @"";
  }
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
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
  
  UITableViewHeaderFooterView* sectionHeaderView = (UITableViewHeaderFooterView*) view;
  sectionHeaderView.tintColor = [UIColor colorWithRed:0.0 green:0.333 blue:0.659 alpha:1.0];
  [sectionHeaderView.textLabel setTextColor:[UIColor whiteColor]];
  
}

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
  
  [self updatePinnedLabelAndGlobalHeader];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  
  if([segue.identifier isEqualToString:SHOW_ITEM_DETAILS_SEGUE_ID]){
    
    DetailedItemViewController* destViewController = [segue destinationViewController];
    NSIndexPath* selectedIndexPath = [self.itemsTableView indexPathForSelectedRow];
    ShoppingItem* shoppingItem = [self.listOfItemsDataSource itemAtIndexPath:selectedIndexPath];
    destViewController.shoppingItem = shoppingItem;
    destViewController.isNewItem = NO;
    
  }else if ([segue.identifier isEqualToString:OPEN_CAMERA_SEGUE_ID]){
    NSLog(@"going to start camera view right now");
    
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
