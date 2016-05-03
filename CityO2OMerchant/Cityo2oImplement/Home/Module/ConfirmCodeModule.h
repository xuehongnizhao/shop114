//
//  ConfirmCodeModule.h
//  CityO2OMerchant
//
//  Created by Sky on 15/3/10.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConfirmCodeModule : NSObject

/**
 *  消费码
 */
@property(nonatomic,strong)NSString* pass;

/**
 *  产品名称
 */
@property(nonatomic,strong)NSString* product_name;

/**
 *  产品价格
 */
@property(nonatomic,strong)NSString* product_price;

/**
 *  产品类型
 */
@property(nonatomic,strong)NSString* type;

@end
