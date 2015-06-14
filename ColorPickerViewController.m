//
//  ColorPickerViewController.m
//  HeatMap SDK
//
//  Created by Dan Selig on 08/17/2013.
//  Copyright (c) 2013 Dan Selig. All rights reserved.
//

#import "ColorPickerViewController.h"
#import "GradientView.h"
#import "RainbowView.h"

@interface ColorPickerViewController ()

@property (weak, nonatomic) IBOutlet UILabel *promptLabel;

@property (weak, nonatomic) IBOutlet RainbowView *rainbowView;
@property (weak, nonatomic) IBOutlet GradientView *gradientView;
@property (weak, nonatomic) IBOutlet UIView *colorView;

@property (strong, nonatomic) UIImageView *crossHairs;
@property (strong, nonatomic) UIImageView *brightnessBar;

@end


@implementation ColorPickerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	self.crossHairs = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"crosshair.png"]];
	[self.rainbowView addSubview:self.crossHairs];
	
	self.brightnessBar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bar_select.png"]];
	[self.gradientView addSubview:self.brightnessBar];
    
    self.promptLabel.text = self.prompt;
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.rainbowView drawRainbow];
    [self resetCrosshairs];
    [self resetGradientIndicator];
    [self.gradientView drawGradient];
    self.colorView.backgroundColor = self.color;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.delegate colorPickerViewController:self didPickColor:self.color];
}

- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         NULL;
     }
                                 completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         [self.rainbowView drawRainbow];
         [self resetCrosshairs];
         [self resetGradientIndicator];
         [self.gradientView drawGradient];
     }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

- (IBAction) handleRainbowTap:(UITapGestureRecognizer *)gestureRecognizer
{
	CGPoint tapPoint = [gestureRecognizer locationInView:gestureRecognizer.view];
	[self setCrosshairsCenter:tapPoint];
	[self updateHueSatWithMovement:tapPoint];
}

- (IBAction) handleRainbowPan:(UIPanGestureRecognizer *)gestureRecognizer
{
	if(gestureRecognizer.state == UIGestureRecognizerStateBegan)
	{
        CGPoint tapPoint = [gestureRecognizer locationInView:gestureRecognizer.view];
		[self setCrosshairsCenter:tapPoint];
		[self updateHueSatWithMovement:tapPoint];
	}
	
	else if( gestureRecognizer.state == UIGestureRecognizerStateChanged)
	{
		CGPoint center = [self getCrosshairsCenter];
		CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
		center.x += translation.x;
		center.y += translation.y;
        
		[self setCrosshairsCenter:center];
		[self updateHueSatWithMovement:center];
		
		[gestureRecognizer setTranslation:CGPointZero
								   inView:gestureRecognizer.view];
	}
}

- (IBAction) handleGradientTap:(UITapGestureRecognizer *)gestureRecognizer
{
	CGPoint tapPoint = [gestureRecognizer locationInView:gestureRecognizer.view];
	CGPoint center = self.brightnessBar.center;
	center.x = tapPoint.x;
	self.brightnessBar.center = center;
	
	[self updateBrightnessWithMovement:tapPoint];
}

- (IBAction) handleGradientPan:(UIPanGestureRecognizer *)gestureRecognizer
{
	if(gestureRecognizer.state == UIGestureRecognizerStateBegan)
	{
		CGPoint tapPoint = [gestureRecognizer locationInView:gestureRecognizer.view];
		CGPoint center = self.brightnessBar.center;
		center.x = tapPoint.x;
		self.brightnessBar.center = center;
		
		[self updateBrightnessWithMovement:center];
	}
	else if( gestureRecognizer.state == UIGestureRecognizerStateChanged)
	{
		CGPoint center = self.brightnessBar.center;
		CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
		center.x += translation.x;
		
		[self setBrightnessBarCenter:center];
		[self updateBrightnessWithMovement:center];
		[gestureRecognizer setTranslation:CGPointZero
								   inView:gestureRecognizer.view];
	}
}

- (void) updateHueSatWithMovement:(CGPoint)position
{
    if(CGRectContainsPoint(self.rainbowView.bounds, position))
    {
        CGFloat hue = position.x/self.rainbowView.bounds.size.width;
        CGFloat saturation = 1.0 - position.y/self.rainbowView.bounds.size.height;
        CGFloat brightness = 1.0 - self.brightnessBar.center.x/self.gradientView.bounds.size.width;
		
        self.color = [UIColor colorWithHue:hue
							saturation:saturation
							brightness:brightness alpha:1.0];
		
        self.gradientView.color = self.color;
        [self.gradientView setNeedsDisplay];
    }
}

- (void) updateBrightnessWithMovement:(CGPoint)position
{
    if(CGRectContainsPoint(self.gradientView.bounds, position))
	{
        CGFloat hue;
        CGFloat saturation;
        CGFloat brightness;
        CGFloat alpha;
        [self.color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
        
        brightness = 1.0-(position.x/self.gradientView.frame.size.width);
        
        self.color = [UIColor colorWithHue:hue
							saturation:saturation
							brightness:brightness alpha:1.0];
		
        self.gradientView.color = self.color;
        [self.gradientView setNeedsDisplay];
    }
}

- (void) setCrosshairsCenter:(CGPoint)center
{
	if (CGRectContainsPoint(self.rainbowView.bounds, center))
	{
		self.crossHairs.center = center;
	}
}

- (CGPoint) getCrosshairsCenter
{
	return self.crossHairs.center;
}

- (void) setColor:(UIColor *)color
{
    _color = color;
    self.colorView.backgroundColor = color;
}

- (void) setBrightnessBarCenter:(CGPoint)center
{
	if (CGRectContainsPoint(self.gradientView.bounds, center))
	{
		self.brightnessBar.center = center;
	}
}

- (CGPoint) getBrightnessBarCenter
{
	return self.brightnessBar.center;
}

- (void) resetCrosshairs
{
    CGFloat hue;
    CGFloat saturation;
    CGFloat brightness;
    CGFloat alpha;
    [self.color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
	self.crossHairs.center = CGPointMake(hue*self.rainbowView.bounds.size.width, (1.0 - saturation)*self.rainbowView.bounds.size.height);
}

- (void) resetGradientIndicator
{
    CGFloat hue;
    CGFloat saturation;
    CGFloat brightness;
    CGFloat alpha;
    [self.color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
	self.brightnessBar.center = CGPointMake(self.gradientView.frame.size.width * (1.0-brightness), self.brightnessBar.center.y);
    
    [self.gradientView setColor:self.color];
    [self.gradientView setNeedsDisplay];
}

@end
