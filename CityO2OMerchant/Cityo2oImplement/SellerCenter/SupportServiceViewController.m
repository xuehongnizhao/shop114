//
//  SupportServiceViewController.m
//  CityO2OMerchant
//
//  Created by mac on 15/3/16.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "SupportServiceViewController.h"
#import "SupportServiceTableViewCell.h"

@interface SupportServiceViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong , nonatomic) UITableView *supportTableView;

@property (strong , nonatomic) NSMutableArray *supportArray;

@end

@implementation SupportServiceViewController{
    NSString * shopStatusStr;
    NSMutableDictionary *shopStatusDic;
}

- (NSMutableArray *)supportArray{
    if (!_supportArray) {
        _supportArray=[[NSMutableArray alloc]init];
    }
    return _supportArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBarTitle:@"支持服务" withFont:20];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setBackButton];
    
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
    //表示图
    [self setTableView];
    //网络数据
    [self getShopStatus];
    //本地字典  网络数据为key取值
    [self setShopStatusDictionary];
}

#pragma mark 对字典设置值，用网络数据取值
- (void)setShopStatusDictionary{
    shopStatusDic = [[NSMutableDictionary alloc] init];
    [shopStatusDic setValue:@"支持团购：是" forKey:@"group"];
    [shopStatusDic setValue:@"支持优惠券：是" forKey:@"spike"];
    [shopStatusDic setValue:@"支持外卖：是" forKey:@"takeout"];
    [shopStatusDic setValue:@"支持订座：是" forKey:@"seat"];
    [shopStatusDic setValue:@"支持订酒店：是" forKey:@"hotel"];
    [shopStatusDic setValue:@"支持活动：是" forKey:@"activity"];
    
    #pragma mark --- 2016.5添加商家权限
    NSArray *qxArr=[[NSUserDefaults standardUserDefaults]valueForKey:SHANGJIAQUANXIAN];
    for (NSDictionary *qxDic in qxArr) {
        NSLog(@"%@",qxDic);
        NSString *fullName=[qxDic objectForKey:@"type_value"];
        NSString *name=[qxDic objectForKey:@"type_name"];
        [shopStatusDic setValue:[NSString stringWithFormat:@"支持%@：是",fullName ] forKey:name];
        [self.supportArray addObject:name];
    }
}

#pragma mark ----获取商家支持的服务
- (void)getShopStatus{
    NSDictionary *dic = @{
                          @"app_key" : shopStatus,
                          @"shop_id" : userDefault(userUid)
                          };
    [Base64Tool postSomethingToServe:shopStatus andParams:dic isBase64:YES CompletionBlock:^(id param) {
        if ([param [@"code"] integerValue] == 200) {
            shopStatusStr = [param [@"obj"] objectForKey:@"shop_status"];
            [self.supportArray addObjectsFromArray:[shopStatusStr componentsSeparatedByString:@","]];
            [self.supportTableView reloadData];
            NSLog(@"array------------->>%@",self.supportArray);
        }
    } andErrorBlock:^(NSError *error) {
        
    }];
}

#pragma mark ------设置表示图的样式
- (void)setTableView{
    self.supportTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.supportTableView.delegate = self;
    self.supportTableView.dataSource = self;
    [self setTableviewSeparatorInset];
    [UZCommonMethod hiddleExtendCellFromTableview:self.supportTableView];
    [self.view addSubview:self.supportTableView];
}	

#pragma mark 表示图数据源方法和代理方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.supportArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SupportServiceTableViewCell *cell = [SupportServiceTableViewCell cellWithTableView:tableView];
    cell.titleLabel.text = [shopStatusDic objectForKey:self.supportArray[indexPath.row]];
    if (indexPath.row != (self.supportArray.count -1)) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 54, SCREEN_WIDTH, 6)];
        view.backgroundColor = [UIColor colorWithRed:241.0f/255.0f green:241.0f/255.0f blue:241.0f/255.0f alpha:1.0f];
        [cell addSubview:view];
    }
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54;
}

#pragma mark - tableview separatorinset
-(void)setTableviewSeparatorInset
{
    if ([self.supportTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.supportTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.supportTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.supportTableView setLayoutMargins:UIEdgeInsetsZero];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
