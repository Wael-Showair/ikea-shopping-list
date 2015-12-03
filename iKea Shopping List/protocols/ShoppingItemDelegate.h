//
//  ShoppingItemCreationDelegate.h
//  iKea Shopping List
//
//  Created by Wael Showair on 2015-12-03.
//  Copyright © 2015 showair.wael@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ShoppingItemDelegate <NSObject>

@required
-(void)itemDidCreated: (ShoppingItem*) newItem;
@end
