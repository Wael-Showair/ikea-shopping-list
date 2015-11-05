/*!
 *  @header TwoSidedDoorAnimator.h
 *  interface file that provides all the needed operations for animation 
 *  controller that visualize any view as opened or closed two sided door.
 *
 *  @author Wael Showair (showair.wael\@gmail.com)
 *  @version 0.0.1
 *  @copyright 2015. Wael Showair. All rights reserved.
 */

#import <UIKit/UIKit.h>


@interface TwoSidedDoorAnimator : NSObject
    <UIViewControllerAnimatedTransitioning>
/*!
 *  @property isReversed
 *  @abstract boolean flag to indicate whether the animation should take place 
 *  forward or backward. Forward animation consists of rotate the two sided door
 *  to open then the inner object scales up. On the other hand, Backward 
 *  animation is the reversed one where the inner object scales down then the 
 *  two sided door is rotate to close.
 */
@property BOOL isReversed;
@end
