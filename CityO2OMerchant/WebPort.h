//
//  WebPort.h
//  CityO2OMerchant
//
//  Created by Sky on 15/3/10.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#ifndef CityO2OMerchant_WebPort_h
#define CityO2OMerchant_WebPort_h

/**
 *  确认验证码
 */
#define ConfirmPassCode     connect_url(@"shop_pass_sure")


/**
 *  消费码确认提交
 */

#define ConfirmConsume      connect_url(@"shop_order_sure")



/**
 *   验证记录
 */
#define ConfirmRecord       connect_url(@"verification_list")


/**
 *  订单处理列表
 */
#define OrderList           connect_url(@"order_list")


/**
 *  确认订单
 */
#define ConfirmOrder        connect_url(@"takeout_order_sure")


/**
 *  取消订单
 */
#define CancelOrder         connect_url(@"takeout_order_del")


/**
 *  商家登陆
 */
#define ShopLogin           connect_url(@"shop_login")


/**
 *  获取验证码
 */
#define GET_SECURITY_CODE   connect_url(@"send_code")


/**
 *  忘记密码的修改密码
 */
#define MODIFICATOIN_PASS   connect_url(@"lose_password")


/**
 *  订单记录
 */
#define OrderRecord         connect_url(@"order_record")


/**
 *  商户可查权限接口
 */
#define shopStatus          connect_url(@"shop_status")


/**
 *  商家评论
 */
#define shopReview          connect_url(@"shop_review")


/**
 *  忘记密码的修改密码
 */
#define MODIFICATOIN_PASS   connect_url(@"lose_password")


/*
 商家修改密码
 */
#define SHOP_EDIT_PASS      connect_url(@"shop_edit_pass")


/**
 *  销售统计
 */
#define SALESSTATISTIC      connect_url(@"take_out_list")

/**
 *  销售详情
 */
#define ORDER_INFO          connect_url(@"order_infomation")

#endif
