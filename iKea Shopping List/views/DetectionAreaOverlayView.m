//
//  DetectionAreaOverlay.m
//  iKea Shopping List
//
//  Created by Wael Showair on 2016-01-08.
//  Copyright © 2016 showair.wael@gmail.com. All rights reserved.
//

#import "DetectionAreaOverlayView.h"

@implementation DetectionAreaOverlayView

-(instancetype)initWithFrame:(CGRect)frame{
  self = [super initWithFrame:frame];
  /* The default value of opaque is YES but since this is an overaly view, meaning that it should
   * be transparent, hence set opaque property to NO. Otherwise, you will get balck background view
   * with no tranparency to the camera preview. */
  self.opaque = NO;
  return self;
}

- (void)drawRect:(CGRect)bounds {
  /* Determine the clipping rectangle dimension that will be totally transparent, hence it will
   * indicate the detection area for the ikea tag. */
  CGRect clipRect = CGRectInset(bounds, 50, 50);
  
  /* Draw a rectangle bezier path & append it to the view rectangle bezier path.*/
  UIBezierPath* clippingPath = [UIBezierPath bezierPathWithRoundedRect:clipRect cornerRadius:0];
  [clippingPath appendPath: [UIBezierPath bezierPathWithRect:bounds]];
  
  /* This is the most important option that does the trick of filling all the view rectangle except
   * for the clipping rectangle area. https://goo.gl/aMrMtK */
  clippingPath.usesEvenOddFillRule = YES;
  
  /* Set the fill color to be a transparent black color*/
  UIColor* color = [[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
  [color setFill];
  [clippingPath fill];
  
  /* Set the stroke line color to white. */
  [clippingPath setLineWidth:2.0];
  [[UIColor whiteColor] setStroke];
  [clippingPath stroke];
  
}


@end
