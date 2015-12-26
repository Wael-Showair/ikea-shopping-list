//
//  UIView+Overlay.h
//  iKea Shopping List
//
//  Created by Wael Showair on 2015-12-26.
//  Copyright © 2015 showair.wael@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Overlay)

@property (weak,nonatomic) UIView* overlayView;
@property (weak,nonatomic) UIView* upperOverlayView;
@property (weak,nonatomic) UIView* lowerOverlayView;

-(void) addOverlay;
-(void) addOverlayExceptAround: (UIView*) childView;
-(void) removeOverlay;

@end
