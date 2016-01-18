//
//  UIImage+Overlay.m
//  iKea Shopping List
//
//  Created by Wael Showair on 2016-01-18.
//  Copyright © 2016 showair.wael@gmail.com. All rights reserved.
//

#import "UIImage+Overlay.h"

@implementation UIImage (Overlay)

-(UIImage*) imageWithColorOverlay:(UIColor*) color{
  CIImage* ciimage = self.CIImage;
  
  if(nil == ciimage){
    ciimage = [CIImage imageWithCGImage:self.CGImage];
  }
  
  CIColor* coreImageColor = [CIColor colorWithCGColor:color.CGColor];
  
  /* This is an infinity color space image, needs to be cropped to the size of the background image*/
  CIImage* overlayImage = [CIFilter filterWithName:@"CIConstantColorGenerator" keysAndValues:@"inputColor",coreImageColor, nil].outputImage;
//  NSLog(@"Width = %f  -  Height = %f",self.size.width, self.size.height)
  overlayImage = [CIFilter filterWithName:@"CICrop" keysAndValues:kCIInputImageKey,overlayImage,
                  @"inputRectangle",[CIVector vectorWithCGRect:CGRectMake(0, 0, self.size.width, self.size.height)], nil].outputImage;
  
  /* Draw the overlayImage over the original input image.*/
  ciimage = [overlayImage imageByCompositingOverImage:ciimage];
  return [UIImage imageWithCIImage:ciimage];
}

@end
