//
//  DetailedItemViewController.h
//  iKea Shopping List
//
//  Created by Wael Showair on 2015-11-30.
//  Copyright © 2015 showair.wael@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShoppingItemDelegate.h"

@interface DetailedItemViewController : UIViewController
<UITextFieldDelegate,
UINavigationBarDelegate>

@property ShoppingItem* shoppingItem;
@property BOOL isNewItem;
@property (weak) id <ShoppingItemDelegate> shoppningItemDelegate;
@end
