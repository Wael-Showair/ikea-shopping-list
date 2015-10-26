//
//  ShoppingItem.m
//  iKea Shopping List
//
//  Created by Wael Showair on 2015-10-25.
//  Copyright © 2015 showair.wael@gmail.com. All rights reserved.
//

#import "ShoppingItem.h"


@implementation ShoppingItem


- (instancetype)init
{
    self = [super init];
    if (self) {

        /* invoke the designated initializer. */
        NSDecimalNumber* temp = [NSDecimalNumber decimalNumberWithString:@"0"];
        self = [self initWithName:@"" price:temp];
    }
    return self;
}

-(instancetype) initWithName:(NSString*) itemName
                       price:(NSDecimalNumber*) itemPrice
{
    self = [super init];
    
    if(self){
        _name = itemName;
        _price = itemPrice;
        _imageName = @"";
    }
    return self;
}
                    

@end


