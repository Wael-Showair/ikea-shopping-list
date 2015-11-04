/*
 *  @file ShoppingItem.m
 *  implementation file that provides all the needed operations for an iKea shopping item.
 *
 *  @author Wael Showair (showair.wael\@gmail.com)
 *  @version 0.0.1
 *  @copyright 2015. Wael Showair. All rights reserved.
 */


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


