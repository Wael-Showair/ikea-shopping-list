//
//  CameraViewController.m
//  iKea Shopping List
//
//  Created by Wael Showair on 2016-01-07.
//  Copyright © 2016 showair.wael@gmail.com. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "CameraViewController.h"

@interface CameraViewController ()
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@end

@implementation CameraViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationBar.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIBarPosition)positionForBar:(id<UIBarPositioning>)bar{
  return UIBarPositionTopAttached;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
