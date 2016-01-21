//
//  UIView+ShakeAnimation.m
//  iKea Shopping List
//
//  Created by Wael Showair on 2016-01-21.
//  Copyright © 2016 showair.wael@gmail.com. All rights reserved.
//

#import "UIView+ShakeAnimation.h"

@implementation UIView (ShakeAnimation)

-(void)startShakeAnimationWithDelay: (CGFloat) delay{
  //self.layer.anchorPoint = CGPointMake(0, 0);
  [UIView animateWithDuration:0.15 delay:delay options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAllowUserInteraction animations:^{
    
    self.layer.affineTransform = CGAffineTransformMakeRotation(0.03);
  }completion:nil];

}

-(void)stoptShakeAnimation {
  [UIView animateWithDuration:0.0 animations:^{
      self.layer.affineTransform = CGAffineTransformIdentity;
  }];
  
}

@end
