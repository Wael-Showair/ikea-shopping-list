//
//  UIScrollView+UIScrollView_ObscuringKeyboard.h
//  iKea Shopping List
//
//  Created by Wael Showair on 2015-12-25.
//  Copyright © 2015 showair.wael@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (ObscuringKeyboard) <UITextFieldDelegate>
@property (weak) UITextField* textFieldObscuredByKeyboard;
- (void)registerForKeyboardNotifications;
@end
