//
//  ShoppingListsTableView.m
//  iKea Shopping List
//
//  Created by Wael Showair on 2015-12-21.
//  Copyright © 2015 showair.wael@gmail.com. All rights reserved.
//

#import "ShoppingListsTableView.h"
#define SCROLLING_THRESHOLD 30.0

@implementation ShoppingListsTableView

-(void)awakeFromNib{
  self.shouldNotifyDelegate = YES;
  
  /* Remove empty cells from the table view. */
  self.tableFooterView = [UIView new];
}

#pragma scroll view - delegate

- (void)scrollViewDidScroll{
  if((self.contentOffset.y > SCROLLING_THRESHOLD) && (YES == self.shouldNotifyDelegate)){
    [self.scrollingDelegate scrollViewDidCrossOverThreshold:self];
    self.shouldNotifyDelegate = NO;
  }else if((self.contentOffset.y < SCROLLING_THRESHOLD) && (NO == self.shouldNotifyDelegate)){
    [self.scrollingDelegate scrollViewDidReturnBelowThreshold:self];
    self.shouldNotifyDelegate = YES;
  }
}

@end