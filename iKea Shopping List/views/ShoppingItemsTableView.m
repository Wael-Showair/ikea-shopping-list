//
//  ShoppingItemsTableView.m
//  iKea Shopping List
//
//  Created by Wael Showair on 2016-01-01.
//  Copyright © 2016 showair.wael@gmail.com. All rights reserved.
//

#import "ShoppingItemsTableView.h"


#define SCROLLING_THRESHOLD 65.0

@implementation ShoppingItemsTableView

-(void)awakeFromNib{

  self.shouldNotifyDelegate = YES;
  
  /* Remove empty cells from the table view. */
  self.tableFooterView = [UIView new];
  
  [self loadGlobalHeaderView];
}

#pragma scroll view - delegate

- (void)scrollViewDidScroll{

  if((self.contentOffset.y > SCROLLING_THRESHOLD) &&
     (YES == self.shouldNotifyDelegate) &&
     (self.contentSize.height > self.frame.size.height)){
    
    /* It is mandatory to set the this notification flag before calling the delegate because
     * the delegate object might take longer times for execution then it will be preempted
     * and this inner srollview would trigger this method again and the flag is not toggeled yet
     * hence the delegate method will be triggered again which is not required in this case. */
    self.shouldNotifyDelegate = NO;
    [self.scrollingDelegate scrollViewDidCrossOverThreshold:self];
  }else if((self.contentOffset.y < SCROLLING_THRESHOLD) &&(NO == self.shouldNotifyDelegate)){
    /* It is mandatory to set the this notification flag before calling the delegate because
     * the delegate object might take longer times for execution then it will be preempted
     * and this inner srollview would trigger this method again and the flag is not toggeled yet
     * hence the delegate method will be triggered again which is not required in this case. */
    self.shouldNotifyDelegate = YES;
    [self.scrollingDelegate scrollViewDidReturnBelowThreshold:self];
    
  }
}

#pragma global header
-(void) loadGlobalHeaderView {
    NSArray* topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"items-table-header-view"
                                                             owner:self
                                                           options:nil];

  self.tableHeaderView = [topLevelObjects objectAtIndex:0];

  /* Reset any text loaded from the NIB file as it will appear while opening the two-sided door 
   * animation.*/
  ((UILabel*)self.tableHeaderView).text = @"";

}

- (void) updateGlobalHeaderWithTitle: (NSString*) title{
  ((UILabel*)self.tableHeaderView).text = title;
}
@end
