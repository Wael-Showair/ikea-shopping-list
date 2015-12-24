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

#pragma scroll view - delegate
//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
//                     withVelocity:(CGPoint)velocity
//              targetContentOffset:(inout CGPoint *)targetContentOffset{
//  NSLog(@"*********************************** x:%f , y=%f", velocity.x, velocity.y);
//}
//

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
  
    if((scrollView.contentOffset.y > 30.0) && (YES == self.shouldNotifyDelegate)){
      [self.scrollingDelegate scrollViewDidCrossOverThreshold:scrollView];
      self.shouldNotifyDelegate = NO;
    }else if(scrollView.contentOffset.y < 30.0){
      [self.scrollingDelegate scrollViewDidReturnBelowThreshold:scrollView];
      self.shouldNotifyDelegate = YES;
    }
  
  //  NSLog(@"scrolling offset is %f", scrollView.contentOffset.y);
  //  //scrollView.bounces = (scrollView.contentOffset.y > 0);
  //
  //
  //  if((scrollView.contentOffset.y > 0) && (scrollView.contentOffset.y < 10) && (self.addNewListView.frame.size.height > 62)){
  //
  //    CGFloat height = self.addNewListView.bounds.size.height;
  //    CGFloat verticalScalingPercent = (height - 2*scrollView.contentOffset.y) / height;
  //
  //    CGAffineTransform currentTransform = self.addNewListView.layer.affineTransform;
  //
  //    CGAffineTransform newTransfrom = CGAffineTransformScale(currentTransform,1, verticalScalingPercent);
  //    newTransfrom = CGAffineTransformTranslate(newTransfrom, 0, -2*scrollView.contentOffset.y);
  //    self.addNewListView.layer.affineTransform = newTransfrom;
  //
  //  }
  //  NSLog(@"height is %f",self.addNewListView.frame.size.height);
  //  
}

@end
