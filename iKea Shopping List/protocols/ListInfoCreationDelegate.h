//
//  ListInfoCreationDelegate.h
//  iKea Shopping List
//
//  Created by Wael Showair on 2015-11-08.
//  Copyright © 2015 showair.wael@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ListInfoCreationDelegate <NSObject>

@required
-(void) listInfoDidCreatedWithTitle: (NSString*)title;
@end
