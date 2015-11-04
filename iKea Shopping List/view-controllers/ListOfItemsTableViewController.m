//
//  ListOfItemsTableViewController.m
//  iKea Shopping List
//
//  Created by Wael Showair on 2015-11-02.
//  Copyright © 2015 show0017@algonquinlive.com. All rights reserved.
//

#import "ListOfItemsTableViewController.h"
#import "ArrayDataSource.h"
#import "ShoppingItem.h"

@interface ListOfItemsTableViewController ()
#define LIST_OF_ITEMS_CELL_IDENTIFIER   @"cellForListOfItems"
@property (nonatomic, strong) ArrayDataSource* listOfItemsDataSource;
@end

@implementation ListOfItemsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.title = self.shoppingList.title;
    NSMutableArray* allItems = [self.shoppingList getItems];
    TableViewCellConfigureBlock cellConfigurationBlock = ^(UITableViewCell* cell, ShoppingItem* shoppingItem){
        cell.textLabel.text = shoppingItem.name;
        cell.detailTextLabel.text = shoppingItem.price.stringValue;
    };
    
    self.listOfItemsDataSource = [[ArrayDataSource alloc]
                                  initWithItems: allItems
                                  cellIdentifier: LIST_OF_ITEMS_CELL_IDENTIFIER
                                  configureCellBlock:cellConfigurationBlock];
    self.tableView.dataSource = self.listOfItemsDataSource;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
