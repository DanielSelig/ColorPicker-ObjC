//
//  ColorPickerViewController.h
//  HeatMap SDK
//
//  Created by Dan Selig on 08/17/2013.
//  Copyright (c) 2013 Dan Selig. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ColorPickerViewController;

@protocol ColorPickerDelegate <NSObject>

- (void) colorPickerViewController:(ColorPickerViewController *)colorPickerViewController didPickColor:(UIColor *)color;

@end

@interface ColorPickerViewController : UIViewController

@property (nonatomic, weak) id<ColorPickerDelegate>delegate;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) NSString *prompt;

@end
