//
//  CustomScrollView.m
//  iKea Shopping List
//
//  Created by Wael Showair on 2015-12-05.
//  Copyright © 2015 showair.wael@gmail.com. All rights reserved.
//

#import "CustomScrollView.h"

@interface CustomScrollView()
@property (weak, nonatomic) UITextField* targetTextField;
@end

@implementation CustomScrollView

- (void)registerForKeyboardNotifications
{
  /* Register handler upon receiving keyboard displaying event.
   * Note that UIKeyboardWillShowNotification makes the animation smoother
   * than using UIKeyboardDidShowNotification that was used in
   * Text Programming Guide for iOS https://goo.gl/yZreJl */
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillBeShown:)
                                               name:UIKeyboardWillShowNotification object:nil];
  
  /* Register handler upon receiving keyboard hiding event. */
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillBeHidden:)
                                               name:UIKeyboardWillHideNotification object:nil];
  
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWillBeShown:(NSNotification*)aNotification
{
  /* Get the keyboard size from the info dictionary of the notification*/
  NSDictionary* info = [aNotification userInfo];
  CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
  
  /* Adjust the bottom content inset of the scroll view (as well as the scroll indicators) 
   * by the keyboard height.*/
  UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
  self.contentInset = contentInsets;
  self.scrollIndicatorInsets = contentInsets;
  
  /* If active text field is hidden by keyboard, scroll it so it's visible */
  CGRect aRect = self.superview.frame;
  aRect.size.height -= kbSize.height;
  if (!CGRectContainsPoint(aRect, self.targetTextField.frame.origin) ) {
    [self scrollRectToVisible:self.targetTextField.frame animated:YES];
  }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
  /* Reset the content inset of the scroll view (as well as the scroll indicators) to zero*/
  UIEdgeInsets contentInsets = UIEdgeInsetsZero;
  self.contentInset = contentInsets;
  self.scrollIndicatorInsets = contentInsets;
}

#pragma TextField Delegate - Protocol
//each text field in interface builder sets the view controller as its delegate.
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
  self.targetTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
  self.targetTextField = nil;
}

@end
