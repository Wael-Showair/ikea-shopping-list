//
//  ListOfListsTableViewController.m
//  iKea Shopping List
//
//  Created by Wael Showair on 2015-11-01.
//  Copyright © 2015 show0017@algonquinlive.com. All rights reserved.
//

#import "NavigationControllerDelegate.h"
#import "ListOfListsTableViewController.h"
#import "ArrayDataSource.h"
#import "ListOfItemsTableViewController.h"

#import "ShoppingItem.h"

@interface ListOfListsTableViewController ()

#define LISTS_CELL_IDENTIFIER       @"cellForListOfLists"
#define SHOW_LIST_ITEMS_SEGUE_ID    @"showListOfItems"

@property NavigationControllerDelegate* navBarDelegate;
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
    
    /* Define block for each cell in the table view. Simply assign the text to the given item name. */
    TableViewCellConfigureBlock cellConfigurationBlock = ^(UITableViewCell* cell, ShoppingList* shoppingList){
        cell.textLabel.text = shoppingList.title;
        
    };

    /* Set data source delegate of the table view under control. */
    self.listOfListsDataSource = [[ArrayDataSource alloc] initWithItems:allLists
                                                         cellIdentifier:LISTS_CELL_IDENTIFIER
                                                     configureCellBlock:cellConfigurationBlock];
    self.tableView.dataSource = self.listOfListsDataSource;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if([segue.identifier isEqualToString:SHOW_LIST_ITEMS_SEGUE_ID]){
        ListOfItemsTableViewController* listOfItemsViewController = [segue destinationViewController];
        NSIndexPath* selectedIndexPath = [self.tableView indexPathForSelectedRow];
        ShoppingList* selectedShoppingList = [self.listOfListsDataSource itemAtIndexPath:selectedIndexPath];
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
    shoppingItem = [[ShoppingItem alloc] initWithName:@"Spoons" price:[[NSDecimalNumber alloc] initWithDouble:12.3]];
    [shoppingList addNewItem:shoppingItem];
    shoppingItem = [[ShoppingItem alloc] initWithName:@"Forks" price:[[NSDecimalNumber alloc] initWithDouble:14.5]];
    [shoppingList addNewItem:shoppingItem];
    
    /* Create Bathrrom Shopping list and add it to all data mutable array. */
    shoppingList = [[ShoppingList alloc] initWithTitle:@"Bathroom"];
    [allLists addObject:shoppingList];
    /* Add tissues, soap & shampoo to the bathroom shopping list. */
    shoppingItem = [[ShoppingItem alloc] initWithName:@"Tissues" price:[[NSDecimalNumber alloc] initWithDouble:12.3]];
    [shoppingList addNewItem:shoppingItem];
    shoppingItem = [[ShoppingItem alloc] initWithName:@"Soap" price:[[NSDecimalNumber alloc] initWithDouble:34.5]];
    [shoppingList addNewItem:shoppingItem];
    shoppingItem = [[ShoppingItem alloc] initWithName:@"Shampoo" price:[[NSDecimalNumber alloc] initWithDouble:156.5]];
    [shoppingList addNewItem:shoppingItem];
    
    return allLists;
}

@end
