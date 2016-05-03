//
//  SkyKeyboard.h
//  CityO2OMerchant
//
//  Created by Sky on 15/3/9.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkyKeyboardStyle.h"

@protocol SkyKeyboardDelegate;

@interface SkyKeyboard : UIView<UIInputViewAudioFeedback>


/**
 *  Left function button for custom configuration
 */
@property (strong, readonly, nonatomic) UIButton *leftFunctionButton;


/**
 *  Right function button for custom configuration
 */
@property (strong, readonly, nonatomic) UIButton *rightFunctionButton;

/**
 *  The class to use for styling the number keyboard
 */
@property (strong, readonly, nonatomic) Class<SkyKeyboardStyle> styleClass;



/**
 *  Class Methods: set delegate and styleClass
 *
 *  @param delegate   set delegate
 *  @param styleClass set style
 *
 *  @return keyboard
 */
+ (instancetype)keyboardWithDelegate:(id<SkyKeyboardDelegate>)delegate keyboardStyleClass:(Class)styleClass;

/**
 *  Class Methods: set keyboard without delegate
 *
 *  @param delegate set delegate
 *
 *  @return return keyboard
 */
+ (instancetype)keyboardWithDelegate:(id<SkyKeyboardDelegate>)delegate;

@end




@protocol SkyKeyboardDelegate <NSObject>

@optional

/**
 *  keyboardDelegate about which functionButton clicked  and input with number
 *
 *  @param keyboard       instance object :Skykeyboard
 *  @param functionButton leftFunctionButton or rightFunctionButton
 *  @param textInput      input button
 */
- (void)keyboard:(SkyKeyboard *)keyboard functionButtonAction:(UIButton *)functionButton textInput:(UIResponder<UITextInput> *)textInput;


@end
