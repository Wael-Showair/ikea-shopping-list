//
//  OuterScrollView.m
//  iKea Shopping List
//
//  Created by Wael Showair on 2015-12-20.
//  Copyright © 2015 showair.wael@gmail.com. All rights reserved.
//

#import "OuterScrollView.h"

@interface OuterScrollView()

@end

@implementation OuterScrollView
-(void)awakeFromNib{
//  CGAffineTransform combinedTransform  = CGAffineTransformMakeScale(1, 1);
//  combinedTransform = CGAffineTransformTranslate(combinedTransform, 0, 0);
//  self.stickyHeader.layer.affineTransform = combinedTransform;
//  
  self.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);  
}
//- (void)layoutSubviews{
//  [super layoutSubviews];
//  
//  if((self.contentOffset.y>= 30.0) && (YES == self.shouldAnimateStickyHeader)){
//    self.shouldAnimateStickyHeader = NO;
//    CGAffineTransform currentTransform = self.stickyHeader.layer.affineTransform;
//    
//    CGAffineTransform newTransfrom = CGAffineTransformScale(currentTransform,1, 0.5);
//    newTransfrom = CGAffineTransformTranslate(newTransfrom, 0, -5);
//    [UIView animateWithDuration:1.0 animations:^{
//      self.stickyHeader.layer.affineTransform = newTransfrom;
//    }];
//  }else if((self.contentOffset.y< 30.0) && (self.contentOffset.y > 0.0)){
//    CGAffineTransform newTransfrom = CGAffineTransformMakeScale(1, 1);
//    newTransfrom = CGAffineTransformTranslate(newTransfrom, 0, 5);
//    
//    self.shouldAnimateStickyHeader = YES;
//    
//    [UIView animateWithDuration:1.0 animations:^{
//      self.stickyHeader.layer.affineTransform = newTransfrom;
//    }];
//  }
//}

-(void)scrollViewDidCrossOverThreshold:(UIScrollView *)scrollView{
  
  CGAffineTransform currentTransform = self.stickyHeader.layer.affineTransform;
  
  CGAffineTransform translateTransform = CGAffineTransformMakeTranslation(0, -47.0);
  
  CGAffineTransform newTransfrom = CGAffineTransformScale(currentTransform, 1.0, 0.5);
  
  /* When the scaling transformation matrix is applied, the view's height has been shrinked by 0.5,
   * now the view is shifted by height/4 from top and bottom.
   * To shift the object at the top of the screen, you should have move the origin by hieght/4
   * but wait a second, every point would divided by two so the object will actually be shifted by
   * height/8 so to compnsate this you have to move the origin at the original coordinate system
   * by height/4*2 = height/2 so that it will be converted to height/4 in the shrinked coordinate
   * system*/
  newTransfrom = CGAffineTransformTranslate(newTransfrom, 0.0, -47.0);
  
  
  UIButton* button = (UIButton*) [self viewWithTag:2];
  CGFloat fontSize = button.titleLabel.font.pointSize;
  button.titleLabel.adjustsFontSizeToFitWidth  = YES;
  button.titleLabel.numberOfLines = 1;
  button.titleLabel.minimumScaleFactor = 2;
  button.titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
  button.titleLabel.font = [UIFont systemFontOfSize:fontSize*2];
  
  [UIView animateWithDuration:0.3 animations:^{
    self.stickyHeader.layer.affineTransform = newTransfrom;
    scrollView.layer.affineTransform = translateTransform;
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
  }completion: ^(BOOL finished){
    
  }];
}

-(void)scrollViewDidReturnBelowThreshold:(UIScrollView *)scrollView{
  
  CGAffineTransform newTransfrom = CGAffineTransformMakeScale(1, 1);
  CGAffineTransform translateTransform = CGAffineTransformMakeTranslation(0, 0);
  
  UIButton* button = (UIButton*) [self viewWithTag:2];
  CGFloat fontSize = button.titleLabel.font.pointSize;
  
  [UIView animateWithDuration:0.3 animations:^{
    self.stickyHeader.layer.affineTransform = newTransfrom;
    scrollView.layer.affineTransform = translateTransform;
    
  }];
}
@end
