//
//  TakeoutDetailViewController.m
//  CityO2OMerchant
//
//  Created by Sky on 15/3/19.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "TakeoutDetailViewController.h"
#import "MJRefresh.h"

@interface TakeoutDetailViewController ()<UIWebViewDelegate>

@property(nonatomic,strong)UIWebView* detailWebView;

@end

@implementation TakeoutDetailViewController

-(void)viewWillDisappear:(BOOL)animated
{
    _detailWebView=nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBackButton];
    
    [self setNavBarTitle:@"外卖详情" withFont:20];
    
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
    
    [self.view addSubview:self.detailWebView];
    
    [_detailWebView.scrollView headerBeginRefreshing];
    
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
   // [SVProgressHUD showWithStatus:@"加载中..."];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
    [_detailWebView.scrollView headerEndRefreshing];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:@"加载失败,请下拉刷新"];
    [_detailWebView.scrollView headerEndRefreshing];

}

#pragma mark - Property Accessor
-(UIWebView *)detailWebView
{
    if (!_detailWebView)
    {
        _detailWebView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _detailWebView.delegate=self;
        
        __block UIWebView* wv=_detailWebView;
        __weak UIScrollView* scrollView=_detailWebView.scrollView;
        [scrollView addHeaderWithCallback:^{
            [wv loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.web_url]]];
        } dateKey:@"2"];
    }
    return _detailWebView;
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
