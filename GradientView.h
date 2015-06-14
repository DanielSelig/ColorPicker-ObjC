//
//  GradientView.h
//  Quilters_App
//
//  Created by Dan Selig on 08/17/2013.
//  Copyright (c) 2013 Dan Selig. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GradientView : UIView

@property (strong, nonatomic) UIColor *color;
- (void) drawGradient;

@end
