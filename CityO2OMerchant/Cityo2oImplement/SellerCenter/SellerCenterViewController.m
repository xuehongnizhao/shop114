//
//  SellerCenterViewController.m
//  CityO2OMerchant
//
//  Created by Sky on 15/3/9.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "SellerCenterViewController.h"
#import "OrderRecordViewController.h"
#import "ShopReviewViewController.h"
#import "SellerCenterTableViewCell.h"
#import "SupportServiceViewController.h"
#import "RevisPassViewController.h"
#import "LoginViewController.h"
#import "APService.h"

@interface SellerCenterViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (strong , nonatomic) UITableView *sallerCenterTableView;

@property (strong , nonatomic) NSArray *array;

@property (strong , nonatomic) UIImageView *user_iamge;

@property (strong , nonatomic) UILabel *shop_name_lable;

@property (strong , nonatomic) UILabel *test_lable;

@end

@implementation SellerCenterViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self.rdv_tabBarController setTabBarHidden:NO animated:NO];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:loginChange]==YES)
    {
        [_user_iamge sd_setImageWithURL:[NSURL URLWithString:userDefault(userPic)] placeholderImage:nil];
        
        _test_lable.text = [NSString stringWithFormat:@"管理员:%@",userDefault(userNickname)];
        
        
        _shop_name_lable.text  = userDefault(shopName);
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:loginChange];
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBarTitle:@"商户中心" withFont:20];

    [self setView];
    [self setArray];
}

#pragma mark-----get UI
-(UIImageView *)user_iamge
{
    if (!_user_iamge) {
        _user_iamge = [[UIImageView alloc] initForAutoLayout];
        _user_iamge.layer.borderWidth = 1;
        _user_iamge.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _user_iamge.layer.masksToBounds = YES;
        _user_iamge.layer.cornerRadius = 30.0f;
    }
    return _user_iamge;
}

//-----商家名称lable------
-(UILabel *)shop_name_lable
{
    if (!_shop_name_lable) {
        _shop_name_lable = [[UILabel alloc] initForAutoLayout];
        _shop_name_lable.textColor = [UIColor whiteColor];
        _shop_name_lable.font = [UIFont systemFontOfSize:14.0f];
    }
    return _shop_name_lable;
}

//-----手机号label-------
-(UILabel *)test_lable
{
    if (!_test_lable) {
        _test_lable = [[UILabel alloc] initForAutoLayout];
        _test_lable.textColor = [UIColor whiteColor];
        _test_lable.font = [UIFont systemFontOfSize:14.0f];
        _test_lable.textAlignment = NSTextAlignmentRight;
    }
    return _test_lable;
}

//----表示图-----
-(UITableView *)sallerCenterTableView
{
    if (!_sallerCenterTableView) {
        _sallerCenterTableView = [[UITableView alloc] initForAutoLayout];
        _sallerCenterTableView.delegate = self;
        _sallerCenterTableView.dataSource = self;
        [UZCommonMethod hiddleExtendCellFromTableview:_sallerCenterTableView];
    }
    return _sallerCenterTableView;
}


/*
 设置cell文字名称
 */
-(void)setArray{
    if (!self.array) {
        self.array = [[NSArray alloc] init];
        self.array = @[@"查看订单",@"用户评价",@"支持服务",@"修改密码",@"客服电话",@"注销"];
    }
}

#pragma mark -------添加表示图
- (void)setView{
    [self.view addSubview:self.sallerCenterTableView];
    [_sallerCenterTableView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f];
    [_sallerCenterTableView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_sallerCenterTableView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_sallerCenterTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:46.0f];
    [self setTableviewSeparatorInset];
}

#pragma mark 数据源方法和tableview代理方法

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *user_view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dividual_bg"]];
    //----添加头像---------
    [user_view addSubview:self.user_iamge];
    [_user_iamge autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20.0f];
    [_user_iamge autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f];
    [_user_iamge autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f];
    [_user_iamge autoSetDimension:ALDimensionWidth toSize:60.0f];
    
    [_user_iamge sd_setImageWithURL:[NSURL URLWithString:userDefault(userPic)] placeholderImage:nil];
    
    //-----添加店铺手机号-----------
    [user_view addSubview:self.test_lable];
    
    [_test_lable autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:15.0f];
    [_test_lable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_user_iamge withOffset:20.0f];
    [_test_lable autoSetDimension:ALDimensionHeight toSize:25.0f];
    [_shop_name_lable autoSetDimension:ALDimensionWidth toSize:200.0f];
    
   
    _test_lable.text = [NSString stringWithFormat:@"管理员:%@",userDefault(userNickname)];
    

    
    //-----添加商铺名称-------
    [user_view addSubview:self.shop_name_lable];
    [_shop_name_lable autoSetDimension:ALDimensionWidth toSize:200.0f];
    [_shop_name_lable autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:15.f];
    [_shop_name_lable autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_user_iamge withOffset:20.0f];
    [_shop_name_lable autoSetDimension:ALDimensionHeight toSize:25.0f];
    
    
    _shop_name_lable.text  = userDefault(shopName);
    
    
    return user_view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SellerCenterTableViewCell *cell = [SellerCenterTableViewCell cellWithTableView:tableView];
    if (indexPath.row!=4&&indexPath.row!=5)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.row == 2) {
        cell.cellLabel.text = @" ";
    }
    else if (indexPath.row == 4) {
        cell.cellLabel.text = @"400-6551-114";
    }
    else{
        cell.cellLabel.text = @"";
    }
    cell.cellTitle.text = [self.array objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
        //跳转支持服务页面
        SupportServiceViewController *viewController = [[SupportServiceViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    }else if (indexPath.row == 0){
        
        [self.navigationController pushViewController:[OrderRecordViewController new] animated:YES];
        
    }else if (indexPath.row == 1){
        //跳转用户评价页面
        ShopReviewViewController *viewController = [[ShopReviewViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    }else if (indexPath.row == 3){
        //跳转修改密码界面
        RevisPassViewController *viewController = [[RevisPassViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    }else if (indexPath.row == 4){
        [UZCommonMethod callPhone:@"400-6551-114" superView:self.view];
    }else if (indexPath.row == 5){
        [self logoutAlertShow];
    }
}

/*
 cell高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
}


#pragma mark -------注销
- (void)logoutAlertShow{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否注销?" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        /**
         *  注销设备别名
         */
        [self setAlian:nil];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:isLogined];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:loginChange];
        [self.navigationController pushViewController:[LoginViewController new] animated:YES];
    }
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




#pragma mark - tableview separatorinset
-(void)setTableviewSeparatorInset
{
    if ([self.sallerCenterTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.sallerCenterTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.sallerCenterTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.sallerCenterTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
    
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
