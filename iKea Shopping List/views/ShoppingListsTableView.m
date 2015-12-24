//
//  ShoppingListsTableView.m
//  iKea Shopping List
//
//  Created by Wael Showair on 2015-12-21.
//  Copyright © 2015 showair.wael@gmail.com. All rights reserved.
//

#import "ShoppingListsTableView.h"
@interface ShoppingListsTableView()
@end

@implementation ShoppingListsTableView

-(void)awakeFromNib{
  self.shouldNotifyDelegate = YES;
  /* Remove empty cells from the table view. */
  self.tableFooterView = [UIView new];
}

@end
