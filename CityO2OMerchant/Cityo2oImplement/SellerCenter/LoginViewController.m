//
//  LoginViewController.m
//  CityO2OMerchant
//
//  Created by Sky on 15/3/13.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "LoginViewController.h"
#import "ForgetPassWordViewController.h"
#import "APService.h"

@interface LoginViewController ()
@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIButton *forgetPasswordButton;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UILabel *phoneNumberLabel;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationItem setHidesBackButton:YES];
    
    [self setNavBarTitle:@"登录" withFont:20];
    
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
    
    
    [self.phoneNumberLabel addGestureRecognizer:[self addTapGesttureRecognzier]];
    
}
-(UITapGestureRecognizer*)addTapGesttureRecognzier
{
    UITapGestureRecognizer* tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(callPhone)];
    return tapGesture;
}
-(void)callPhone
{
    [UZCommonMethod callPhone:@"400-6551-114" superView:self.view];

}

- (IBAction)forgetButtonPressed:(UIButton *)sender
{
    [self.navigationController pushViewController:[ForgetPassWordViewController new] animated:YES];
}
- (IBAction)LoginButtonPressed:(UIButton *)sender
{
    if ([_phoneTextField.text isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"手机号不能为空"];
    }
    if ([_passwordTextField.text isEqualToString:@""])
    {
        [SVProgressHUD showErrorWithStatus:@"密码不能为空"];
    }
    
    if (![_passwordTextField.text isEqualToString:@""]&&![_phoneTextField.text isEqualToString:@""])
    {
        [self login];
    }
}




-(void)login
{
    
    NSDictionary* dict=@{
                         @"app_key":ShopLogin,
                         @"password":_passwordTextField.text,
                         @"username":_phoneTextField.text
                         };
    [SVProgressHUD showWithStatus:@"登录中..."];
    [Base64Tool postSomethingToServe:ShopLogin andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param)
    {
        if ([param[@"code"] integerValue]==200)
        {
            [SVProgressHUD showSuccessWithStatus:param[@"message"]];
            NSLog(@"%@",param);
            [[NSUserDefaults standardUserDefaults] setObject:[param[@"obj"] objectForKey:@"shop_id"]forKey:userUid];
            [[NSUserDefaults standardUserDefaults] setObject:[param[@"obj"] objectForKey:@"shop_name"]forKey:shopName];
            [[NSUserDefaults standardUserDefaults] setObject:[param[@"obj"] objectForKey:@"shop_pic"]forKey:userPic];
            [[NSUserDefaults standardUserDefaults] setObject:[param[@"obj"] objectForKey:@"username"]forKey:userNickname];
            [[NSUserDefaults standardUserDefaults] setObject:_passwordTextField.text forKey:userPassword];
            
            /**
             *  确认已经登录
             */
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:isLogined];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            /**
             *  设置推送别名
             */
            [self setAlian:[NSString stringWithFormat:@"shop_%@",[param[@"obj"] objectForKey:@"shop_id"]]];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
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
