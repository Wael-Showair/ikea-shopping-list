//
//  CameraViewController.m
//  iKea Shopping List
//
//  Created by Wael Showair on 2016-01-07.
//  Copyright © 2016 showair.wael@gmail.com. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "CameraViewController.h"
#import "DetectionAreaOverlayView.h"

@interface CameraViewController ()
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UIView *cameraPreview;
@property (weak, nonatomic) IBOutlet UIView *toolbar;
@property (strong, nonatomic) AVCaptureSession* session;
@property (strong, nonatomic) dispatch_queue_t sessionQueue;
@property int i;
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
  
  /* Add Capture output for preview frames before before presenting them to the user to add detection area */
  AVCaptureVideoDataOutput* cameraCaptureOuput = [[AVCaptureVideoDataOutput alloc] init];
  cameraCaptureOuput.videoSettings = @{ (NSString *)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA) };
  cameraCaptureOuput.alwaysDiscardsLateVideoFrames = YES;
  [cameraCaptureOuput setSampleBufferDelegate:self queue:self.sessionQueue];
  [self.session addOutput:cameraCaptureOuput];
  
  [self.session startRunning];
  
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated{
  /* Note that the exact sizes of all views are set after triggering this method i.e. after
   * appearence of the view into the window. */
  
  /* Show the user what the camera is actually seeing. */
  AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
  captureVideoPreviewLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
  captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
  /* This is the line that forces me to do all of this stuff here in this method because bounds are
   * set properly. Note that if use viewDidLoad instead, the bounds will be equal to the neutral
   * values of the width and the height that are set in Interface builder (600, 472) in this case.*/
  captureVideoPreviewLayer.frame = self.cameraPreview.bounds;
  [self.cameraPreview.layer addSublayer:captureVideoPreviewLayer];
  
  /* Create overlay on top of camera preview. */
  DetectionAreaOverlayView* overlay = [[DetectionAreaOverlayView alloc] initWithFrame:captureVideoPreviewLayer.bounds];
  
  [self.cameraPreview addSubview:overlay];
}

-(void)viewDidDisappear:(BOOL)animated{
    NSLog(@"%i", self.i);
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

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
  //NSLog(@"%s", __PRETTY_FUNCTION__);
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didDropSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
  
  self.i++;
}
@end
