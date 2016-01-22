//
//  TextInputTableViewCell.h
//  iKea Shopping List
//
//  Created by Wael Showair on 2015-11-08.
//  Copyright © 2015 showair.wael@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextInputCell : UICollectionViewCell
#define NEW_LIST_INFO_CELL_ID   @"new-list-info-cell"
@property (weak, nonatomic) IBOutlet UITextField *inputText;

@end
