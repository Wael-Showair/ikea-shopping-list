//
//  CustomWindowOverlay.m
//  iKea Shopping List
//
//  Created by Wael Showair on 2016-01-23.
//  Copyright © 2016 showair.wael@gmail.com. All rights reserved.
//

#import "CustomWindowOverlay.h"
#define VIEW_INSET  11.0f
@interface CustomWindowOverlay ()

/* Determine the clipping rectangle area that will be excpetionally transparent.*/
@property CGRect transparentArea;

@end

@implementation CustomWindowOverlay

-(instancetype)initWithFrame:(CGRect)frame aroundView:(UIView*) view{
  
  frame.size.height += 100.0;
  self = [super initWithFrame:frame];

  self.opaque = NO;
//  NSLog(@"frame of the window : %@", NSStringFromCGRect( view.window.frame));
  
//  NSLog(@"frame of view.frame before conversion: %@",NSStringFromCGRect(view.frame));
  
  /* Convert the transparent view to the window coordinate system. */
  CGRect convertedRect = [view convertRect:view.bounds toView:nil];
  self.transparentArea = CGRectInset(convertedRect, VIEW_INSET, VIEW_INSET);
//  NSLog(@"frame of view after conversion: %@",NSStringFromCGRect(self.transparentArea));

  /* Improve accessibility and UI Testing. */
  self.accessibilityIdentifier = OVERLAY_ACCESSIBILITY_LABEL;
  //self.accessibilityTraits = UIAccessibilityTraitButton;
  //self.userInteractionEnabled = YES;
  return self;
}

- (void)drawRect:(CGRect)bounds {
  /* Draw a rectangle bezier path & append it to the view rectangle bezier path.*/
  UIBezierPath* clippingPath = [UIBezierPath bezierPathWithRoundedRect:self.transparentArea cornerRadius:0];
  /* Add the clipping rectangle (transparent area) to the parent rectangular area of the window overlay.*/
  [clippingPath appendPath: [UIBezierPath bezierPathWithRect:bounds]];
  
  /* This is the most important option that does the trick of filling all the view rectangle except
   * for the clipping rectangle area. https://goo.gl/aMrMtK */
  clippingPath.usesEvenOddFillRule = YES;
  
  /* Set the fill color to be a transparent black color*/
  UIColor* color = [[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
  [color setFill];
  [clippingPath fill];
}



@end
