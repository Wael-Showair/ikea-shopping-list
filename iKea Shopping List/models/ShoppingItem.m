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
    self = [self initWithName:itemName
                        price:itemPrice
                        image:fileName
                  aisleNumber:0
                    binNumber:0
                articleNumber:@""
                     quantity:0];
    return self;
}

-(instancetype) initWithName:(NSString*) itemName
                       price:(NSDecimalNumber*) itemPrice
                       image:(NSString*) fileName
                 aisleNumber:(NSUInteger) aisleNumber
{
    self = [self initWithName:itemName
                        price:itemPrice
                        image:fileName
                  aisleNumber:aisleNumber
                    binNumber:0
                articleNumber:@""
                     quantity:0];
    return self;
}

- (instancetype)initWithName:(NSString *)itemName
                       price:(NSDecimalNumber *)itemPrice
                       image:(NSString *)fileName
                 aisleNumber:(NSUInteger)aisleNumber
                   binNumber:(NSUInteger)binNumber
               articleNumber:(NSString *)articleNumber
                    quantity:(NSUInteger)qunatity
{
    self = [super init];
    
    if(self){
        _name = itemName;
        _price = itemPrice;
        _imageName = fileName;
        _aisleNumber = aisleNumber;
        _binNumber = binNumber;
        _articleNumber = articleNumber;
        _quantity = qunatity;
    }
    return self;
}

@end


