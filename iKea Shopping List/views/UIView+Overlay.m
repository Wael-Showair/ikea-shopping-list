//
//  UIView+Overlay.m
//  iKea Shopping List
//
//  Created by Wael Showair on 2015-12-26.
//  Copyright © 2015 showair.wael@gmail.com. All rights reserved.
//
#import <objc/runtime.h>
#import "UIView+Overlay.h"

@implementation UIView (Overlay)

@dynamic upperOverlayView;
-(void)setUpperOverlayView:(UIView *)object{
  objc_setAssociatedObject(self, @selector(upperOverlayView), object, OBJC_ASSOCIATION_ASSIGN);
}
-(id) upperOverlayView{
  return objc_getAssociatedObject(self, @selector(upperOverlayView));
}

@dynamic lowerOverlayView;
-(void)setLowerOverlayView:(UIView *)object{
  objc_setAssociatedObject(self, @selector(lowerOverlayView), object, OBJC_ASSOCIATION_ASSIGN);
}
-(id) lowerOverlayView{
  return objc_getAssociatedObject(self, @selector(lowerOverlayView));
}

@dynamic overlayView;
-(void)setOverlayView:(UIView *)object{
objc_setAssociatedObject(self, @selector(overlayView), object, OBJC_ASSOCIATION_ASSIGN);
}

-(id) overlayView{
  return objc_getAssociatedObject(self, @selector(overlayView));
}

-(void)addOverlay{
  
  UIView* overlay = [[UIView alloc]initWithFrame:self.frame];
  overlay.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
  [self addSubview:overlay];
}

-(void)addOverlayExceptAround:(UIView *)childView{

  CGRect childConvertedFrame = [childView.superview convertRect:childView.frame toView:self];
  CGRect upperRect, lowerRect;
  
  /* Divide the view frame rectangle into two rectangles where upper rectangle is from top edge
   * of the view frame till the top edge of the child view. While, the lower rectangle is from
   * top edge of the child view till the bottom edge of the view.*/
  CGRectDivide(self.frame, &upperRect, &lowerRect, childConvertedFrame.origin.y, CGRectMinYEdge);

  /* Add upper overlay. */
  UIView* upperOverlay = [[UIView alloc] initWithFrame:upperRect];
  upperOverlay.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.2];
  [self addSubview:upperOverlay];
  self.upperOverlayView = upperOverlay;
  
  /* Get the Difference Set between Lower Rectangle & the bounds of childview whihc will not
   * be covered by overlay. */
  lowerRect.size.height -= childView.bounds.size.height;
  lowerRect.origin.y += childView.bounds.size.height;
  
  /* Add lower overlay. */
  UIView* lowerOverlay = [[UIView alloc] initWithFrame:lowerRect];
  lowerOverlay.backgroundColor = upperOverlay.backgroundColor;
  [self addSubview:lowerOverlay];
  self.lowerOverlayView = lowerOverlay;
}

-(void)removeOverlay{
  [self.overlayView removeFromSuperview];
  [self.upperOverlayView removeFromSuperview];
  [self.lowerOverlayView removeFromSuperview];
}

@end
