//
//  ShoppingItemTableViewCell.m
//  iKea Shopping List
//
//  Created by Wael Showair on 2015-12-11.
//  Copyright © 2015 showair.wael@gmail.com. All rights reserved.
//

#import "ShoppingItemTableViewCell.h"

@implementation ShoppingItemTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
  if(selected){
    if(animated){
      [UIView animateWithDuration:10.0 animations:^{
        self.backgroundColor = [UIColor yellowColor];
      }];
    }else{
      self.backgroundColor = [UIColor yellowColor];
    }
  }
  else if(NO == selected){
    if(animated){
      [UIView animateWithDuration:3.0 animations:^{
        self.backgroundColor = [UIColor clearColor];
      }];
    }else{
      self.backgroundColor = [UIColor clearColor];
    }
  }
}
@end
