//
//  ListsDataSource.h
//  iKea Shopping List
//
//  Created by Wael Showair on 2015-11-04.
//  Copyright © 2015 show0017@algonquinlive.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ListsDataSource : NSObject <UITableViewDataSource>

- (instancetype)initWithItems:(NSMutableArray *)items;
- (id)itemAtIndexPath:(NSIndexPath *)indexPath;
- (void)insertObject:(id)object AtIndex:(NSUInteger)indexPath;

@end
