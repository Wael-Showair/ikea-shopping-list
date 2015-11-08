//
//  ListAdditionViewController.h
//  iKea Shopping List
//
//  Created by Wael Showair on 2015-11-07.
//  Copyright © 2015 showair.wael@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListInfoCreationDelegate.h"

/* This view controler should conform to UIBarPositioningDelegate to change the 
 * position of bar. Since the bar is included in a navigation bar, The view 
 * controller should conform to UINavigationBarDelegate which conforms to 
 * UIBarPositioningDelegate.
 */
@interface ListAdditionViewController : UIViewController
                <UINavigationBarDelegate, UITableViewDataSource>

@property (weak) id<ListInfoCreationDelegate> listInfoCreationDelegate;
@end
