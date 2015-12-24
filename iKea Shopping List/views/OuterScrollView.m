//
//  OuterScrollView.m
//  iKea Shopping List
//
//  Created by Wael Showair on 2015-12-20.
//  Copyright © 2015 showair.wael@gmail.com. All rights reserved.
//

#import "OuterScrollView.h"

#define ANIMATION_DURATION  0.3

#define X_SCALING_DOWN_FACTOR  0.5
#define Y_SCALING_DOWN_FACTOR  X_SCALING_DOWN_FACTOR

#define STICKY_VIEW_HEIGHT  94.0
#define TRANSLATE_TY_STICKY_VIEW_UP -STICKY_VIEW_HEIGHT*2
#define TRANSLATE_TX_STICKY_VIEW_LEFT -200.0

#define TRANSLATE_TY_SCROLL_VIEW_UP  -STICKY_VIEW_HEIGHT
#define TRANSLATE_TX_SCROLL_VIEW_LEFT  0.0

#define X_SCALING_UP_FACTOR 1.0
#define Y_SCALING_UP_FACTOR 1.0

#define TRANSLATE_TX_LEFT 0.0
#define TRANSLATE_TY_DOWN 0.0

@implementation OuterScrollView

-(void)scrollViewDidCrossOverThreshold:(UIScrollView *)scrollView{
  
  CGAffineTransform currentTransform = self.stickyHeader.layer.affineTransform;
  
  CGAffineTransform combinedTransform = CGAffineTransformScale(currentTransform,
                                                               X_SCALING_DOWN_FACTOR,
                                                               Y_SCALING_DOWN_FACTOR);
  
  /* When the scaling transformation matrix is applied, the view's height has been shrinked by 0.5,
   * now the view is shifted by height/4 from top and bottom.
   * To shift the object at the top of the screen, you should have move the origin by hieght/4
   * but wait a second, every point would divided by two so the object will actually be shifted by
   * height/8 so to compnsate this you have to move the origin at the original coordinate system
   * by 2*height/4 = height/2 so that it will be converted to height/4 in the scaled down coordinate
   * system*/
  combinedTransform = CGAffineTransformTranslate(combinedTransform,
                                                 TRANSLATE_TX_STICKY_VIEW_LEFT,
                                                 TRANSLATE_TY_STICKY_VIEW_UP);
  
  [UIView animateWithDuration:ANIMATION_DURATION animations:^{
    self.stickyHeader.layer.affineTransform = combinedTransform;
    scrollView.layer.affineTransform = CGAffineTransformMakeTranslation(TRANSLATE_TX_SCROLL_VIEW_LEFT,
                                                                        TRANSLATE_TY_SCROLL_VIEW_UP);
  }completion: ^(BOOL finished){
    [self.stickyDelegate viewDidDisappear:self.stickyHeader];
  }];
}

-(void)scrollViewDidReturnBelowThreshold:(UIScrollView *)scrollView{
  
  CGAffineTransform newTransfrom = CGAffineTransformMakeScale(X_SCALING_UP_FACTOR,
                                                              Y_SCALING_UP_FACTOR);
  
  CGAffineTransform translateTransform = CGAffineTransformMakeTranslation(TRANSLATE_TX_LEFT,
                                                                          TRANSLATE_TY_DOWN);
  
  [self.stickyDelegate viewWillAppear:self.stickyHeader];
  [UIView animateWithDuration:ANIMATION_DURATION animations:^{
    self.stickyHeader.layer.affineTransform = newTransfrom;
    scrollView.layer.affineTransform = translateTransform;
  }];
}
@end
