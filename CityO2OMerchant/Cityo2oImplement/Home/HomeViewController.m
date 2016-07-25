//
//  HomeViewController.m
//  CityO2OMerchant
//
//  Created by Sky on 15/3/9.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "HomeViewController.h"
#import "SkyKeyboard.h"
#import "MJExtension.h"

#import "ConfirmCodeModule.h"
#import "ConfirmResultViewController.h"
#import "ConfrimRecordViewController.h"
#import "ScanQRCodeViewController.h"
#import "QuickPayViewController.h"
@interface HomeViewController ()<SkyKeyboardDelegate,ScanQRCodeViewControllerDelegate>

@property(nonatomic,strong)UIView* textFieldBackgroudView;

@property(nonatomic,strong)UITextField* checkTextField;

@property(nonatomic,strong)UIButton* clearButton;

@property (strong, nonatomic)NSMutableArray *productTypeArray;
@end

@implementation HomeViewController
-(void)viewWillAppear:(BOOL)animated
{
    [self.rdv_tabBarController setTabBarHidden:NO animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBarTitle:@"验证" withFont:20];
    
    [self getShopRoot];
    [self setupViews];
    
    [self setRecordButton];
    
    [self setScanButton];
    

    self.view.backgroundColor=UIColorFromRGB(0xf9f9f9);
}

#pragma mark - setRecordButton and ScanButton
-(void)setRecordButton
{
    UIButton* leftButton=[UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame=CGRectMake(0, 0, 44, 44);
    [leftButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
    leftButton.titleLabel.font=[UIFont systemFontOfSize:14];
    [leftButton setTitle:@"记录" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(readRecord) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftButton];
}

-(void)readRecord
{
    ConfrimRecordViewController * crvc=[[ConfrimRecordViewController alloc]init];
    crvc.productTypeArray= self.productTypeArray;
    [self.navigationController pushViewController:crvc animated:YES];
    
    
}

-(void)getShopRoot
{
    NSDictionary* dict=@{
                         @"app_key":SHOPROOT,
                         @"shop_id":userDefault(userUid),
                         };
    [SVProgressHUD showWithStatus:@"查询记录中"];
    __block NSMutableArray *tempArray;
    [Base64Tool postSomethingToServe:SHOPROOT andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {

        if ([param[@"code"] integerValue]==200)
        {
            [SVProgressHUD showSuccessWithStatus:param[@"message"]];
            tempArray=[NSMutableArray arrayWithArray:@[@{@"type_name":@"all",@"type_value":@"全部"},@{@"type_name":@"group",@"type_value":@"团购"},@{@"type_name":@"spike",@"type_value":@"优惠券"}]];

            [tempArray addObjectsFromArray:[param[@"obj"] objectForKey:@"SJQX"]];
            [[NSUserDefaults standardUserDefaults]setObject:[param[@"obj"] objectForKey:@"SJQX"] forKey:SHANGJIAQUANXIAN];
            [self performSelectorOnMainThread:@selector(setProductTypeArray:) withObject:tempArray waitUntilDone:YES];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:param[@"message"]];
        }
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请检查网络连接"];
    }];
}

-(void)setScanButton
{
    UIButton* rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame=CGRectMake(0, 0, 44, 44);
    [rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -30)];
    rightButton.titleLabel.font=[UIFont systemFontOfSize:14];
    [rightButton setTitle:@"扫描" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
#warning nonononono
    [rightButton addTarget:self action:@selector(quickPay) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
}
- (void)quickPay{
    QuickPayViewController *firVC=[[QuickPayViewController alloc]init];
    [self.navigationController pushViewController:firVC animated:YES];
}
-(void)scanQRcode
{
    ScanQRCodeViewController* svc=[[ScanQRCodeViewController alloc]init];
    svc.delegate=self;
    [self presentViewController:svc animated:YES completion:nil];
}

-(void)getQRcodeFromCamera:(NSString *)code
{
    [self confrimPassCode:code];
}

#pragma mark - setupviews and autolayout
-(void)setupViews
{
    [self.view addSubview:self.textFieldBackgroudView];
    
    [self.textFieldBackgroudView addSubview:self.checkTextField];
    
    [self setAutolayout];
    
}


-(void)setAutolayout
{
    [_textFieldBackgroudView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [_textFieldBackgroudView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [_textFieldBackgroudView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [_textFieldBackgroudView autoSetDimension:ALDimensionHeight toSize:80];
    
    [_checkTextField autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [_checkTextField autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20];
    [_checkTextField autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20];
    [_checkTextField autoSetDimension:ALDimensionHeight toSize:60];
}


#pragma mark - SkyKeyboardDelegate
-(void)keyboard:(SkyKeyboard *)keyboard functionButtonAction:(UIButton *)functionButton textInput:(UIResponder<UITextInput> *)textInput
{
    if ([textInput isEqual:_checkTextField])
    {
        [_checkTextField resignFirstResponder];
        if ([_checkTextField.text isEqualToString:@""])
        {
            [SVProgressHUD showErrorWithStatus:@"验证码不能为空"];
        }
        else
        {
            [self confrimPassCode:_checkTextField.text];
        }
    }
}

-(void)confrimPassCode:(NSString*) code
{
    NSString *string=[code substringToIndex:3];
    if ([string isEqualToString:@"999"]) {
        NSDictionary* dict=@{
                             @"app_key":Goods999Confirm,
                             @"pass":code,
                             @"shop_id":userDefault(userUid)
                             };
        [SVProgressHUD showWithStatus:@"验证中..." maskType:SVProgressHUDMaskTypeBlack];
        [Base64Tool postSomethingToServe:Goods999Confirm andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
            if ([param[@"code"] integerValue]==200)
            {
                [SVProgressHUD showSuccessWithStatus:param[@"message"]];
                self.checkTextField.text=@"";
                ConfirmCodeModule* module=[ConfirmCodeModule objectWithKeyValues:param[@"obj"]];
                ConfirmResultViewController* crvc=[[ConfirmResultViewController alloc]initWithNibName:NSStringFromClass([ConfirmResultViewController class]) bundle:nil];
                crvc.codeModule=module;
                [self.navigationController pushViewController:crvc animated:YES];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:param[@"message"]];
            }
        } andErrorBlock:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"请检查网络连接"];
        }];

    }else{
        NSDictionary* dict=@{
                             @"app_key":ConfirmPassCode,
                             @"pass":code,
                             @"shop_id":userDefault(userUid)
                             };
        [SVProgressHUD showWithStatus:@"验证中..." maskType:SVProgressHUDMaskTypeBlack];
        [Base64Tool postSomethingToServe:ConfirmPassCode andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
            if ([param[@"code"] integerValue]==200)
            {
                [SVProgressHUD showSuccessWithStatus:param[@"message"]];
                self.checkTextField.text=@"";
                ConfirmCodeModule* module=[ConfirmCodeModule objectWithKeyValues:param[@"obj"]];
                ConfirmResultViewController* crvc=[[ConfirmResultViewController alloc]initWithNibName:NSStringFromClass([ConfirmResultViewController class]) bundle:nil];
                crvc.codeModule=module;
                [self.navigationController pushViewController:crvc animated:YES];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:param[@"message"]];
            }
        } andErrorBlock:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"请检查网络连接"];
        }];

    }
    
}


