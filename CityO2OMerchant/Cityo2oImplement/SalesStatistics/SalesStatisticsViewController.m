//
//  SalesStatisticsViewController.m
//  CityO2OMerchant
//
//  Created by Sky on 15/3/9.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "SalesStatisticsViewController.h"
#import "DOPDropDownMenu.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "OrderRecordTableViewCell.h"
#import "SalesModule.h"
#import "GroupSalesTableViewCell.h"
#import "GroupSaleModule.h"
#import "SaleHeadView.h"
#import "CalendarHomeViewController.h"
#import "TakeoutDetailViewController.h"
#import "SaleRecordViewController.h"

@interface SalesStatisticsViewController ()<UITableViewDelegate,UITableViewDataSource,DOPDropDownMenuDelegate,DOPDropDownMenuDataSource>



@property(nonatomic,strong)UITableView* saleTableView;

@property(nonatomic,strong)NSMutableArray* productTypeArray;

@property(nonatomic,strong)NSArray* dateArray;

@property(nonatomic,strong)DOPDropDownMenu* downMenu;

@property(nonatomic,strong)NSString* typeStr;

@property(nonatomic,strong)NSString* dataStr;

@property(nonatomic,strong)NSString* starTimeStr;

@property(nonatomic,strong)NSString* endTimeStr;

@property(nonatomic,strong)NSMutableArray* recordArray;

@property(nonatomic,strong)NSMutableDictionary* cacheDict;

@property(nonatomic,strong)NSDictionary* typeDict;

@property(nonatomic,strong)NSDictionary* dataDict;

@property(nonatomic,strong)NSDictionary* colorDict;

@end

@implementation SalesStatisticsViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self.rdv_tabBarController setTabBarHidden:NO animated:YES];
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:loginChange]==YES)
    {
        
    }
    [self getStatusFromNetWork];


}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavBarTitle:@"销售统计" withFont:20];
    
    _dateArray=@[@"全部",@"本月",@"本周",@"本日"];
    
    _dataStr=@"0";
    
    _starTimeStr=@"0";
    
    _endTimeStr=@"0";
    
    
    [self setupViewsAndAutolayout];
    
    [self setTableviewSeparatorInset];
    
//    [self getStatusFromNetWork];
    
    [self setCalendarButton];

}

#pragma mark - set calendar Button
-(void)setCalendarButton
{
    UIButton* leftButton=[UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame=CGRectMake(0, 0, 44, 44);
    [leftButton setImage:[UIImage imageNamed:@"calendar_no"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"calendar_sel"] forState:UIControlStateSelected];
    [leftButton addTarget:self action:@selector(choseTimeWithCalendar) forControlEvents:UIControlEventTouchUpInside];
    leftButton.imageEdgeInsets=UIEdgeInsetsMake(0, 0, 0, -30);
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftButton];
}

-(void)choseTimeWithCalendar
{
    
    CalendarHomeViewController *chvc;
    if (!chvc) {
        chvc = [[CalendarHomeViewController alloc]init];
        chvc.calendartitle = @"日期选择";
        //[chvc setAirPlaneToDay:365 ToDateforString:nil];//飞机初始化方法
        [chvc setHotelToDay:-365*5 ToDateforString:@"11"];
    }
    
    chvc.calendarblock = ^(NSString *model){
        NSLog(@"\n---------------------------");
        NSLog(@"日期区间是%@",model);
        NSArray* timeArr=[model componentsSeparatedByString:@":"];
        _starTimeStr=[timeArr firstObject];
        _endTimeStr=[timeArr lastObject];
        _dataStr=@"time";
        [self.saleTableView headerBeginRefreshing];
    };
    [self.navigationController pushViewController:chvc animated:YES];
    
}



