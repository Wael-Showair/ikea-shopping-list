//
//  UIScrollView+UIScrollView_ObscuringKeyboard.m
//  iKea Shopping List
//
//  Created by Wael Showair on 2015-12-25.
//  Copyright © 2015 showair.wael@gmail.com. All rights reserved.
//
#import <objc/runtime.h>
#import "UIScrollView+ObscuringKeyboard.h"

@implementation UIScrollView (ObscuringKeyboard)

/* Add properties to categories using Associated references: http://goo.gl/VkRyJu */
@dynamic textFieldObscuredByKeyboard;

- (void)setTextFieldObscuredByKeyboard:(id)object {
  objc_setAssociatedObject(self, @selector(textFieldObscuredByKeyboard), object, OBJC_ASSOCIATION_ASSIGN);
}

- (id)textFieldObscuredByKeyboard {
  return objc_getAssociatedObject(self, @selector(textFieldObscuredByKeyboard));
}

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

  /* Check whether the scrollview rect contains the origin of textfield.
   * Note that the text field is not always a direct child to scrollview, so in this case
   * a conversion from textfield origin coordinate system must be done towards scrollview rect 
   * coordinate system. Text Programming Guide for iOS https://goo.gl/yZreJl */
  CGPoint convertedOrigin =
    [self.textFieldObscuredByKeyboard.superview convertPoint:self.textFieldObscuredByKeyboard.frame.origin
                                                      toView:self.superview];
  
  if (!CGRectContainsPoint(aRect,convertedOrigin ) ) {
    /* Convert the frame of the text field obscured by the keyboard to scroll view coordinate system*/
//    CGRect convertedRect = CGRectMake(convertedOrigin.x,
//                                      convertedOrigin.y,
//                                      self.textFieldObscuredByKeyboard.bounds.size.width,
//                                      self.textFieldObscuredByKeyboard.bounds.size.height);
    
    CGRect convertedRect = [self.textFieldObscuredByKeyboard.superview convertRect:self.textFieldObscuredByKeyboard.frame toView:self.superview];
    
    /* Scroll to the converted visible frame rectangle of the text field. */
    [self scrollRectToVisible:convertedRect animated:YES];
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
  self.textFieldObscuredByKeyboard = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
  self.textFieldObscuredByKeyboard = nil;
}
@end
