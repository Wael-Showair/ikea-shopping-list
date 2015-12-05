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

@interface DetailedItemViewController()
@property (weak, nonatomic) IBOutlet CustomScrollView *scrollView;
@property (weak,nonatomic) IBOutlet StandaloneNavBar* navbar;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

//typedef enum{
//    PRICE       = 0,
//    QUANTITY    = 1,
//    AISLE       = 2,
//    BIN         = 3,
//    ITEM_NUM    = 4
//} TEXT_FIELD_TAG;

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
    
    
    /* Set all fields of the shopping item. */
    
    /* As recommended in Official View Controller iOS Programming Guide here in
     * this link: http://goo.gl/Phwrp6, Dismissing a Presented View Controller
     * section mentioned exciplictly that If the presented view controller must
     * return data to the presenting view controller, use the delegation design
     * pattern to facilitate the transfer.
     */
    [self.shoppningItemDelegate itemDidCreated:self.shoppingItem];
    
    /* Dismiss keyboard (in case it is displayed). This is more convenient since
     * there are 5 text fields.*/
    [self.view endEditing:YES];
    
    
    /* Dismiss the presented modal view controller. */
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
