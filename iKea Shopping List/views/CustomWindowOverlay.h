//
//  CustomWindowOverlay.h
//  iKea Shopping List
//
//  Created by Wael Showair on 2016-01-23.
//  Copyright © 2016 showair.wael@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#define OVERLAY_ACCESSIBILITY_LABEL @"custom overlay"
@interface CustomWindowOverlay : UIView
-(instancetype)initWithFrame:(CGRect)frame aroundView:(UIView*) view;
@end
