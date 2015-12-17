//
//  StandaloneNavBar.h
//  iKea Shopping List
//
//  Created by Wael Showair on 2015-12-05.
//  Copyright © 2015 showair.wael@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StandaloneNavBar : UINavigationBar

-(instancetype)  initWithTitle: (NSString*) title
             ForViewController: (UIViewController*)viewController
               LeftBtnSelector: (SEL) leftAction
              RightBtnSelector: (SEL) rightAction
               WithNavItemView: (UIView*) view;

-(void) onChangeDeviceOrientation;
@end
