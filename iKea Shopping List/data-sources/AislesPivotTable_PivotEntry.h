//
//  AislesPivotTable_PivotEntry.h
//  iKea Shopping List
//
//  Created by Wael Showair on 2015-11-23.
//  Copyright © 2015 showair.wael@gmail.com. All rights reserved.
//

/* Note that this extension is created so that the PivotEntry class is
 * private to PivotTable class and in the same time is still accessible from
 * testing class AislesPivotTableTests */
#import "AislesPivotTable.h"

@interface PivotEntry : NSObject
@property NSInteger aisleIndex;
@property NSUInteger aisleNum;
@end

@interface AislesPivotTable ()

@end
