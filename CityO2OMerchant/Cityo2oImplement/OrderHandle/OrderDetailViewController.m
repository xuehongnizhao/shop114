//
//  OrderDetailViewController.m
//  CityO2OMerchant
//
//  Created by Sky on 15/3/12.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "OrderDetailViewController.h"

@interface OrderDetailViewController ()
@property (strong, nonatomic) IBOutlet UIWebView *orderWebView;
@property (strong, nonatomic) IBOutlet UIView *engageView;
@property (strong, nonatomic) IBOutlet UIButton *cancelEngageButton;
@property (strong, nonatomic) IBOutlet UIButton *acceptEngaeButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelOrderButton;

@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setBackButton];
    
    [self setNavBarTitle:@"订单详情" withFont:20];
    
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
    
    _cancelEngageButton.layer.cornerRadius=5;
    _acceptEngaeButton.layer.cornerRadius=5;
    _cancelOrderButton.layer.cornerRadius=5;
    
    
    [self.orderWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.module.message_url]]];
    
    
    //判断显示那种按钮
    [self showViewWithType];
    
    //是否全都不显示
    [self.engageView setHidden:self.isHiddenView];
    
}

-(void)showViewWithType
{
    //1 外卖 2取消外卖 3酒店 4取消酒店 5订座 6取消订座
    if ([self.module.color_type isEqualToString:@"1"])
    {
        [self.cancelOrderButton setTitle:@"接受订单" forState:UIControlStateNormal];
    }
    if ([self.module.color_type isEqualToString:@"2"])
    {
        [self.cancelOrderButton setTitle:@"取消订单" forState:UIControlStateNormal];
    }
    if ([self.module.color_type isEqualToString:@"3"]||[self.module.color_type isEqualToString:@"5"]||[self.module.color_type isEqualToString:@"4"]||[self.module.color_type isEqualToString:@"6"])
    {
        [self.cancelOrderButton setHidden:YES];
        [self.acceptEngaeButton setHidden:NO];
        [self.cancelEngageButton setHidden:NO];
    }
 
    
}

- (IBAction)OrderButtonPressed:(UIButton *)sender
{
    NSString* typeStr=@"takeout";
    
    if ([self.module.color_type isEqualToString:@"1"])
    {
        [self confirmOrderwithOrderType:typeStr CompletionBlock:^(id param) {
            //确认后的操作
        }];

    }
    else
    {
        //取消订单
        [self cancelOrderWithOrderType:typeStr CompletionBlock:^(id param) {
            //取消订单操作
        }];
    }
}
- (IBAction)acceptEngagePressed:(id)sender
{
    NSString* typeStr=nil;
    
    if ([self.module.color_type isEqualToString:@"3"])
    {
        typeStr=@"hotel";
    }
    else
    {
        typeStr=@"seat";
    }
    [self confirmOrderwithOrderType:typeStr CompletionBlock:^(id param) {
     //确认后的操作
    }];
    
}
- (IBAction)cancelEngagePressed:(UIButton *)sender
{
    NSString* typeStr=nil;
    
    if ([self.module.color_type isEqualToString:@"3"])
    {
        typeStr=@"hotel";
    }
    else
    {
        typeStr=@"seat";
    }
    [self cancelOrderWithOrderType:typeStr CompletionBlock:^(id param) {
        //确认后的操作
    }];
}

#pragma mark - WebService
-(void)confirmOrderwithOrderType:(NSString*)typeStr CompletionBlock:(completionBlock) block
{
    NSDictionary* dict=@{
                         @"app_key":ConfirmOrder, 
                         @"order_id":self.module.order_id,
                         @"type":typeStr
                         };
    [SVProgressHUD showWithStatus:@"确认中.."];
    [Base64Tool postSomethingToServe:ConfirmOrder andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        if ([param[@"code"] integerValue]==200)
        {
            [SVProgressHUD showSuccessWithStatus:param[@"message"]];
            
            block(param);
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:param[@"message"]];
        }
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请检查网络连接"];
    }];
}

-(void)cancelOrderWithOrderType:(NSString*)typeStr CompletionBlock:(completionBlock) block
{
    NSDictionary* dict=@{
                         @"app_key":CancelOrder,
                         @"order_id":self.module.order_id,
                         @"type":typeStr
                         };
    [SVProgressHUD showWithStatus:@"取消中.."];
    [Base64Tool postSomethingToServe:CancelOrder andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        if ([param[@"code"] integerValue]==200)
        {
            [SVProgressHUD showSuccessWithStatus:param[@"message"]];
            
            block(param);
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:param[@"message"]];
        }
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请检查网络连接"];
    }];
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
