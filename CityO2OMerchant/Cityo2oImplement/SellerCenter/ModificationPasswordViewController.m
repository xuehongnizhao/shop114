//
//  ModificationPasswordViewController.m
//  PersonInfo
//
//  Created by Sky on 14-8-8.
//  Copyright (c) 2014年 com.youdro. All rights reserved.
//

#import "ModificationPasswordViewController.h"
#import "LoginViewController.h"
@interface ModificationPasswordViewController ()

@property(nonatomic,strong)UITextField* newPassword;

@property(nonatomic,strong)UITextField* againPassword;

@property(nonatomic,strong)UIButton* confrimButton;

@end

@implementation ModificationPasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor=[UIColor whiteColor];
    [self setUpViews];
    
    [self setBackButton];

}

#pragma mark setUpViewsAndAutoLayout
-(void)setUpViews
{
    [self.view addSubview:self.newPassword];
    [self.view addSubview:self.againPassword];
    [self.view addSubview:self.confrimButton];
    [self setAutolayout];
    
}

-(void)setAutolayout
{
    [_newPassword autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20.0f];
    [_newPassword autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:22.0f];
    [_newPassword autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:22.0f];
    [_newPassword autoSetDimension:ALDimensionHeight toSize:40.0f];
    
    [_againPassword autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:22.0f];
    [_againPassword autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:22.0f];
    [_againPassword autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_newPassword withOffset:17.0f];
    [_againPassword autoSetDimension:ALDimensionHeight toSize:40.0f];
    
    [_confrimButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:22.0f];
    [_confrimButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:22.0f];
    [_confrimButton autoSetDimension:ALDimensionHeight toSize:40.0f];
    [_confrimButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_againPassword withOffset:25.0f];
}

#pragma mark--------确认修改
-(void)confrimModification:(UIButton*) sender
{
    NSLog(@"确认修改");
    if ([self.newPassword.text isEqualToString:self.againPassword.text]&&![self.newPassword.text isEqualToString:@""])
    {
        NSDictionary* dict=@{
                             @"username":self.phoneNumber,
                             @"password":self.newPassword.text,
                             @"app_key":MODIFICATOIN_PASS,
                             };
        [Base64Tool postSomethingToServe:MODIFICATOIN_PASS andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
            if ([param[@"code"] integerValue]==200)
            {
                [SVProgressHUD showSuccessWithStatus:param[@"message"]];
                
                for (UIViewController* vc in self.navigationController.viewControllers)
                {
                    if ([vc isKindOfClass:[LoginViewController class]])
                    {
                        [self.navigationController popToViewController:vc animated:YES];
                    }
                }
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:param[@"message"]];
            }
        } andErrorBlock:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"请检查网络"];
        }];
        

    }
    else
    {
        UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"通知" message:@"两次输入密码不一致" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
    }
}

#pragma mark Property Accessors
/**
 *  通过set方法初始化各类view
 */
-(UITextField *)newPassword
{
    if (!_newPassword)
    {
        _newPassword=[[UITextField alloc]initWithFrame:CGRectMake(22, 84, 279, 39)];
        _newPassword.placeholder=@"输入新密码";
        _newPassword.borderStyle=UITextBorderStyleRoundedRect;
        _newPassword.secureTextEntry=YES;
        _newPassword.clearsOnBeginEditing=YES;
        _newPassword.tag=1;
        _newPassword.leftViewMode=UITextFieldViewModeAlways;
        _newPassword.leftView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sh_login_password"]];
        
    }
    return _newPassword;
}
-(UITextField *)againPassword
{
    if (!_againPassword)
    {
        _againPassword=[[UITextField alloc]initWithFrame:CGRectMake(22, 135, 279, 39)];
        _againPassword.placeholder=@"再次输入新密码";
        _againPassword.borderStyle=UITextBorderStyleRoundedRect;
        _againPassword.clearsOnBeginEditing=YES;
        _againPassword.tag=2;
        _againPassword.secureTextEntry=YES;
        _againPassword.leftViewMode=UITextFieldViewModeAlways;
        _againPassword.leftView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sh_login_oldpass"]];
        [_againPassword setAutocorrectionType:UITextAutocorrectionTypeNo];
        [_againPassword setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        
    }
    return _againPassword;
}

-(UIButton *)confrimButton
{
    if (!_confrimButton)
    {
        _confrimButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        _confrimButton.frame=CGRectMake(22, 194, 279, 39);
       // _confrimButton.layer.cornerRadius=5;
        [_confrimButton setTitle:@"确认修改" forState:UIControlStateNormal];
        [_confrimButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confrimButton addTarget:self action:@selector(confrimModification:) forControlEvents:UIControlEventTouchUpInside];
        [_confrimButton setBackgroundColor:UIColorFromRGB(CONFIRM_BUTTON_COLOR)];
    }
    return _confrimButton;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
