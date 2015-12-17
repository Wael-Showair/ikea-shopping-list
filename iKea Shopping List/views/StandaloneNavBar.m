//
//  StandaloneNavBar.m
//  iKea Shopping List
//
//  Created by Wael Showair on 2015-12-05.
//  Copyright © 2015 showair.wael@gmail.com. All rights reserved.
//

#import "StandaloneNavBar.h"

@interface StandaloneNavBar()
@property (weak, nonatomic) UIViewController* hostingViewController;
@property (weak, nonatomic) IBOutlet NSArray* verticalConstraints;
@end

@implementation StandaloneNavBar

-(void)onChangeDeviceOrientation{
  
  /* Get a reference to the navigation bar to be used in Auto Layout constraints*/
  UINavigationBar* navigationBar = self;
  
  /* Remove the vertical constraint (Fixed Height) of the navigation bar.*/
  [self.hostingViewController.view removeConstraints:self.verticalConstraints];
  
  /* Let the navigation bar has its new intrinsic size. */
  [self sizeToFit];
  
  /* Get a reference to the Top Layout Guide to be used in the constraint*/
  id<UILayoutSupport> topGuide = self.hostingViewController.topLayoutGuide;
  
  /* Creates a dictionary wherein the keys are string representations of the corresponding values’ 
   * variable names. */
  NSDictionary* viewsDictionary = NSDictionaryOfVariableBindings(navigationBar, topGuide);
  
  /* Add Vertical constraint to the navigation bar (with fixed height) */
  NSString* verticalConstraintExpression =
          [NSString stringWithFormat: @"V:|[topGuide][navigationBar(%f)]", self.frame.size.height];
  
  NSArray* verticalConstraints =
          [NSLayoutConstraint constraintsWithVisualFormat:verticalConstraintExpression
                                                  options:0 metrics:nil
                                                    views:viewsDictionary];
  
  [self.hostingViewController.view addConstraints:verticalConstraints];
  
  /* Save the vertical constraint for future references. It will be removed when the device 
   * orientation is changed. */
  self.verticalConstraints = verticalConstraints;
  
}

- (void) layoutNavigationBar{
  
  /* Get reference to standalone navigation bar to be used in Visual Format
   * Language of Constraints. Note that the size of this bar is zero.*/
  UINavigationBar* navigationBar = self;
  
  /* Let the navigation bar have its intrinsic size. */
  [self sizeToFit];
  
  /* add navigation bar to the root view  .*/
  [self.hostingViewController.view addSubview:self];
  
  /* */
  self.translatesAutoresizingMaskIntoConstraints = NO;
  
  /* Get a reference to the Top Layout Guide.*/
  id<UILayoutSupport> topGuide = self.hostingViewController.topLayoutGuide;
  
  /* Creates a dictionary wherein the keys are string representations of the corresponding values’ variable names. */
  NSDictionary* viewsDictionary = NSDictionaryOfVariableBindings(navigationBar, topGuide);
  
  /* Add Horizontal constraint to the navigation bar. */
  NSString* horizontalConstraintExpression = [NSString stringWithFormat:@"|[navigationBar]|"];
  NSArray* horizontalConstraints =
      [NSLayoutConstraint constraintsWithVisualFormat:horizontalConstraintExpression
                                              options:0
                                              metrics:nil
                                                views:viewsDictionary];
  [self.hostingViewController.view addConstraints:horizontalConstraints];
  
  /* Add Vertical constraint to the navigation bar (with fixed height) */
  NSString* verticalConstraintExpression =
    [NSString stringWithFormat: @"V:|[topGuide][navigationBar(%f)]", navigationBar.frame.size.height];
  
  NSArray* verticalConstraints =
    [NSLayoutConstraint constraintsWithVisualFormat:verticalConstraintExpression
                                            options:0
                                            metrics:nil
                                              views:viewsDictionary];
  [self.hostingViewController.view addConstraints:verticalConstraints];
  
  /* Save the vertical constraint for future references. It will be removed
   * when the device orientation is changed. */
  self.verticalConstraints = verticalConstraints;
}

-(instancetype)  initWithTitle: (NSString*) title
             ForViewController: (UIViewController *)viewController
               LeftBtnSelector: (SEL) leftAction
              RightBtnSelector: (SEL) rightAction
               WithNavItemView: (UIView*) view
{
  self = [super init];
  if (self) {
    
    _hostingViewController = viewController;
    
    /* Create navigation bar at run-time for the New Item Modal view. */
    [self layoutNavigationBar];
    
    /* Create navigation item object */
    UINavigationItem* navItem = [[UINavigationItem alloc] initWithTitle:title];
    
    /* If this property value is nil, the navigation item’s title is
     * displayed in the center of the navigation bar when the receiver is
     * the top item. */
    navItem.titleView = view;
    
    if(nil != leftAction){
      UIBarButtonItem* leftBtn =
          [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                        target:self.hostingViewController
                                                        action:leftAction];
      navItem.leftBarButtonItem = leftBtn;
    }
    
    if(nil != rightAction){
      UIBarButtonItem* rightBtn =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                      target:self.hostingViewController
                                                      action:rightAction];
      navItem.rightBarButtonItem = rightBtn;
    }
    
    /* Assign the navigation item to the navigation bar.
     * The navigation bar displays information from a stack of
     * UINavigationItem objects. At any given time, the UINavigationItem
     * that is currently the topItem of the stack determines the title and
     * other optional information in the navigation bar, such as the right
     * button and prompt.*/
    [self setItems:@[navItem]];
  }
  
  return self;
}


@end
