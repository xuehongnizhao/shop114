//
//  SkyKeyboardDefaultStyle.m
//  CityO2OMerchant
//
//  Created by Sky on 15/3/10.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "SkyKeyboardDefaultStyle.h"


static inline UIColor * Sky_RGBA(int r, int g, int b, CGFloat alpha)
{
    return [UIColor colorWithRed:r / 255.f
                           green:g / 255.f
                            blue:b / 255.f
                           alpha:alpha];
}

@implementation SkyKeyboardDefaultStyle


#pragma mark - Pad

+ (CGRect)numberPadFrame
{
    CGFloat keyboardHeight=300.f;
    CGFloat keyboarWidth=SCREEN_WIDTH;
    CGFloat keyboardY=SCREEN_HEIGHT-50-keyboardHeight;
    CGFloat keyboardX=0.f;
    return CGRectMake(keyboardX,keyboardY, keyboarWidth, keyboardHeight);
}

+ (CGFloat)separator {
    return [UIScreen mainScreen].scale == 2.f ? 0.5f : 1.f;
}

+ (UIColor *)numberPadBackgroundColor {
    return Sky_RGBA(183, 186, 191, 1.f);
}

#pragma mark - Number button

+ (UIFont *)numberButtonFont {
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:28.f];
}

+ (UIColor *)numberButtonTextColor {
    return [UIColor blackColor];
}

+ (UIColor *)numberButtonBackgroundColor {
    return Sky_RGBA(252, 252, 252, 1.f);
}

+ (UIColor *)numberButtonHighlightedColor {
    return Sky_RGBA(188, 192, 198, 1.f);
}

#pragma mark - Function button

+ (UIFont *)functionButtonFont {
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:28.f];
}

+ (UIColor *)functionButtonTextColor {
    return [UIColor whiteColor];
}

+ (UIColor *)functionButtonBackgroundColor {
    return Sky_RGBA(218, 51, 64, 1.f);
}

+ (UIColor *)functionButtonHighlightedColor {
    return Sky_RGBA(252, 252, 252, 1.f);
}

+ (UIImage *)clearFunctionButtonImage {
    return [UIImage imageNamed:@"APNumberPad.bundle/images/apnumberpad_backspace_icon.png"];
}


@end
