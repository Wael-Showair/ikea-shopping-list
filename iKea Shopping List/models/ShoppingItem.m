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
  return  [self initWithName:itemName price:itemPrice image:@""];

}

-(instancetype) initWithName:(NSString*) itemName
                       price:(NSDecimalNumber*) itemPrice
                       image:(NSString*) fileName
{
  return [self initWithName:itemName
                      price:itemPrice
                      image:fileName
                aisleNumber:0
                  binNumber:0
              articleNumber:@""
                   quantity:0];
}

-(instancetype) initWithName:(NSString*) itemName
                       price:(NSDecimalNumber*) itemPrice
                       image:(NSString*) fileName
                 aisleNumber:(NSUInteger) aisleNumber
{
  return [self initWithName:itemName
                      price:itemPrice
                      image:fileName
                aisleNumber:aisleNumber
                  binNumber:0
              articleNumber:@""
                   quantity:0];

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
    self.name = itemName;
    self.price = itemPrice;
    self.imageName = fileName;
    self.aisleNumber = aisleNumber;
    self.binNumber = binNumber;
    self.articleNumber = articleNumber;
    self.quantity = qunatity;
  }
  return self;
}

@end


