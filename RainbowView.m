//
//  RainbowView.m
//  Quilters_App
//
//  Created by Dan Selig on 08/17/2013.
//  Copyright (c) 2013 Dan Selig. All rights reserved.
//

#import "RainbowView.h"

@interface RainbowView ()

@end


@implementation RainbowView

- (void) drawRainbow
{
    CGRect rect = self.bounds;
    
    CGBitmapInfo bitmapInfo = (CGBitmapInfo) kCGImageAlphaNoneSkipLast;
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    size_t components = 4;
    size_t bitsPerComponent = 8;
    int iwidth = rect.size.width;
    CGFloat fwidth = iwidth;
    size_t dotsPerRow = iwidth;
    size_t numRows = rect.size.height;
    size_t bytesPerRow = dotsPerRow * components;
    
    NSUInteger setSize = iwidth * numRows * components;
    UInt8 *colorSet = (UInt8 *)malloc(setSize * sizeof(UInt8));
    int csIndex = 0;
    
    CGFloat hue;
    CGFloat saturation;
    CGFloat brightness = 1.0;

    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
    
    for(int pixnum=0; pixnum<iwidth*numRows; pixnum++)
    {
        hue = (pixnum%iwidth)/fwidth;
        saturation = 1.0 - (pixnum/iwidth)/(CGFloat)numRows;
        UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1.0];
        [color getRed:&red green:&green blue:&blue alpha:&alpha];
        colorSet[csIndex] = red * 255;
        colorSet[csIndex+1] = green * 255;
        colorSet[csIndex+2] = blue * 255;
        csIndex += 4;
    }
    
    CGContextRef bimage
    = CGBitmapContextCreate(colorSet, dotsPerRow, numRows, bitsPerComponent,
                            bytesPerRow, colorspace, bitmapInfo);
    
    CGColorSpaceRelease(colorspace);
    
    CGImageRef imageRef = CGBitmapContextCreateImage(bimage);
    CGContextRelease(bimage);
    free(colorSet);

    self.image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
}

@end