#pragma mark - Web Service
-(void)getSalesListFromNetWork
{
#warning 12.8 修复当typeStr为空时，程序会崩溃。 by CC
    if (_typeStr == nil || [_typeStr isEqualToString:@""] == YES) {
        [SVProgressHUD showErrorWithStatus:@"暂无数据"];
        [self.saleTableView headerEndRefreshing];// 结束刷新状态
        return;
    }
    NSDictionary* dict=@{
                         @"app_key":SALESSTATISTIC,
                         @"record_type":_typeStr,
                         @"shop_id":userDefault(userUid),
                         @"time_type":_dataStr,
                         @"begin_time":_starTimeStr,
                         @"end_time":_endTimeStr,
                         };
    NSLog(@"dict:%@",dict);
    [Base64Tool postSomethingToServe:SALESSTATISTIC andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        if ([param[@"code"] integerValue]==200)
        {
            [SVProgressHUD showSuccessWithStatus:param[@"message"]];
            if ([_typeStr isEqualToString:@"takeout"])
            {
                NSArray* tempArr=[SalesModule objectArrayWithKeyValuesArray:[param[@"obj"] objectForKey:@"result"]];
                
                [self.recordArray removeAllObjects];
                [self.recordArray addObjectsFromArray:tempArr];
                
                
                NSString* countNum=[param[@"obj"] objectForKey:@"count"];
                NSString* totalPrice=[param[@"obj"] objectForKey:@"sum"];
                
                /**
                 *  添加透视图
                 */
                SaleHeadView* headView=[[SaleHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
                [headView setNumberOfOrder:countNum andTotalPrice:totalPrice];
                
                [self.saleTableView setTableHeaderView:headView];
                
                [self.saleTableView reloadData];

                
            }
            else
            {
                NSArray* temp=[GroupSaleModule objectArrayWithKeyValuesArray:[param[@"obj"] objectForKey:@"result"]];
                [self.recordArray removeAllObjects];
                [self.recordArray addObjectsFromArray:temp];
                
                
                [self.saleTableView setTableHeaderView:nil];
                
                [self.saleTableView reloadData];

            }
            

        }
        else
        {
            [SVProgressHUD showErrorWithStatus:param[@"message"]];
        }
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请检查网络连接"];
    }];
    
    [self.saleTableView headerEndRefreshing];
    
}


-(void)getStatusFromNetWork
{
    
    [self.productTypeArray removeAllObjects];
    [self.saleTableView reloadData];
    
    NSDictionary * dict=@{
                          @"app_key":shopStatus,
                          @"shop_id":userDefault(userUid)
                          };
    [Base64Tool postSomethingToServe:shopStatus andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        if ([param[@"code"] integerValue]==200)
        {
            [SVProgressHUD showSuccessWithStatus:param[@"message"]];
            NSString* tempStr=[param[@"obj"] objectForKey:@"shop_status"];
            if (tempStr == nil || [tempStr isEqualToString:@""]== YES) {
                [SVProgressHUD showErrorWithStatus:@"没有销售记录"];
                return ;
            }
            for (NSString* statusStr in [tempStr componentsSeparatedByString:@","])
            {
                for (NSString* key in [self.typeDict allKeys])
                {
                    if ([[self.typeDict objectForKey:key] isEqualToString:statusStr]&&([statusStr isEqualToString:@"group"]||[statusStr isEqualToString:@"takeout"]))
                    {
                        [self.productTypeArray addObject:key];
                    }
                }
            }
            [self createDropDownMenu];
            
            _typeStr=[self.typeDict objectForKey:self.productTypeArray[0]];
            
            [self.saleTableView headerBeginRefreshing];
//            NSLog(@"%@", self.productTypeArray);
//            [self getSalesListFromNetWork];
            
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:param[@"message"]];
            
        }
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请检查网络连接"];
    }];
}



