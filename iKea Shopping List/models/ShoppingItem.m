/*
 *  @file ShoppingItem.m
 *  implementation file that provides all the needed operations for an iKea 
 *  shopping item.
 *
 *  @author Wael Showair (showair.wael\@gmail.com)
 *  @version 0.0.1
 *  @copyright 2015. Wael Showair. All rights reserved.
 */


#import "ShoppingItem.h"


@implementation ShoppingItem


- (instancetype)init
{
    NSDecimalNumber* price = [NSDecimalNumber decimalNumberWithString:@"0"];
    /* invoke the designated initializer. */
    self =  [self initWithName:@"" price:price image:@""];
    
    return self;
}



-(instancetype) initWithName:(NSString*) itemName
                       price:(NSDecimalNumber*) itemPrice
{
    /* invoke the designated initializer. */
    self =  [self initWithName:itemName price:itemPrice image:@""];
    return self;
}

-(instancetype) initWithName:(NSString*) itemName
                       price:(NSDecimalNumber*) itemPrice
                       image:(NSString*) fileName
{
    self = [super init];
    
    if(self){
        _name = itemName;
        _price = itemPrice;
        _imageName = fileName;
    }
    return self;
}


@end


