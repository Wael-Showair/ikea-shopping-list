//
//  UITextField+Additions.h
//  iKea Shopping List
//
//  Created by Wael Showair on 2015-12-06.
//  Copyright © 2015 showair.wael@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Additions)
-(void) displayErrorIndicators;
-(void) removeErrorIndicators;
-(void) displayErrorMessage: (NSString*) message;
-(void) removeErrorMessage;
@end
