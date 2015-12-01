//
//  DetailedItemViewController.m
//  iKea Shopping List
//
//  Created by Wael Showair on 2015-11-30.
//  Copyright © 2015 showair.wael@gmail.com. All rights reserved.
//
#import "ShoppingItem.h"
#import "DetailedItemViewController.h"

@interface DetailedItemViewController()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property UITextField* targetTextField;
@end

@implementation DetailedItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self registerForKeyboardNotifications];
    
    /* Check if the Detailed Item View is presented to add new item or
     * to display details of an existing item. */
    if(self.isNewItem){
        
        /* The Detail Item View is presented modally in this case. Thus a 
         * navigation bar must be created.*/
        [self createNavigationBar];
        
        /* Hide the toolbar.*/
        [self.toolbar setHidden:YES];
        
    }else{
        self.title = self.shoppingItem.name;
    }


}

- (void)didReceiveMemoryWarning {
    
    // Dispose of any resources that can be recreated.
    [super didReceiveMemoryWarning];
    
}

#pragma Reposition Contents Obscured by Keyboard
// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    /* Register handler upon receiving keyboard displaying event.
     * Note that UIKeyboardWillShowNotification makes the animation smoother 
     * than using UIKeyboardDidShowNotification that was used in 
     * Text Programming Guide for iOS https://goo.gl/yZreJl */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];

    /* Register handler upon receiving keyboard hiding event. */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    /* Get the keyboard size from the info dictionary of the notification*/
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    /* Adjust the bottom content inset of the scroll view (as well as the scroll indicators) by the keyboard height.*/
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    /* If active text field is hidden by keyboard, scroll it so it's visible */
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.targetTextField.frame.origin) ) {
        [self.scrollView scrollRectToVisible:self.targetTextField.frame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    /* Reset the content inset of the scroll view (as well as the scroll indicators) to zero*/
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

#pragma TextField Delegate - Protocol
//each text field in the interface sets the view controller as its delegate. 
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.targetTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.targetTextField = nil;
}

#pragma Modal - Navigation Bar

-(void) createNavigationBar{
    
    /* Create navigation bar at run-time for the New Item Modal view. */
    UINavigationBar* navbar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    
    /* Create navigation item object */
    UINavigationItem* navItem = [[UINavigationItem alloc] initWithTitle:self.shoppingItem.name];
    
    /* Create left button item. */
    UIBarButtonItem* cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(onTapCancel:)];
    navItem.leftBarButtonItem = cancelBtn;
    
    /* Create left button item. */
    UIBarButtonItem* doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onTapDone:)];
    navItem.rightBarButtonItem = doneBtn;
    
    /* Assign the navigation item to the navigation bar.
     * The navigation bar displays information from a stack of
     * UINavigationItem objects. At any given time, the UINavigationItem
     * that is currently the topItem of the stack determines the title and
     * other optional information in the navigation bar, such as the right
     * button and prompt.*/
    [navbar setItems:@[navItem]];
    
    /* add navigation bar to the root view of the item details scene.*/
    [self.view addSubview:navbar];
}

-(IBAction)onTapCancel:(id)sender{
    /* Dismiss the presented modal view controller. */
    [self dismissViewControllerAnimated:YES completion:nil];

}
-(IBAction)onTapDone:(id)sender{
    /* Dismiss the presented modal view controller. */
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
