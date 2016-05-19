//
//  TabBarViewController.m
//  CardLeap
//
//  Created by Sky on 14/11/21.
//  Copyright (c) 2014年 Sky. All rights reserved.
//

#import "TabBarViewController.h"

#import "BaseViewController.h"

#import "HomeViewController.h"
#import "OrderHandleViewController.h"
#import "SalesStatisticsViewController.h"
#import "SellerCenterViewController.h"

#import "DSNavigationBar.h"

#import "LoginViewController.h"
#import "APService.h"

//tabbarcontroller
#import <RDVTabBarController.h>
#import <RDVTabBarItem.h>
@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupViewControllers];
    
}

#pragma mark -setupViewControllers
-(void)setupViewControllers
{
    NSArray* controllerNames=@[@"OrderHandleViewController",
                               @"HomeViewController",
                               @"SalesStatisticsViewController",
                               @"SellerCenterViewController",
                               ];
    
    NSMutableArray* controllers=[[NSMutableArray alloc]init];
    for (NSString* controllerName in controllerNames)
    {
        
        BaseViewController* bvc=[[[NSClassFromString(controllerName) class] alloc]init];
        UINavigationController* nav=[[UINavigationController alloc]initWithNavigationBarClass:[DSNavigationBar class] toolbarClass:nil];
        
        [nav setViewControllers:@[bvc]];
        [controllers addObject:nav];
        
    }
    
    [[DSNavigationBar appearance] setNavigationBarWithColor:UIColorFromRGB(0xe34a51)];

    [[DSNavigationBar appearance] setBarStyle:UIBarStyleBlackTranslucent];
    
   // [[DSNavigationBar appearance] setTranslucent:NO];
    
    [self setViewControllers:controllers];
    
    
    //ajust user logininfo
    NSLog(@"islogin:%@",userDefault(isLogined));
    if (userDefault(isLogined)==nil||[[NSUserDefaults standardUserDefaults] boolForKey:isLogined]==NO)
    {
        LoginViewController* cvc=[[LoginViewController alloc]init];
        [controllers[0] pushViewController:cvc animated:NO];
        [self setTabBarHidden:YES animated:YES];
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:isLogined]==YES)
    {
        //自动登录
        [self login];
    }

    
    
    [self customizeTabBarForController:self];
    
}

#pragma mark -customizeTabBarForController
- (void)customizeTabBarForController:(RDVTabBarController *)tabBarController {
    
    //设置tab透明背景
    [tabBarController.tabBar setTranslucent:YES];
    
    tabBarController.tabBar.backgroundView.backgroundColor=UIColorFromRGB(0xf9f9f9);
    
    /**
     *  separate
     */
    CAShapeLayer* subLayer=[CAShapeLayer layer];
    subLayer.frame=CGRectMake(0, 0, SCREEN_WIDTH, 1);
    subLayer.borderWidth=0.3f;
    subLayer.borderColor=[UIColor lightGrayColor].CGColor;
    
    [tabBarController.tabBar.backgroundView.layer addSublayer:subLayer];
    
    
    NSInteger _numOfMenu=[tabBarController.viewControllers count];
    CGFloat separatorLineInterval = SCREEN_WIDTH / _numOfMenu;

    for (int i = 0; i < _numOfMenu; i++)
    {
        //separator
        if (i != _numOfMenu - 1) {
            CGPoint separatorPosition = CGPointMake((i + 1) * separatorLineInterval, 50 / 2);
            CAShapeLayer *separator = [self createSeparatorLineWithColor:[UIColor lightGrayColor] andPosition:separatorPosition];
            [tabBarController.tabBar.backgroundView.layer addSublayer:separator];
        }
        
    }

    
    
    //设置选中图片
    NSArray *tabBarItemImages = @[@"tabbar_order", @"tabbar_home", @"tabbar_sales",@"tabbar_indiv"];
    
    NSArray* tabBarItemNames = @[@"订单处理",@"验码",@"销售统计",@"商户中心"];
    
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
        [item setBackgroundSelectedImage:nil withUnselectedImage:nil];
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_sel",
                                                      [tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_no",
                                                        [tabBarItemImages objectAtIndex:index]]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        
        //设置item名称
        NSString* itemTitle=[tabBarItemNames objectAtIndex:index];
        [item setTitle:itemTitle];
        
    
        
        //设置item距离图片距离
        //[item setTitlePositionAdjustment:UIOffsetMake(0, 10)];
        
        //设置itemtitle选中颜色以及未选中颜色
        [item setUnselectedTitleAttributes: @{
                                              NSFontAttributeName: [UIFont systemFontOfSize:14],
                                              NSForegroundColorAttributeName: UIColorFromRGB(0xa4a4a4),
                                              }];
        [item setSelectedTitleAttributes: @{
                                              NSFontAttributeName: [UIFont systemFontOfSize:14],
                                              NSForegroundColorAttributeName:UIColorFromRGB(0xe64d54),
                                              }];
        
        
        index++;
    }
    
    
}


- (CAShapeLayer *)createSeparatorLineWithColor:(UIColor *)color andPosition:(CGPoint)point {
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(160,0)];
    [path addLineToPoint:CGPointMake(160, 50)];
    
    layer.path = path.CGPath;
    layer.lineWidth = 0.4f;
    layer.strokeColor = color.CGColor;
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    
    layer.position = point;
    //    NSLog(@"separator position: %@",NSStringFromCGPoint(point));
    //    NSLog(@"separator bounds: %@",NSStringFromCGRect(layer.bounds));
    return layer;
}


-(void)login
{
    NSDictionary* dict=@{
                         @"app_key":ShopLogin,
                         @"password":userDefault(userPassword),
                         @"username":userDefault(userNickname)
                         };
    
    [Base64Tool postSomethingToServe:ShopLogin andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        if ([param[@"code"] integerValue]==200)
        {
            [SVProgressHUD showSuccessWithStatus:param[@"message"]];
            [[NSUserDefaults standardUserDefaults] setObject:[param[@"obj"] objectForKey:@"shop_id"]forKey:userUid];
            [[NSUserDefaults standardUserDefaults] setObject:[param[@"obj"] objectForKey:@"shop_name"]forKey:shopName];
            [[NSUserDefaults standardUserDefaults] setObject:[param[@"obj"] objectForKey:@"shop_pic"]forKey:userPic];
            [[NSUserDefaults standardUserDefaults] setObject:[param[@"obj"] objectForKey:@"username"]forKey:userNickname];
            /**
             *  确认已经登录
             */
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:isLogined];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            //[self.navigationController popToRootViewControllerAnimated:YES];
            
            /**
             *  设置推送别名
             */
            [self setAlian:[NSString stringWithFormat:@"shop_%@",[param[@"obj"] objectForKey:@"shop_id"]]];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:param[@"message"]];
        }
        
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请检查网络连接"];
    }];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
