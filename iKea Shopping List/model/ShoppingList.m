//
//  ShoppingList.m
//  iKea Shopping List
//
//  Created by Wael Showair on 2015-10-25.
//  Copyright © 2015 showair.wael@gmail.com. All rights reserved.
//

#import "ShoppingItem.h"
#import "ShoppingList.h"

@interface ShoppingList()
@property  NSMutableArray* allItems;
@end

@implementation ShoppingList

- (instancetype)init
{
    self = [super init];
    if (self) {

        /* Initialize the pointer to NSMutable array object. */
        self.allItems = [[NSMutableArray alloc] init];
    }
    return self;
}

- (BOOL)addNewItem:(ShoppingItem *)item
{
    [self.allItems insertObject:item atIndex:0];
    return YES;
}

-(ShoppingItem *)itemAtIndex:(int)index{
    @try{
        return [self.allItems objectAtIndex:index];
    }
    @catch(NSException* exception){
        NSLog( @"NSException caught" );
        NSLog( @"Name: %@", exception.name);
        NSLog( @"Reason: %@", exception.reason );
        return nil;
    }
}

-(NSUInteger)count{
    return self.allItems.count;
}



@end