#pragma mark - setupviews and autolayout
-(void)setupViewsAndAutolayout
{
    [self.view addSubview:self.saleTableView];
    [_saleTableView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:40];
    [_saleTableView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [_saleTableView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [_saleTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:50];
}

#pragma mark - create Drop down Menu
-(void)createDropDownMenu
{
    
    DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:40];
    _downMenu=menu;
    menu.dataSource = self;
    menu.delegate = self;
    [self.view addSubview:menu];
}

#pragma mark - DropDownMenuDelegateAndDataSource
- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu {
    return 2;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column {
    switch (column)
    {
        case 0:
            return self.dateArray.count;
            break;
        case 1:
            return self.productTypeArray.count;
            break;
        default:
            return 0;
            break;
    }
    
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath {
    switch (indexPath.column) {
        case 0: return self.dateArray[indexPath.row];
            break;
        case 1: return self.productTypeArray[indexPath.row];
            break;
        default:
            return nil;
            break;
    }
}


- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath {
    NSLog(@"column:%li row:%li", (long)indexPath.column, (long)indexPath.row);
    //NSLog(@"%@",[menu titleForRowAtIndexPath:indexPath]);
    NSString* title=[menu titleForRowAtIndexPath:indexPath];
    if (indexPath.column==0)
    {
        _dataStr=[self.dataDict objectForKey:title];
        _starTimeStr=@"0";
        _endTimeStr=@"0";
    }
    if (indexPath.column==1)
    {
        _typeStr=[self.typeDict objectForKey:title];
    }
    
    [self.saleTableView headerBeginRefreshing];
    
}


#pragma mark - talbeviewDeleagteAndDatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([_typeStr isEqualToString:@"takeout"])
    {
        return @"  交易详情";
    }
    else
    {
        return nil;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"_typeStr:%@",_typeStr);
    if ([_typeStr isEqualToString:@"takeout"])
    {
        OrderRecordTableViewCell* cell=[OrderRecordTableViewCell cellWithTableView:tableView];
        SalesModule* module=[self.recordArray objectAtIndex:indexPath.row];
        cell.orderNameLabel.text=@"外卖";
        //cell.orderNameLabel.textColor=(UIColor*)[self.colorDict objectForKey:_typeStr];
        cell.userNameLabel.text=[NSString stringWithFormat:@"用户名:%@",module.user_name];
        cell.addTimeLabel.text=module.add_time;
        cell.orderPriceLabel.text=@"";
        cell.orderPriceLabel.text=[NSString stringWithFormat:@"总价:￥%@",module.total_price];
        cell.OrderOrPhoneNumLabel.text=[NSString stringWithFormat:@"订单号:%@",module.order_id];
        return cell;
    }
    else if([_typeStr isEqualToString:@"group"])
    {
        GroupSalesTableViewCell* cell=[GroupSalesTableViewCell cellWithTableView:tableView];
        
        GroupSaleModule* module=[self.recordArray objectAtIndex:indexPath.row];
        
        cell.groupNameLabel.text=module.group_name;
        
        NSString* priceStr=[NSString stringWithFormat:@"价格:%@元",module.now_price];
        
        NSMutableAttributedString* mutableStr=[[NSMutableAttributedString alloc] initWithString:priceStr];
        
        NSRange priceRange=[priceStr rangeOfString:[NSString stringWithFormat:@"%@元",module.now_price]];
        
        [mutableStr addAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0xfd9a59)} range:priceRange];
        
        cell.gourPriceLabel.attributedText=mutableStr;
        
        
        NSString* saleInfoStr=[NSString stringWithFormat:@"消费: %@   已售: %@",module.pay_num,module.sell_num];
        
        NSMutableAttributedString* saleStr=[[NSMutableAttributedString alloc]initWithString:saleInfoStr attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x75d8e3)}];
        
        
        
        NSRange payRange=[saleInfoStr rangeOfString:@"消费:"];
        
        NSRange sellRange=[saleInfoStr rangeOfString:@"已售:"];
        
        [saleStr addAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} range:payRange];
        
        [saleStr addAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} range:sellRange];
        
        cell.saleInfoLabel.attributedText=saleStr;
        
        return cell;
    }
    else
    {
        UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:@"asdf"];
        return cell;
    }
 
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_typeStr isEqualToString:@"takeout"])
    {
        return 85;
    }
    else
    {
        return 73;
    }

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.recordArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_typeStr isEqualToString:@"takeout"])
    {
        SalesModule* module=[self.recordArray objectAtIndex:indexPath.row];
        TakeoutDetailViewController* tdv=[[TakeoutDetailViewController alloc]init];
        tdv.web_url=module.message_url;
        [self.navigationController pushViewController:tdv animated:YES];
    }
    else if([_typeStr isEqualToString:@"group"])
    {
        GroupSaleModule* module=[self.recordArray objectAtIndex:indexPath.row];
        SaleRecordViewController* srvc=[[SaleRecordViewController alloc]init];
        srvc.postDict=@{
                           @"app_key":ORDER_INFO,
                           @"record_type":_typeStr,
                           @"order_id":module.group_id,
                           @"time_type":_dataStr,
                           @"begin_time":_starTimeStr,
                           @"end_time":_endTimeStr,
                       };
        [self.navigationController pushViewController:srvc animated:YES];
    }
}




#pragma mark - tableview separatorinset
-(void)setTableviewSeparatorInset
{
    if ([self.saleTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.saleTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.saleTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.saleTableView setLayoutMargins:UIEdgeInsetsZero];
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
-(UITableView *)saleTableView
{
    if (!_saleTableView)
    {
        _saleTableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _saleTableView.delegate=self;
        _saleTableView.dataSource=self;
        [UZCommonMethod hiddleExtendCellFromTableview:_saleTableView];
        
        __block id weakSelf=self;
        [_saleTableView addHeaderWithCallback:^{
            [weakSelf getSalesListFromNetWork];
        }];
    }
    return _saleTableView;
}

-(NSMutableArray *)recordArray
{
    if (!_recordArray)
    {
        _recordArray=[[NSMutableArray alloc]init];
    }
    return _recordArray;
}


-(NSMutableDictionary *)cacheDict
{
    if (!_cacheDict)
    {
        _cacheDict=[[NSMutableDictionary alloc]init];
    }
    return _cacheDict;
}

-(NSMutableArray *)productTypeArray
{
    if (!_productTypeArray)
    {
        _productTypeArray=[[NSMutableArray alloc]init];
    }
    return _productTypeArray;
}

-(NSDictionary *)typeDict
{
    if (!_typeDict)
    {
        _typeDict=@{
                    @"团购":@"group",
                    @"优惠券":@"spike",
                    @"外卖":@"takeout",
                    @"订座":@"seat",
                    @"酒店":@"hotel",
                    @"活动":@"activity"
                    };
    }
    return _typeDict;
}

-(NSDictionary *)dataDict
{
    if (!_dataDict)
    {
        _dataDict=@{
                    @"本日":@"day",
                    @"本周":@"week",
                    @"本月":@"month",
                    @"全部":@"0"
                    };
    }
    return _dataDict;
}

-(NSDictionary *)colorDict
{
    
    if (!_colorDict)
    {
        _colorDict=@{
                     @"group":SelectColor,
                     @"spike":UIColorFromRGB(0x57d2df),
                     @"takeout":UIColorFromRGB(0xff6406),
                     @"seat":UIColorFromRGB(0x00aa00),
                     @"hotel":UIColorFromRGB(0x00aa00),
                     @"activity":[UIColor blueColor],
                     };
    }
    return _colorDict;
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
