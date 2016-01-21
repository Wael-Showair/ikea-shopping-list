//
//  ShoppingListCell.h
//  iKea Shopping List
//
//  Created by Wael Showair on 2016-01-17.
//  Copyright © 2016 showair.wael@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingListCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@end
