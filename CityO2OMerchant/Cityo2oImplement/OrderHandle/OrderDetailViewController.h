//
//  OrderDetailViewController.h
//  CityO2OMerchant
//
//  Created by Sky on 15/3/12.
//  Copyright (c) 2015年 Sky. All rights reserved.
//
//  订单详情

#import "BaseViewController.h"
#import "OrderModule.h"

@interface OrderDetailViewController : BaseViewController

@property(nonatomic,strong)OrderModule* module;

@property(nonatomic,assign)BOOL isHiddenView;

@end
