//
//  BaseViewController.m
//  CardLeap
//
//  Created by Sky on 14/11/21.
//  Copyright (c) 2014年 Sky. All rights reserved.
//


#import "BaseViewController.h"


@interface BaseViewController ()


@end

@implementation BaseViewController

-(void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout=UIRectEdgeNone;
    
    
}

-(void)setBackButton
{
    UIButton* leftButton=[UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame=CGRectMake(0, 0, 44, 44);
    [leftButton setImage:[UIImage imageNamed:@"navbar_return_no"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"navbar_return_sel"] forState:UIControlStateSelected];
    [leftButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    leftButton.imageEdgeInsets=UIEdgeInsetsMake(0, -30, 0, 0);
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftButton];
}
#pragma mark------返回按钮
-(void)popViewController
{
   
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark setNavBarTitleWithFont
-(void)setNavBarTitle:(NSString *)navTitle withFont:(CGFloat)navFont
{
    //自定义标题
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
    //titleLabel.font=[UIFont fontWithName:ttfname size:navFont];
    titleLabel.font=[UIFont systemFontOfSize:navFont];
    titleLabel.backgroundColor = nil;  //设置Label背景透明
    titleLabel.textColor = [UIColor whiteColor];  //设置文本颜色
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.opaque=NO;
    titleLabel.text = navTitle;  //设置标题
    self.navigationItem.titleView = titleLabel;
    
}





#pragma mark Property Accessor


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
