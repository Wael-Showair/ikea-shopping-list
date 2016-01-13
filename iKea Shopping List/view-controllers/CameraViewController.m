//
//  CameraViewController.m
//  iKea Shopping List
//
//  Created by Wael Showair on 2016-01-07.
//  Copyright © 2016 showair.wael@gmail.com. All rights reserved.
//

@import GLKit;

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

@property (strong, nonatomic) GLKView* liveGLKView;
@property (strong, nonatomic) CIContext* renderContext;
@property CGRect liveGLKViewBoundsInPixels;

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
//  AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
//  captureVideoPreviewLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
//  captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
  /* This is the line that forces me to do all of this stuff here in this method because bounds are
   * set properly. Note that if use viewDidLoad instead, the bounds will be equal to the neutral
   * values of the width and the height that are set in Interface builder (600, 472) in this case.*/
//  captureVideoPreviewLayer.frame = self.cameraPreview.bounds;
//  [self.cameraPreview.layer addSublayer:captureVideoPreviewLayer];
  
  /* Create overlay on top of camera preview. */
//  DetectionAreaOverlayView* overlay = [[DetectionAreaOverlayView alloc] initWithFrame:captureVideoPreviewLayer.bounds];
  
//  [self.cameraPreview addSubview:overlay];
  
  // setup the GLKView for video/image preview
  EAGLContext* eagleContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
  self.liveGLKView = [[GLKView alloc] initWithFrame:self.cameraPreview.bounds context: eagleContext];
  self.liveGLKView.enableSetNeedsDisplay = NO;
  
  /* because the native video image from the back camera is in UIDeviceOrientationLandscapeLeft
   * (i.e. the home button is on the right), we need to apply a clockwise 90 degree transform so that
   * we can draw the video preview as if we were in a landscape-oriented view;*/
  self.liveGLKView.transform = CGAffineTransformMakeRotation(M_PI_2);

  
  self.liveGLKView.frame = self.cameraPreview.bounds;
  [self.cameraPreview addSubview:self.liveGLKView];
  
  /* this makes FHViewController's view (and its UI elements) on top of the video preview, and also
   * makes video preview unaffected by device rotation*/
  [self.cameraPreview sendSubviewToBack:self.liveGLKView];

  // create the CIContext instance, note that this must be done after live preview is properly set up
  self.renderContext = [CIContext contextWithEAGLContext:eagleContext];
  
  // bind the frame buffer to get the frame buffer width and height;
  // the bounds used by CIContext when drawing to a GLKView are in pixels (not points),
  // hence the need to read from the frame buffer's width and height;
  // in addition, since we will be accessing the bounds in another queue (_captureSessionQueue),
  // we want to obtain this piece of information so that we won't be
  // accessing _videoPreviewView's properties from another thread/queue
  [self.liveGLKView bindDrawable];
  self.liveGLKViewBoundsInPixels = CGRectMake(0, 0, self.liveGLKView.drawableWidth, self.liveGLKView.drawableHeight);


  
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
   [self imageFromSampleBuffer:sampleBuffer];
  /* May be need to use some sort of notification technique here instead of direct function call. */
  //[self handleImageCaptured: srcImage];
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didDropSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
  
  self.i++;
}

// Create a CIImage from sample buffer data. source: https://goo.gl/BXqx8p
- (void) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer{

  // Get a CMSampleBuffer's Core pixel buffer from the sample buffer.
  CVPixelBufferRef imageBuffer = (CVPixelBufferRef) CMSampleBufferGetImageBuffer(sampleBuffer);
  
  // Create Core Image instance from the data contained inside the pixel buffer.
  CIImage* ciimage = [CIImage imageWithCVImageBuffer:imageBuffer];

  CGRect sourceExtent = ciimage.extent;
  
  CGFloat sourceAspect = sourceExtent.size.width / sourceExtent.size.height;
  CGFloat previewAspect = self.liveGLKViewBoundsInPixels.size.width  / self.liveGLKViewBoundsInPixels.size.height;
  
  // we want to maintain the aspect radio of the screen size, so we clip the video image
  CGRect drawRect = sourceExtent;
  if (sourceAspect > previewAspect)
  {
    // use full height of the video image, and center crop the width
    drawRect.origin.x += (drawRect.size.width - drawRect.size.height * previewAspect) / 2.0;
    drawRect.size.width = drawRect.size.height * previewAspect;
  }
  else
  {
    // use full width of the video image, and center crop the height
    drawRect.origin.y += (drawRect.size.height - drawRect.size.width / previewAspect) / 2.0;
    drawRect.size.height = drawRect.size.width / previewAspect;
  }
  
  //Render the core image instance into the EAGL Context.
  [self.renderContext drawImage:ciimage inRect:self.liveGLKViewBoundsInPixels fromRect:drawRect];
  
  //Display the rendered core image instance.
  [self.liveGLKView display];
  
//  UIImage* image = [UIImage imageWithCIImage:rotatedciimage];
//    return image;
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
