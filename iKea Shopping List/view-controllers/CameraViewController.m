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
@property (weak, nonatomic) IBOutlet UIView *cameraPreview;
@property (weak, nonatomic) IBOutlet UIView *toolbar;
@property (strong, nonatomic) AVCaptureSession* session;
@property (strong, nonatomic) dispatch_queue_t sessionQueue;
@end

@implementation CameraViewController

- (void)viewDidLoad {
  
  [super viewDidLoad];
  
  NSError *error = nil;
  
  self.toolbar.layer.zPosition = 2.0;
  
  self.navigationBar.delegate = self;
  
  // Create the AVCaptureSession.
  self.session = [[AVCaptureSession alloc] init];
  
  // Communicate with the session and other session objects on this queue.
  self.sessionQueue = dispatch_queue_create( "camera session queue", DISPATCH_QUEUE_SERIAL );


  // Set quality level or the output
  [self.session setSessionPreset:AVCaptureSessionPresetHigh];
  
  //Get a reference to back camera (capture device).
  AVCaptureDevice *camera = [CameraViewController deviceWithMediaType:AVMediaTypeVideo
                                                        preferringPosition:AVCaptureDevicePositionBack];
  /* Create capture input that is inialized to the back camera*/
  AVCaptureDeviceInput *cameraCaptureInput = [AVCaptureDeviceInput deviceInputWithDevice:camera error:&error];
  
  /* Add input capture to the session. */
  [self.session addInput:cameraCaptureInput];
  
  /* create capture outupt of type still Image. */
  AVCaptureStillImageOutput *stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
  stillImageOutput.outputSettings = @{AVVideoCodecKey : AVVideoCodecJPEG};
  [self.session addOutput:stillImageOutput];
  
  /* Show the user what the camera is actually seeing. */
  AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
  captureVideoPreviewLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
  captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
  captureVideoPreviewLayer.frame = self.cameraPreview.bounds;
  [self.cameraPreview.layer addSublayer:captureVideoPreviewLayer];
  [self.session startRunning];
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

+ (AVCaptureDevice *)deviceWithMediaType:(NSString *)mediaType preferringPosition:(AVCaptureDevicePosition)position
{
  NSArray *devices = [AVCaptureDevice devicesWithMediaType:mediaType];
  AVCaptureDevice *captureDevice = devices.firstObject;
  
  for ( AVCaptureDevice *device in devices ) {
    if ( device.position == position ) {
      captureDevice = device;
      break;
    }
  }
  
  return captureDevice;
}
@end
