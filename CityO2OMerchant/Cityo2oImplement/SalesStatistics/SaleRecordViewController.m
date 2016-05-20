//
//  SaleRecordViewController.m
//  CityO2OMerchant
//
//  Created by Sky on 15/3/19.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "SaleRecordViewController.h"
#import "MJExtension.h"
#import "GroupDetailModule.h"
#import "OrderRecordTableViewCell.h"

@interface SaleRecordViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView* groupTableView;

@property(nonatomic,strong)NSMutableArray* recordArray;

@end

@implementation SaleRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBarTitle:@"销售记录" withFont:20];
    [self setBackButton];
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
    
    [self setupviewsAndAutolayout];
    
    [self setTableviewSeparatorInset];
    
    [self getSaleInfoFromNetWork];
    
}

#pragma mark - setupviews and autolayout
-(void)setupviewsAndAutolayout
{
    [self.view addSubview:self.groupTableView];
    [_groupTableView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [_groupTableView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [_groupTableView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [_groupTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
}

#pragma mark - webService
-(void)getSaleInfoFromNetWork
{
  [Base64Tool postSomethingToServe:[self.postDict objectForKey:@"app_key"] andParams:self.postDict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
      if ([param[@"code"] integerValue]==200)
      {
          [SVProgressHUD showSuccessWithStatus:param[@"message"]];
#pragma mark --- 2016.5 删除result
          NSArray* tempArr=[GroupDetailModule objectArrayWithKeyValuesArray:[param[@"obj"] objectForKey:@"result"]];
          [self.recordArray removeAllObjects];
          [self.recordArray addObjectsFromArray:tempArr];
          [self.groupTableView reloadData];
      }
      else
      {
          [SVProgressHUD showErrorWithStatus:param[@"message"]];
      }
  } andErrorBlock:^(NSError *error) {
      [SVProgressHUD showErrorWithStatus:@"请检查网络连接"];
  }];
}



#pragma mark - talbeviewDeleagteAndDatasource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderRecordTableViewCell* cell=[OrderRecordTableViewCell cellWithTableView:tableView];
    GroupDetailModule* module=[self.recordArray objectAtIndex:indexPath.row];
    cell.orderNameLabel.text=module.group_name;
    cell.userNameLabel.text=[NSString stringWithFormat:@"用户名:%@",module.user_name];
    cell.addTimeLabel.text=module.add_time;
    cell.orderPriceLabel.text=[NSString stringWithFormat:@"总价:￥%@ ",module.grab_price];
    cell.OrderOrPhoneNumLabel.text=[NSString stringWithFormat:@"订单号:%@",module.group_pass];
    
    if ([module.is_pay isEqualToString:@"1"]) {
        cell.isPayLabel.text=@"已消费";
    }
    else
    {
       cell.isPayLabel.text=@"未消费";
       cell.isPayLabel.textColor=UIColorFromRGB(0x00aa00);
       cell.OrderOrPhoneNumLabel.text=@"";
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.recordArray.count;
}


#pragma mark - tableview separatorinset
-(void)setTableviewSeparatorInset
{
    if ([self.groupTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.groupTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.groupTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.groupTableView setLayoutMargins:UIEdgeInsetsZero];
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


#pragma mark - Property Accessor
-(UITableView *)groupTableView
{
    if (!_groupTableView)
    {
        _groupTableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _groupTableView.delegate=self;
        _groupTableView.dataSource=self;
        
        [UZCommonMethod hiddleExtendCellFromTableview:_groupTableView];
    }
    return _groupTableView;
}

-(NSMutableArray *)recordArray
{
    if (!_recordArray)
    {
        _recordArray=[[NSMutableArray alloc]init];
    }
    return _recordArray;
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
