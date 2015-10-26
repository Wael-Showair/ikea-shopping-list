//
//  ShoppingList.h
//  iKea Shopping List
//
//  Created by Wael Showair on 2015-10-25.
//  Copyright © 2015 showair.wael@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShoppingList : NSObject

- (BOOL) addNewItem: (ShoppingItem*) item;
- (NSUInteger)  count;
- (ShoppingItem*) itemAtIndex: (int) index;

@end
