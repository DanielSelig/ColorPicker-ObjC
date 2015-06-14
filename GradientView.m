//
//  GradientView.m
//  Quilters_App
//
//  Created by Dan Selig on 08/17/2013.
//  Copyright (c) 2013 Dan Selig. All rights reserved.
//

#import "GradientView.h"

@interface GradientView ()

@end

@implementation GradientView

- (void) drawGradient
{
    [self drawRect:self.bounds];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (! context) return;
    
	CGFloat colors[8];
    
    CGFloat hue;
    CGFloat saturation;
    CGFloat brightness;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
    [self.color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    brightness = 1.0;
    
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1.0];
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
	colors[0] = red;
	colors[1] = green;
	colors[2] = blue;
	colors[3] = 1.0;
	
    brightness = 0.1;
    color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1.0];
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
	colors[4] = red;
	colors[5] = green;
	colors[6] = blue;
	colors[7] = 1.0;
	
	CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
	
	CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, 2);
	CGColorSpaceRelease(rgb);
    
	CGPoint start = CGPointZero;
	CGPoint end = CGPointMake(self.bounds.size.width, 0);
	CGContextDrawLinearGradient(context, gradient, start, end, 0);
    
    CGGradientRelease(gradient);
}

@end
