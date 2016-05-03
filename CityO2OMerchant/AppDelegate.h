//
//  AppDelegate.h
//  CityO2OMerchant
//
//  Created by Sky on 15/3/9.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseEngine.h"
#import "AppStoreEngine.h"

//要与AFNetWork的baseURL区分开
//#define baseUrl  @"121.43.103.195:8088"
//#define baseUrl @"115.28.23.237"
//#define baseUrl @"121.42.194.206:8083/life114"
//#define baseUrl @"manager.114lives.com"
#define baseUrl @"192.168.1.141/life114"
//还要去defaultname.h   70 行   修改 url的长度。
//#define baseUrl  @"o2o.youzhiapp.com"
#define base_set @"base_set/ac_base"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow       *window;

@property (nonatomic        ) CGFloat        systemVersion;/*!< 表示当前应用的操作系统版本号 */

@property (strong, nonatomic) NSString       *applicationVersion;/*!< 应用版本号 */

@property (strong, nonatomic) BaseEngine     *baseEngine;/*!< 网络层引擎的实例对象 */

@property (strong, nonatomic) AppStoreEngine *appStoreEngine;/*!< 网络层、针对APPStore */

@property (strong,nonatomic ) NSDictionary   * baseDict;

@end

