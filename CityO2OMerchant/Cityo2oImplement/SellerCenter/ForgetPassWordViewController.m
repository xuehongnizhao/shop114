//
//  ForgetPassWordViewController.m
//  PersonInfo
//
//  Created by Sky on 14-8-8.
//  Copyright (c) 2014年 com.youdro. All rights reserved.
//

#import "ForgetPassWordViewController.h"
#import "ModificationPasswordViewController.h"
@interface ForgetPassWordViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)UITextField* phoneNumberTextField;

@property(nonatomic,strong)UITextField* securityCodeTextField;

@property(nonatomic,strong)UIButton* getSecurityCode;

@property(nonatomic,strong)UIButton* nextStepButton;
@end

@implementation ForgetPassWordViewController
{
    NSString* code;
}
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
    [self setNavBarTitle:@"忘记密码" withFont:20];
    //[self setUI];
    [self setUpViews];
    //[self setBackButton];
    [self setBackButton];
}

#pragma mark setUpViewsAndSetAutoLayOut
-(void)setUpViews
{
    [self.view addSubview:self.phoneNumberTextField];
    [self.view addSubview:self.securityCodeTextField];
    [self.view addSubview:self.getSecurityCode];
    [self.view addSubview:self.nextStepButton];
    
    [self setAutoLayOut];
}

-(void)setAutoLayOut
{
    [_phoneNumberTextField autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20.0f];
    [_phoneNumberTextField autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20.0f];
    [_phoneNumberTextField autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20.0f];
    [_phoneNumberTextField autoSetDimension:ALDimensionHeight toSize:40.0f];
    
    [_securityCodeTextField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_phoneNumberTextField withOffset:10.0f];
    [_securityCodeTextField autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20.0f];
    [_securityCodeTextField autoSetDimension:ALDimensionHeight toSize:40.0f];
    [_securityCodeTextField autoSetDimension:ALDimensionWidth toSize:180.f];
    
    [_getSecurityCode autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20.0f];
    [_getSecurityCode autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_securityCodeTextField withOffset:6.0f];
    [_getSecurityCode autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_securityCodeTextField];
    [_getSecurityCode autoSetDimension:ALDimensionHeight toSize:40.0f];
    
    [_nextStepButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20.0f];
    [_nextStepButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20.0f];
    [_nextStepButton autoSetDimension:ALDimensionHeight toSize:40.0f];
    [_nextStepButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_getSecurityCode withOffset:32.0f];
    
}


#pragma mark--------获取验证码
-(void)getSecCode:(UIButton*)sender
{
    NSLog(@"获取验证码");
    if ([self checkTel:_phoneNumberTextField.text]==YES)
    {
        __block int timeout=60;
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            if(timeout<=0){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    [sender setTitle:@"获取验证码" forState:UIControlStateNormal];
                    sender.userInteractionEnabled = YES;
                });
            }else{
                //            int minutes = timeout / 60;
                int seconds = timeout % 60;
                if (seconds==0)
                {
                    seconds=60;
                }
                NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    //NSLog(@"____%@",strTime);
                    [sender setTitle:[NSString stringWithFormat:@"%@秒后重发",strTime] forState:UIControlStateNormal];
                    sender.userInteractionEnabled = NO;
                });
                timeout--;
            }
        });
        dispatch_resume(_timer);
        
        NSString* user_name=_phoneNumberTextField.text;
        NSDictionary* dict=@{
                             @"user_name":user_name,
                             @"app_key":GET_SECURITY_CODE
                             };
        [Base64Tool postSomethingToServe:GET_SECURITY_CODE andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
            if ([param[@"code"] integerValue]==200)
            {
                [SVProgressHUD showSuccessWithStatus:param[@"message"]];
                code=param[@"obj"];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:param[@"message"]];
            }
            
        } andErrorBlock:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"请检查网络"];
        }];
    }
}

#pragma mark--------验证手机号码正确性
- (BOOL)checkTel:(NSString *)str
{
    if ([str length] == 0)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号码不能为空" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
        
    }
    
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:str];
    if (!isMatch)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号码" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        return NO;
    }
    return YES;
    
}
#pragma mark--------下一步
-(void)nextStep:(UIButton*)sender
{
    if ([code isEqualToString:_securityCodeTextField.text])
    {
        ModificationPasswordViewController* mpvc=[[ModificationPasswordViewController alloc]init];
        mpvc.title=@"修改密码";
        mpvc.phoneNumber=_phoneNumberTextField.text;
        [self.navigationController pushViewController:mpvc animated:YES];

    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"验证码输入错误" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_phoneNumberTextField resignFirstResponder];
    [_securityCodeTextField resignFirstResponder];
}

#pragma mark Property Accessors
/**
 *  通过set方法初始化各类view
 */
-(UITextField *)phoneNumberTextField
{
    if (!_phoneNumberTextField)
    {
        _phoneNumberTextField=[[UITextField alloc]initForAutoLayout];
        _phoneNumberTextField.delegate=self;
        _phoneNumberTextField.placeholder=@"输入注册的手机号";
        _phoneNumberTextField.borderStyle=UITextBorderStyleRoundedRect;
        _phoneNumberTextField.clearsOnBeginEditing=YES;
        _phoneNumberTextField.keyboardType=UIKeyboardTypeNumberPad;
        _phoneNumberTextField.tag=1;
        _phoneNumberTextField.leftViewMode=UITextFieldViewModeAlways;
        _phoneNumberTextField.leftView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sh_login_tel"]];
    }
    return _phoneNumberTextField;
}

-(UITextField *)securityCodeTextField
{
    if (!_securityCodeTextField)
    {
        _securityCodeTextField=[[UITextField alloc]initForAutoLayout];
        _securityCodeTextField.placeholder=@"输入验证码";
        _securityCodeTextField.borderStyle=UITextBorderStyleRoundedRect;
        _securityCodeTextField.clearsOnBeginEditing=YES;
        _securityCodeTextField.tag=3;
        _securityCodeTextField.keyboardType=UIKeyboardTypeNumberPad;
        _securityCodeTextField.leftViewMode=UITextFieldViewModeAlways;
        _securityCodeTextField.leftView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sh_login_oldpass"]];
    }
    return _securityCodeTextField;
}

-(UIButton *)getSecurityCode
{
    if (!_getSecurityCode)
    {
        _getSecurityCode=[UIButton buttonWithType:UIButtonTypeCustom];
        _getSecurityCode.frame=CGRectMake(194, 184, 106, 38);
        //_getSecurityCode.layer.cornerRadius=5;
        _getSecurityCode.titleLabel.font=[UIFont systemFontOfSize:14];
        [_getSecurityCode setBackgroundColor:SelectColor];
        [_getSecurityCode setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_getSecurityCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_getSecurityCode addTarget:self action:@selector(getSecCode:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _getSecurityCode;
}

-(UIButton *)nextStepButton
{
    if (!_nextStepButton)
    {
        _nextStepButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        _nextStepButton.frame=CGRectMake(20, 212, 279, 39);
        //_nextStepButton.layer.cornerRadius=5;
        _nextStepButton.titleLabel.font=[UIFont systemFontOfSize:16];
        [_nextStepButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextStepButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nextStepButton addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
        [_nextStepButton setBackgroundColor:UIColorFromRGB(NEXT_STEP_BUTTON_COLOR)];
    }
    return _nextStepButton;
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
