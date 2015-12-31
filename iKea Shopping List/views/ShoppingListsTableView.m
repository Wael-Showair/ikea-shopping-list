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

    /* It is mandatory to set the this notification flag before calling the delegate because
     * the delegate object might take longer times for execution then it will be preempted
     * and this inner srollview would trigger this method again and the flag is not toggeled yet
     * hence the delegate method will be triggered again which results in transforming & scaling
     * the sticky view more than required. */
    self.shouldNotifyDelegate = NO;
    [self.scrollingDelegate scrollViewDidCrossOverThreshold:self];
  }else if((self.contentOffset.y < SCROLLING_THRESHOLD) &&(NO == self.shouldNotifyDelegate)){
    
    /* It is mandatory to set the this notification flag before calling the delegate because
     * the delegate object might take longer times for execution then it will be preempted
     * and this inner srollview would trigger this method again and the flag is not toggeled yet
     * hence the delegate method will be triggered again which results in decreasing the height
     * of the inner scroll view more than needed. */
    self.shouldNotifyDelegate = YES;
    [self.scrollingDelegate scrollViewDidReturnBelowThreshold:self];
  }
}

@end