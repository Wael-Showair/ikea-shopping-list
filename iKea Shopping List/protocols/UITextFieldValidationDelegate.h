//
//  UITextFieldValidationDelegate.h
//  iKea Shopping List
//
//  Created by Wael Showair on 2015-12-08.
//  Copyright © 2015 showair.wael@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UITextFieldValidationDelegate <UITextFieldDelegate>

@optional
- (BOOL) textFieldValidateInput: (UITextField*) textField;
- (BOOL) textFieldValidate:(UITextField *)textField
     withReplacementString:(NSString*) string;

@end
