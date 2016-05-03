//
//  RevisPassViewController.m
//  CityO2OMerchant
//
//  Created by mac on 15/3/16.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "RevisPassViewController.h"

@interface RevisPassViewController ()
@property (weak, nonatomic) IBOutlet UITextField *oldPassText;
@property (weak, nonatomic) IBOutlet UITextField *inputNewPassText;
@property (weak, nonatomic) IBOutlet UITextField *resetPassText;
- (IBAction)revisButton:(id)sender;

@end

@implementation RevisPassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
    [self setBackButton];
    [self setNavBarTitle:@"修改密码" withFont:20.0f];
    [self setUI];
}

#pragma mark ----设置界面
- (void)setUI{
    self.oldPassText.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.inputNewPassText.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.resetPassText.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.oldPassText.layer.borderWidth = 0.5;
    self.inputNewPassText.layer.borderWidth = 0.5;
    self.resetPassText.layer.borderWidth = 0.5;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)revisButton:(id)sender {
    if ([_oldPassText.text isEqualToString:userDefault(userPassword)]) {
        
        if ([_inputNewPassText.text isEqualToString:_resetPassText.text] && ![_inputNewPassText.text isEqualToString:@""]){
            NSDictionary *dic = @{
                                  @"app_key"      : SHOP_EDIT_PASS,
                                  @"username"     :  userDefault(userNickname),
                                  @"password"     : _oldPassText.text,
                                  @"new_password" : _inputNewPassText.text
                                  };
            
            [Base64Tool postSomethingToServe:SHOP_EDIT_PASS andParams:dic isBase64:YES CompletionBlock:^(id param) {
                if ([param [@"code"] integerValue] == 200) {
                    [SVProgressHUD showSuccessWithStatus:param [@"message"]];
                }
                NSLog(@"param>>>>>%@",param);
            } andErrorBlock:^(NSError *error) {
                
            }];
        }else{
            [SVProgressHUD showErrorWithStatus:@"两次密码输入不一致"];
        }
    }else{
        [SVProgressHUD showErrorWithStatus:@"旧密码不正确"];
    }
    
    
}
@end
