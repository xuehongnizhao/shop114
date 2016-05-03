//
//  OrderRecordViewController.m
//  CityO2OMerchant
//
//  Created by Sky on 15/3/16.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "OrderRecordViewController.h"
#import "DOPDropDownMenu.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "OrderRecordTableViewCell.h"
#import "OrderRecordMoudle.h"

@interface OrderRecordViewController ()<UITableViewDelegate,UITableViewDataSource,DOPDropDownMenuDelegate,DOPDropDownMenuDataSource>


@property(nonatomic,strong)UITableView* productTableView;

@property(nonatomic,strong)NSMutableArray* productTypeArray;

@property(nonatomic,strong)NSArray* dateArray;

@property(nonatomic,strong)DOPDropDownMenu* downMenu;

@property(nonatomic,strong)NSString* typeStr;

@property(nonatomic,strong)NSString* dataStr;

@property(nonatomic,strong)NSMutableArray* recordArray;

@property(nonatomic,strong)NSMutableDictionary* cacheDict;

@property(nonatomic,strong)NSDictionary* typeDict;

@property(nonatomic,strong)NSDictionary* dataDict;

@property(nonatomic,strong)NSDictionary* colorDict;


@end

@implementation OrderRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dateArray=@[@"全部",@"本月",@"本周",@"本日"];
    
    _dataStr=@"0";

    [self setBackButton];
    
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
    
    [self setNavBarTitle:@"订单记录" withFont:20];
    
    [self setupViewsAndAutolayout];
    
    [self setTableviewSeparatorInset];
    
    [self getShopStatusFromNetWork];

}


#pragma mark - Web Service
-(void)getRecordListFromNetWork
{
    NSDictionary* dict=@{
                         @"app_key":OrderRecord,
                         @"record_type":_typeStr,
                         @"shop_id":userDefault(userUid),
                         @"time_type":_dataStr,
                         @"begin_time":@"0",
                         @"end_time":@"0",
                         };
    [Base64Tool postSomethingToServe:OrderRecord andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        if ([param[@"code"] integerValue]==200)
        {
            [SVProgressHUD showSuccessWithStatus:param[@"message"]];
            NSArray* tempArray=[OrderRecordMoudle objectArrayWithKeyValuesArray:param[@"obj"]];
            [self.recordArray removeAllObjects];
            [self.recordArray addObjectsFromArray:tempArray];
            [self.productTableView reloadData];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:param[@"message"]];
        }
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请检查网络连接"];
    }];
    
    [self.productTableView headerEndRefreshing];
    
}


-(void)getShopStatusFromNetWork
{
    NSDictionary * dict=@{
                          @"app_key":shopStatus,
                          @"shop_id":userDefault(userUid)
                          };
    [Base64Tool postSomethingToServe:shopStatus andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        if ([param[@"code"] integerValue]==200)
        {
            [SVProgressHUD showSuccessWithStatus:param[@"message"]];
            NSString* tempStr=[param[@"obj"] objectForKey:@"shop_status"];
#warning 12.8 当没有数据，抛出错误。否则会崩溃  by CC
            if (tempStr == nil || [tempStr isEqualToString:@""] == YES) {
                [SVProgressHUD showErrorWithStatus:@"没有订单记录"];
                return;
            }
            for (NSString* statusStr in [tempStr componentsSeparatedByString:@","])
            {
                for (NSString* key in [self.typeDict allKeys])
                {
                    if ([[self.typeDict objectForKey:key] isEqualToString:statusStr])
                    {
                        [self.productTypeArray addObject:key];
                    }
                }
            }
            [self createDropDownMenu];
            
            _typeStr=[self.typeDict objectForKey:self.productTypeArray[0]];
            
            [self.productTableView headerBeginRefreshing];
            
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
    [self.view addSubview:self.productTableView];
    [_productTableView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:40];
    [_productTableView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [_productTableView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [_productTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
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
            return self.productTypeArray.count;
            break;
        case 1:
            return self.dateArray.count;
            break;
        default:
            return 0;
            break;
    }
    
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath {
    switch (indexPath.column) {
        case 0: return self.productTypeArray[indexPath.row];
            break;
        case 1: return self.dateArray[indexPath.row];
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
        _typeStr=[self.typeDict objectForKey:title];
    }
    if (indexPath.column==1)
    {
        _dataStr=[self.dataDict objectForKey:title];
    }
    
    [self.productTableView headerBeginRefreshing];
    
}


#pragma mark - talbeviewDeleagteAndDatasource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderRecordTableViewCell* cell=[OrderRecordTableViewCell cellWithTableView:tableView];
    OrderRecordMoudle* module=[self.recordArray objectAtIndex:indexPath.row];
    cell.orderNameLabel.text=module.name;
    cell.orderNameLabel.textColor=(UIColor*)[self.colorDict objectForKey:_typeStr];
    cell.userNameLabel.text=[NSString stringWithFormat:@"用户名:%@",module.user_name];
    cell.addTimeLabel.text=module.add_time;
    cell.orderPriceLabel.text=@"";
    cell.OrderOrPhoneNumLabel.textColor=[UIColor blackColor];
    
    if ([_typeStr isEqualToString:@"group"])
    {
        cell.orderPriceLabel.text=[NSString stringWithFormat:@"总价:￥%@ x %@份",module.price,module.num];
        cell.OrderOrPhoneNumLabel.text=[NSString stringWithFormat:@"订单号:%@",module.order_id];
    }
    else if ([_typeStr isEqualToString:@"takeout"])
    {
        cell.orderPriceLabel.text=[NSString stringWithFormat:@"总价:￥%@",module.price];
        cell.OrderOrPhoneNumLabel.text=[NSString stringWithFormat:@"订单号:%@",module.order_id];
    }
    else if ([_typeStr isEqualToString:@"spike"])
    {
        cell.OrderOrPhoneNumLabel.text=[NSString stringWithFormat:@"验证码:%@",module.order_id];
    }
    else
    {
        cell.OrderOrPhoneNumLabel.text=[NSString stringWithFormat:@"手机号:%@",module.order_id];
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
    if ([self.productTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.productTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.productTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.productTableView setLayoutMargins:UIEdgeInsetsZero];
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
-(UITableView *)productTableView
{
    if (!_productTableView)
    {
        _productTableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _productTableView.delegate=self;
        _productTableView.dataSource=self;
        [UZCommonMethod hiddleExtendCellFromTableview:_productTableView];
        
        __block id weakSelf=self;
        [_productTableView addHeaderWithCallback:^{
            [weakSelf getRecordListFromNetWork];
        }];
    }
    return _productTableView;
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
