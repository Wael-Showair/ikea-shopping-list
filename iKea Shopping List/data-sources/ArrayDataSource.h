//
//  ListsDataSource.h
//  iKea Shopping List
//
//  Created by Wael Showair on 2015-11-04.
//  Copyright © 2015 show0017@algonquinlive.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArrayDataSource : NSObject <UITableViewDataSource>

typedef void (^TableViewCellConfigureBlock)(id cell, id item);

- (instancetype)initWithItems:(NSMutableArray *)items
     cellIdentifier:(NSString *)cellIdentifier
 configureCellBlock:(TableViewCellConfigureBlock)configureCellBlock;

- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

@end