#pragma mark - tapGesture Action
-(void)backViewPressed
{
    [self.checkTextField becomeFirstResponder];
}

#pragma mark - button pressed action
-(void)deleteCharacters:(UIButton*) sender
{
    [_checkTextField deleteBackward];
}

-(void)deleteAllCharacters
{
  _checkTextField.text=@"";
}



#pragma mark - Property Accessor
-(UITextField *)checkTextField
{
    if (!_checkTextField)
    {
        _checkTextField=[[UITextField alloc]initForAutoLayout];
        _checkTextField.backgroundColor=[UIColor whiteColor];
        _checkTextField.placeholder=@"请输入商品验证码";
        _checkTextField.rightViewMode=UITextFieldViewModeAlways;
        _checkTextField.rightView=self.clearButton;
        _checkTextField.inputView=({
            SkyKeyboard *numberPad = [SkyKeyboard keyboardWithDelegate:self];
            [numberPad.leftFunctionButton setTitle:@"验证" forState:UIControlStateNormal];
            numberPad.leftFunctionButton.titleLabel.adjustsFontSizeToFitWidth = YES;
            numberPad;
        });
        
     
    }
    return _checkTextField;
}

-(UIView *)textFieldBackgroudView
{
    if (!_textFieldBackgroudView)
    {
        _textFieldBackgroudView=[[UIView alloc]initForAutoLayout];
        _textFieldBackgroudView.backgroundColor=[UIColor whiteColor];
        
        UITapGestureRecognizer* tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backViewPressed)];
        [_textFieldBackgroudView addGestureRecognizer:tapGesture];
    }
    return _textFieldBackgroudView;
}

-(UIButton *)clearButton
{
    if (!_clearButton)
    {
        _clearButton=[UIButton buttonWithType:UIButtonTypeCustom];
        _clearButton.frame=CGRectMake(0, 0, 40, 40);
        [_clearButton setImage:[UIImage imageNamed:@"verification_delete"] forState:UIControlStateNormal];
        [_clearButton addTarget:self action:@selector(deleteCharacters:) forControlEvents:UIControlEventTouchUpInside];
        UILongPressGestureRecognizer* longPressGesture=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(deleteAllCharacters)];
        [_clearButton addGestureRecognizer:longPressGesture];
    }
    return _clearButton;
}


#pragma mark -
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
