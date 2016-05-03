//
//  SkyKeyboardStyle.h
//  CityO2OMerchant
//
//  Created by Sky on 15/3/9.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SkyKeyboardStyle <NSObject>

+ (CGRect)numberPadFrame;
+ (CGFloat)separator;
+ (UIColor *)numberPadBackgroundColor;

+ (UIFont *)numberButtonFont;
+ (UIColor *)numberButtonBackgroundColor;
+ (UIColor *)numberButtonHighlightedColor;
+ (UIColor *)numberButtonTextColor;

+ (UIFont *)functionButtonFont;
+ (UIColor *)functionButtonBackgroundColor;
+ (UIColor *)functionButtonHighlightedColor;
+ (UIColor *)functionButtonTextColor;
+ (UIImage *)clearFunctionButtonImage;

@end
