//
//  SaleHeadView.h
//  CityO2OMerchant
//
//  Created by Sky on 15/3/19.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SaleHeadView : UIView


/**
 *  显示订单总数和订单总金额
 *
 *  @param num        订单总数
 *  @param totalPrice 订单总金额
 */
-(void)setNumberOfOrder:(NSString*) num andTotalPrice:(NSString*) totalPrice;

@end
