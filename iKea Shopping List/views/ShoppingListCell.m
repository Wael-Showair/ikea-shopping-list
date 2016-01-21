//
//  ShoppingListCell.m
//  iKea Shopping List
//
//  Created by Wael Showair on 2016-01-17.
//  Copyright © 2016 showair.wael@gmail.com. All rights reserved.
//

#import "ShoppingListCell.h"

@implementation ShoppingListCell

-(void)awakeFromNib{
  /*If the width equals to the height and the corner radius is set to lenght/2
   * then the square will turn into circle. */
  self.deleteBtn.layer.cornerRadius = self.deleteBtn.bounds.size.height/2;
  self.deleteBtn.hidden = YES;
}
@end
