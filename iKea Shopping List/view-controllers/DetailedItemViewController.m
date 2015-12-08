//
//  DetailedItemViewController.m
//  iKea Shopping List
//
//  Created by Wael Showair on 2015-11-30.
//  Copyright © 2015 showair.wael@gmail.com. All rights reserved.
//
#import "ShoppingItem.h"
#import "ShoppingItemDelegate.h"
#import "DetailedItemViewController.h"
#import "StandaloneNavBar.h"
#import "CustomScrollView.h"
#import "UITextField+Additions.h"




@interface DetailedItemViewController()

typedef enum{
    PRICE       = 1,
    QUANTITY    = 2,
    AISLE       = 3,
    BIN         = 4,
    ITEM_NUM    = 5
} TEXT_FIELD_TAG;


@property (weak, nonatomic) IBOutlet CustomScrollView *scrollView;
@property (weak,nonatomic) IBOutlet StandaloneNavBar* navbar;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UITextField *quantityTextField;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@end
@implementation DetailedItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.scrollView registerForKeyboardNotifications];
    
    [self registerForDeviceChangeOrientation];
    
    /* Check if the Detailed Item View is presented to add new item or
     * to display details of an existing item. */
    if(self.isNewItem){
        
        
        /* The Detail Item View is presented modally in this case. Thus a
         * navigation bar must be created.*/
        StandaloneNavBar* customNavBar =
          [[StandaloneNavBar alloc] initWithTitle:self.shoppingItem.name
                                ForViewController:self
                                  LeftBtnSelector:@selector(onTapCancel:)
                                 RightBtnSelector:@selector(onTapDone:)];
        
        /* Set current view controller as delegate object of the navigation bar.*/
        customNavBar.delegate = self;
        self.navbar = customNavBar;

        /* Disable Done button which is located at the right bar button item. */
        customNavBar.topItem.rightBarButtonItem.enabled = NO;
        
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

#pragma Device Orientation Change

- (void) registerForDeviceChangeOrientation{
    
    /* Enable the device’s accelerometer hardware and begins the delivery of acceleration events.*/
    
    /* TODO: you should always match each call with a corresponding call to the endGeneratingDeviceOrientationNotifications. */
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    /*  Add the view as an observer to the notification center specifically for
     * device orientation change notification.*/
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(deviceOrientationDidChange:) name: UIDeviceOrientationDidChangeNotification object: nil];
}

-(void)deviceOrientationDidChange: (NSNotification *)notification{
    [self.navbar onChangeDeviceOrientation];
}

#pragma Standalone Navigation Bar

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar{
    return UIBarPositionTopAttached;
}

-(IBAction)onTapCancel:(id)sender{

    /* Dismiss keyboard (in case it is displayed). This is more convenient since
     * there are 5 text fields.*/
    [self.view endEditing:YES];
    
    /* Dismiss the presented modal view controller. */
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)onTapDone:(id)sender{
    
    
    /* Set all fields of the shopping item.
     * When user switches between different text fields, the delegate is informed
     * about editing stopping through textFieldDidEndEditing.
     * But for the last text field that the user edits, Done button is tapped
     * hence, endEditing must be triggered first to get the value of last text
     * field the user was editing then inform the delegates about itemDidCreated.*/
    
    /* Dismiss keyboard (in case it is displayed). This is more convenient since
     * there are 5 text fields.*/
    [self.view endEditing:YES];

    /* As recommended in Official View Controller iOS Programming Guide here in
     * this link: http://goo.gl/Phwrp6, Dismissing a Presented View Controller
     * section mentioned exciplictly that If the presented view controller must
     * return data to the presenting view controller, use the delegation design
     * pattern to facilitate the transfer.
     */
    [self.shoppningItemDelegate itemDidCreated:self.shoppingItem];
    
    /* Dismiss the presented modal view controller. */
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma TextField Delegate - Protocol
- (BOOL) textFieldValidate:(UITextField *)textField
     withReplacementString:(NSString *)string{
    BOOL isValid = YES;
    NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
    formatter.minimum = [NSNumber numberWithInt:0];
    
    NSNumber* parsedNumber;
    NSString* errorMsg;
    NSString* appendedString = string.length>0?
                            [textField.text stringByAppendingString:string]:
    [textField.text substringToIndex:textField.text.length-1];
    
    switch ((TEXT_FIELD_TAG)textField.tag) {
        case PRICE:
        case QUANTITY:
            isValid = [formatter getObjectValue:&parsedNumber
                                      forString: appendedString
                               errorDescription:&errorMsg];
            if(0 == appendedString.length){
                isValid = NO;
                errorMsg = @"This field can't be empty";
            }
            
            if(isValid == NO){
                [textField displayErrorIndicators];
                [textField displayErrorMessage:errorMsg];
            }
            else{
                [textField removeErrorIndicators];
                [textField removeErrorMessage];
            }
            break;
            
        default:
            break;
    }
    return isValid;
    
}

- (BOOL)            textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
            replacementString:(NSString *)string{
    
    BOOL isValid = [self textFieldValidate:textField withReplacementString:string];
    switch ((TEXT_FIELD_TAG)textField.tag) {
        case PRICE:
            self.navbar.topItem.rightBarButtonItem.enabled =
                (0 != self.quantityTextField.text.length) && isValid;
            break;
        case QUANTITY:
            self.navbar.topItem.rightBarButtonItem.enabled =
                (0 != self.priceTextField.text.length) && isValid;
            break;
            
        default:
            break;
    }
    return YES;
}

- (BOOL) textFieldShouldClear:(UITextField *)textField{
    
    [textField removeErrorMessage];
    
    switch ((TEXT_FIELD_TAG)textField.tag) {
        case PRICE:
        case QUANTITY:
            self.navbar.topItem.rightBarButtonItem.enabled = NO;
            break;
            
        default:
            break;
    }
    return YES;
}

/* Validating Entered Text https://goo.gl/Wzf305 */
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return (nil == [self.view viewWithTag:ERROR_MSG_TAG]);
}

/* Tracking Multiple Text Fields https://goo.gl/NWJqBV */
- (void) textFieldDidEndEditing:(UITextField *)textField{
    switch ((TEXT_FIELD_TAG)textField.tag) {
        case PRICE:
            self.shoppingItem.price = [NSDecimalNumber decimalNumberWithString:textField.text];
            break;
        case QUANTITY:
            self.shoppingItem.quantity = textField.text.integerValue;
            break;
        case AISLE:
            self.shoppingItem.aisleNumber = textField.text.integerValue;
            break;
        case BIN:
            self.shoppingItem.binNumber = textField.text.integerValue;
            break;
        case ITEM_NUM:
            self.shoppingItem.articleNumber = textField.text;
            break;
            
        default:
            NSLog(@"Error Undefined Text Field Tag: %ld", (long)textField.tag);
            break;
    }
}

@end
