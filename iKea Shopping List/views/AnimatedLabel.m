//
//  CustomLabel.m
//  text_animation
//
//  Created by Wael Showair on 2016-01-28.
//  Copyright © 2016 showairovic@gmail.com. All rights reserved.
//

#import "AnimatedLabel.h"

@interface AnimatedLabel ()
@property NSTextStorage* textStorage;
@property NSTextContainer* textContainer;
@property NSLayoutManager* layoutManager;
@property NSMutableArray<CATextLayer*>* textLayers;
@end

@implementation AnimatedLabel

-(void) setup{

  /* Default UILabel does not have internal textStorage, textContainer & text LayoutManager.
   * Create ones. */
  self.textStorage = [[NSTextStorage alloc] init];
  self.textContainer = [[NSTextContainer alloc] init];
  self.layoutManager = [[NSLayoutManager alloc] init];
  
  [self.layoutManager addTextContainer:self.textContainer];
  [self.textStorage addLayoutManager:self.layoutManager];
  
  /* Set the Label class as the delegate of the layoutManager. */
  self.layoutManager.delegate = self;
  
  /* Create mutable array to hold CATextLayers objects. */
  self.textLayers = [[NSMutableArray alloc] init];
}

-(instancetype)initWithFrame:(CGRect)frame{
  self = [super initWithFrame:frame];
  if (self) {
    [self setup];
  }
  return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self setup];
  }
  return self;
}

-(void)setAttributedText:(NSAttributedString *)attributedText{
  if([self.textStorage.string isEqualToString:attributedText.string]){
    return;
  }else{
    
    /* Setting the textStorage will trigger layout manager to convert the characters into glyphs
     * then draw the glyphs into the text container bounds rectangle. */
    [self.textStorage setAttributedString:attributedText];
    
    [super setAttributedText:attributedText];
  }
}

-(void)setText:(NSString *)text{
  
  if([self.textStorage.string isEqualToString:text]){
    return;
  }else{
//    [super setText:text];
    
    /* Make sure to init the setting of attributed text with the current settings of the label.
     * Accordingly, the textStorage will be updated hence the layout manager will lay out the glyphs.*/
    
    /* Get current attributes in the UILabel object. */
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = self.textAlignment;
    
    NSDictionary* attributes = @{NSFontAttributeName:self.font,
                                 NSParagraphStyleAttributeName: paragraphStyle,
                                 NSForegroundColorAttributeName: self.textColor};
    
    NSAttributedString* attributedText = [[NSAttributedString alloc]
                                          initWithString:text attributes:attributes];
    
    /* Update the attributedText to set the textStorage object. */
    [self setAttributedText:attributedText];
  }
  
}

- (void)setBounds:(CGRect)bounds
{
  self.textContainer.size = bounds.size;
  super.bounds = bounds;
}

- (void)setFrame:(CGRect)frame
{
  self.textContainer.size = frame.size;
  super.frame = frame;
}

- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode
{
  self.textContainer.lineBreakMode = lineBreakMode;
}

- (void)setNumberOfLines:(NSInteger)numberOfLines
{
  self.textContainer.maximumNumberOfLines = numberOfLines;
}

-(void)drawTextInRect:(CGRect)rect{

  CFTimeInterval delay = 0.0;

  for (NSUInteger i = 0; i < self.textLayers.count; i++) {
    CATextLayer* glyphLayer = self.textLayers[i];

    /* Exciplit animation to fade in every letter.
     * At the end of the animation, Core Animation removes the animation object from the layer and
     * redraws the layer using its current data values.*/
    CABasicAnimation* fadeAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnim.fromValue = [NSNumber numberWithFloat:0.0 ];
    fadeAnim.toValue = [NSNumber numberWithFloat:1.0];
    fadeAnim.duration = 1.0;
    fadeAnim.timeOffset = delay;

    delay += 0.05;

    [glyphLayer addAnimation:fadeAnim forKey:@"opacity"];
    glyphLayer.opacity = 1.0;

  }

}

-(void)layoutManager:(NSLayoutManager *)layoutManager didCompleteLayoutForTextContainer:(NSTextContainer *)textContainer atEnd:(BOOL)layoutFinishedFlag{
  
    if(self.textStorage.length > 0){
      [self.textLayers removeAllObjects];
      CGRect textContainerRect = [layoutManager usedRectForTextContainer:textContainer];

      NSRange glyphFullRange = [layoutManager glyphRangeForTextContainer:textContainer];
      
      for (NSUInteger glyphIndex = glyphFullRange.location; glyphIndex < glyphFullRange.length+glyphFullRange.location; glyphIndex +=0) {
  
        NSRange glyphRange = NSMakeRange(glyphIndex, 1);
        NSRange actualGlyphRange;
        // Convert those coordinates to the nearest glyph index
        NSRange characterRange = [layoutManager characterRangeForGlyphRange:glyphRange actualGlyphRange:&actualGlyphRange];
  
  
        //Get Bounding Glyph Rect
        CGRect glyphRect = [layoutManager boundingRectForGlyphRange:glyphRange inTextContainer:textContainer];

        glyphRect.origin.y += CGRectGetMidY(self.bounds) - CGRectGetMidY(textContainerRect);
        //glyphRect.origin.y = CGRectGetMidY(self.bounds) + lineFragmentRect.origin.y - glyphPoint.y;
  
        //Create the new text layer
        CATextLayer *textLayer = [CATextLayer layer];
        textLayer.contentsScale = [[UIScreen mainScreen] scale];
        textLayer.frame = glyphRect;
  
        textLayer.string = [self.textStorage attributedSubstringFromRange:characterRange];
        textLayer.opacity = 0.0;
        
        [self.textLayers addObject:textLayer];
        
        //add new text layer to heirarchy
        [self.layer addSublayer:textLayer];
  
        //Step the number of actual covered glyphs.
        glyphIndex += actualGlyphRange.length;
        
      }
    }
  NSLog(@"inside delege layoutManager didFinishLayout");
}



@end
