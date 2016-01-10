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
@property (strong, nonatomic) CIDetector* rectDetector;
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
  
  /* Setup detector for rectangular areas in an image. */
  CIContext *context = [CIContext contextWithOptions:nil];
  NSDictionary *opts = @{ CIDetectorAccuracy : CIDetectorAccuracyHigh,
                          CIDetectorAspectRatio: @2.0};
  self.rectDetector = [CIDetector detectorOfType:CIDetectorTypeRectangle
                                            context:context
                                            options:opts];
  
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
  UIImage* srcImage = [self imageFromSampleBuffer:sampleBuffer];
  /* May be need to use some sort of notification technique here instead of direct function call. */
  [self handleImageCaptured: srcImage];
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didDropSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
  
  self.i++;
}

// Create a CIImage from sample buffer data. source: https://goo.gl/BXqx8p
- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer{

    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
//    CVPixelBufferLockBaseAddress(imageBuffer, 0);
  
    // Get the base address for the pixel buffer
//    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
  
//    // Get the number of bytes per row for the pixel buffer
//    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
//    // Get the pixel buffer width and height
//    size_t width = CVPixelBufferGetWidth(imageBuffer);
//    size_t height = CVPixelBufferGetHeight(imageBuffer);
//    
//    // Create a device-dependent RGB color space
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    
//    // Create a bitmap graphics context with the sample buffer data
//    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
//                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
//    // Create a Quartz image from the pixel data in the bitmap graphics context
//    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // Unlock the pixel buffer
//    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
//    
//    // Free up the context and color space
//    CGContextRelease(context);
//    CGColorSpaceRelease(colorSpace);
//    
//    // Create an image object from the Quartz image
//    UIImage *image = [UIImage imageWithCGImage:quartzImage];
//    
//    // Release the Quartz image
//    CGImageRelease(quartzImage);
  CIImage* ciimage = [CIImage imageWithCVImageBuffer:imageBuffer];
  UIImage* image = [UIImage imageWithCIImage:ciimage];
    return image;
}

-(void) handleImageCaptured: (UIImage *) srcImage{
  CIImage* mm = srcImage.CIImage;
  ;
  //CIImage* nn = (__bridge CIImage*) mm;
  NSArray<CIFeature*> *features = [self.rectDetector featuresInImage:mm];
  
  NSLog(@"number of detected rects is = %ld", features.count);
  /* the rectangle detector will only ever detect one rectangle in an image, so the features array will have either exactly one or zero CIRectangleFeature objects in it.*/
//  for (CIRectangleFeature* feature in features) {
//    /* Do Something.*/
//    NSLog(@"%@", NSStringFromCGRect(feature.bounds));
//  }
}

@end
