//
//  PivotEntry.m
//  iKea Shopping List
//
//  Created by Wael Showair on 2015-12-17.
//  Copyright © 2015 showair.wael@gmail.com. All rights reserved.
//

#import "PivotEntry.h"

@implementation PivotEntry
- (instancetype)initWithAisleNum: (NSUInteger) number
                   PhysicalIndex: (NSInteger)  index
{
  self = [super init];
  if (self) {
    self.aisleNum   = number;
    self.aisleIndex = index;
  }
  return self;
}

@end