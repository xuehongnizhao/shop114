//
//  AppDelegate.m
//  CityO2OMerchant
//
//  Created by Sky on 15/3/9.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "AppDelegate.h"
#import "APService.h"
#import "TabBarViewController.h"

@interface AppDelegate ()
{
    TabBarViewController* tabBarViewController;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    // 项目版本号--一次调用
    self.applicationVersion = [UZCommonMethod checkAPPVersion];
    
    // 判断系统版本--一次调用
    self.systemVersion = [UZCommonMethod checkSystemVersion];
    
    // 设置网路引擎
    self.baseEngine = [[BaseEngine alloc] initWithHostName:baseUrl];
    
    
    [application setApplicationIconBadgeNumber:0];

    
    //get infoFromNetWork
    [self getInfoFromNetWork];
    
    
    /**
     *  极光推送
     */
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
    [APService setupWithOption:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    tabBarViewController=[[TabBarViewController alloc]init];
    self.window.rootViewController =tabBarViewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}


#pragma mark - getInfoFromNetWork
-(void)getInfoFromNetWork
{
    NSString *sys_type = [[UIDevice currentDevice] systemName];
    NSString *sys_version = [[UIDevice currentDevice] systemVersion];
    NSString *device_type = @"iPhone";
    NSString *brand =@"苹果";
    NSString *model = [[UIDevice currentDevice] model]  ;
    NSString *lat = @"126.650516";
    NSString *lng = @"45.759086";
    NSString *u_id = @"0";
    
    NSDictionary *paramDic = @{@"sys_type":    sys_type,
                               @"sys_version": sys_version,
                               @"device_type": device_type,
                               @"brand":       brand,
                               @"model":       model,
                               @"app_key":     base_set,
                               @"lat":         lat,
                               @"lng":         lng,
                               @"u_id":        u_id
                               
                               };
    
    [Base64Tool postSomethingToServe:base_set andParams:paramDic isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        //NSLog(@"message:%@",[param objectForKey:@"message"]);
        if ([param[@"code"] integerValue]==200)
        {
            if ([JSONOfNetWork createPlist:param])
            {
                NSLog(@"写入完成");
                self.baseDict=[JSONOfNetWork getDictionaryFromPlist];
            }
        }
        else
        {
            
        }
        
    } andErrorBlock:^(NSError *error) {
        NSLog(@"time out");
    }];
    
}
#pragma mark - push
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{

    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
}

// Called when your app has been activated by the user selecting an action from
// a local notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
}

// Called when your app has been activated by the user selecting an action from
// a remote notification.
// A nil action identifier indicates the default action.
// You should call the completion handler as soon as you've finished handling
// the action.
- (void)application:(UIApplication *)application
handleActionWithIdentifier:(NSString *)identifier
forRemoteNotification:(NSDictionary *)userInfo
  completionHandler:(void (^)())completionHandler {
}
#endif

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [APService handleRemoteNotification:userInfo];
    NSLog(@"收到通知:%@", [self logDic:userInfo]);
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
    [APService handleRemoteNotification:userInfo];
    NSLog(@"收到通知:%@", [self logDic:userInfo]);
    if (application.applicationState == UIApplicationStateActive) {
//        NSString *string = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"您有新的订单,请注意查看"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        alertView.tag = 3;
        [alertView show];
        
        /**
         *  跳转到相应页面
         */
        [application setApplicationIconBadgeNumber:0];
        if ([[NSUserDefaults standardUserDefaults] boolForKey:isLogined]==YES)
        {
            [tabBarViewController setSelectedIndex:1];
        }
        
        
    }else{
        
    }
    [application setApplicationIconBadgeNumber:0];
    completionHandler(UIBackgroundFetchResultNewData);
}
- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [APService showLocalNotificationAtFront:notification identifierKey:nil];
}

// log NSSet with UTF8
// if not ,log will be \Uxxx
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}



#pragma mark -


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [self setAlian:nil];
    NSLog(@"asdf");

}

#pragma mark----设置别名
-(void)setAlian :(NSString*)alian
{
    [APService setTags:nil
                 alias:alian
      callbackSelector:@selector(tagsAliasCallback:tags:alias:)
                target:self];
}

#pragma mark---------设备号获取以及回调函数
- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}



@end
