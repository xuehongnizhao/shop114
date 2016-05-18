//
//  defaultName.h
//  WMYRiceNoodles
//
//  Created by mac on 13-12-19.
//  Copyright (c) 2013年 mac. All rights reserved.
//

/**
 * @file         defaultName.h
 * @brief        NSUserDefault的key集合
 *
 * @author       xiaocao
 * @version      0.1
 * @date         2012-12-19
 * @since        2012-12 ~
 */

#ifndef WMYRiceNoodles_defaultName_h
#define WMYRiceNoodles_defaultName_h


#define everLaunch  @"firstEnter"           /*!< 判断是否第一次进入应用: yes-不是第一次，no-是第一次 */
#define isLogined     @"islogined"              /*!< 判断用户登录状态: yes-已登录，no-未登录 */
#define userInfomation    @"userInfo"       /*!< NSUserDefault中，保存用户信息的key */
#define loginInfomation @"loginInfo"        /*!< NSUserDefault中，保存用户登录信息的key */
#define loginChange     @"loginChange"
#define extraReload     @"extraReload"     //购买商品更新列表信息
#define mediaChange     @"mediaChange"     //上传图片或者下载图片修改用户信息
#define exhangeChange   @"exchangeChange"  //交换名片更改信息

//存储发送的消息
#define messageText    @"messageText"
#define emailText      @"emailText"
#define askEmailText   @"askEmailText"

//存储用户基本信息
#define userNickname       @"nickname"
#define userUid            @"uid"
#define userPic            @"userPic"
#define shopName           @"shopName"
#define userPassword       @"userPassword"


//用户存取本地名片的id  id的个数自增
#define userLocalCardNum   @"clientNum"

/**
 *  自动登录
 */
#define autoLogin @"autoLogin"

/**
 *  //获取相应的url
 //#define connect_url(key) [[[[[JSONOfNetWork getDictionaryFromPlist] objectForKey:@"obj"]objectForKey:@"api"]objectForKey:key] substringFromIndex:27]
 #define connect_url(key) [[[[[JSONOfNetWork getDictionaryFromPlist] objectForKey:@"obj"]objectForKey:@"api"]objectForKey:key] substringFromIndex:25]
 //获取NSUserDefault中的数据
 #define userDefault(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]
 //要与AFNetWork的baseURL区分开
 #define baseUrl @"o2o.youzhiapp.com"
 //#define baseUrl @"192.168.1.60/youzhi"
 
 */


//获取相应的url 本地27 21 远程 21
//#define connect_url(key) [[[[[JSONOfNetWork getDictionaryFromPlist] objectForKey:@"obj"]objectForKey:@"api"]objectForKey:key] substringFromIndex:28]
#define connect_url(key) [[[[[JSONOfNetWork getDictionaryFromPlist] objectForKey:@"obj"]objectForKey:@"api"]objectForKey:key] substringFromIndex:29]
//获取NSUserDefault中的数据
#define userDefault(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]

#define IS_USE_BASE64 @"YES"

//字体名称
#define ttfname @"Aller-Light"

//手机标签
#define noteArray @"noteArray"

#define alphaGray [UIColor colorWithRed:109/255.0 green:109/255.0 blue:109/255.0 alpha:0.3]


#define SelectColor UIColorFromRGB(0xe64d54)



#endif
