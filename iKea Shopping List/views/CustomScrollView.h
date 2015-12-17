//
//  CustomScrollView.h
//  iKea Shopping List
//
//  Created by Wael Showair on 2015-12-05.
//  Copyright © 2015 showair.wael@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomScrollView : UIScrollView <UITextFieldDelegate>

- (void)registerForKeyboardNotifications;

@end
