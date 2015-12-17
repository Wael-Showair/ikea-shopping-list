//
//  UIView+UIView_Additions.m
//  iKea Shopping List
//
//  Created by Wael Showair on 2015-12-10.
//  Copyright © 2015 showair.wael@gmail.com. All rights reserved.
//

#import "UIView+FlashAnimation.h"

@implementation UIView (UIView_Additions)
-(void) startFlashAnimationWithColor: (UIColor* )color{
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionAutoreverse |
                                 UIViewAnimationOptionRepeat |
                                 UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.layer.backgroundColor = color.CGColor;
                     }
                     completion:nil];
}
-(void) stopFlashAnimation{
    [UIView animateWithDuration:0.0
                          delay:0.0
                        options:0
                     animations:^{
                         self.layer.backgroundColor = [[UIColor clearColor] CGColor];
                     }
                     completion:nil];
}
@end
