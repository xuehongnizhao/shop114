//
//  SkyNumberButton.h
//  CityO2OMerchant
//
//  Created by Sky on 15/3/9.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SkyNumberButton : UIButton


/**
 *  Class Methods:  set button unselectBackgroundColor  and selectBackgroundColor
 *
 *  @param backgroundColor  unselectColor
 *  @param highlightedColor selectColor
 *
 *  @return customButton
 */
+ (instancetype)buttonWithBackgroundColor:(UIColor *)backgroundColor highlightedColor:(UIColor *)highlightedColor;


/**
 *   Instance Methods: set button unselectBackgroundColor and selectBackgroundColor
 *
 *  @param backgroundColor  unselectColor
 *  @param highlightedColor selectColor
 *
 *  @return customButton
 */
- (instancetype)initWithBackgroundColor:(UIColor *)backgroundColor highlightedColor:(UIColor *)highlightedColor;


/**
 *  touches cancelled
 *
 *  @param touches which touches
 *  @param event   any event
 */
- (void)distinguish_touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;


@end
