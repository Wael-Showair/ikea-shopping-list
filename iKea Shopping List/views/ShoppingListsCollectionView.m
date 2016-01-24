//
//  ShoppingListsTableView.m
//  iKea Shopping List
//
//  Created by Wael Showair on 2015-12-21.
//  Copyright © 2015 showair.wael@gmail.com. All rights reserved.
//

#import "ShoppingListsCollectionView.h"
#import "ShoppingListCell.h"
#import "TextInputCell.h"

#define SCROLLING_THRESHOLD 30.0
#define TEXT_FIELD_CELL_NIB     @"text-input-cell"

@implementation ShoppingListsCollectionView

-(void)awakeFromNib{
  self.shouldNotifyDelegate = YES;
  self.editingMode = NO;
  
  
  UINib* nib = [UINib nibWithNibName:TEXT_FIELD_CELL_NIB bundle:nil];
  
  [self registerNib:nib forCellWithReuseIdentifier:NEW_LIST_INFO_CELL_ID];
  /* Remove empty cells from the table view. */
  //self.tableFooterView = [UIView new];
}

-(void)setContentOffset:(CGPoint)contentOffset{
  [super setContentOffset:contentOffset];
  self.prevContentOffsetY = contentOffset.y;
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
  
  UIView* view;
  
  /* When the collection view is in editing mode, you should not trigger the segue of showing detailed
   * shopping items (it is ID is Main.Storyboard equals to showListOfItems).
   * There are two possible solutions here, either to trigger the segue manually or bypass any tap
   * gesture on the whole cell to the delete button, hence the cell will be deleted by tapping any
   * where in the cell.
   * I would go with the second solution because I don't want to lose the segue visual connection 
   * between the two view controllers. Another benefit for this solution if the user finger is big,
   * He does not have to press exactly on top of the small delete button. */
  
  if(YES ==self.editingMode){
    NSIndexPath* indexPath = [self indexPathForItemAtPoint:point];
    ShoppingListCell* cell = (ShoppingListCell*)[self cellForItemAtIndexPath:indexPath];
    view = cell.deleteBtn;
    
  }else{
    view = [super hitTest:point withEvent:event];
  }
  return view;
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