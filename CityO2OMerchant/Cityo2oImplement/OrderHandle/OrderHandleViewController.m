//
//  OrderHandleViewController.m
//  CityO2OMerchant
//
//  Created by Sky on 15/3/9.
//  Copyright (c) 2015年 Sky. All rights reserved.
//
//订单处理
#import "OrderHandleViewController.h"
#import <NYSegmentedControl.h>
#import "OrderModule.h"
#import "MJExtension.h"
#import "NewOrderTableViewCell.h"
#import "OrderDetailViewController.h"
#import "MJRefresh.h"
@interface OrderHandleViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NYSegmentedControl* segmentedControl;

@property(nonatomic,strong)UITableView* orderTableView;

@property(nonatomic,strong)NSMutableArray* orderArray;

@property(nonatomic,strong)UIImageView* defaultImageView;

@property(nonatomic,strong)NSMutableDictionary* cacheDict;

@end

static NSString* _typeStr=@"1";


@implementation OrderHandleViewController


-(void)viewWillAppear:(BOOL)animated
{
    [self.rdv_tabBarController setTabBarHidden:NO animated:YES];

    [self.orderTableView headerBeginRefreshing];
    
    self.defaultImageView.hidden=self.orderArray.count?YES:NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitleView:self.segmentedControl];
    
    [self setupViewsAndAutolayout];
    
    [self getOrderListFromNetWork];
    
}

#pragma mark - setupviews and autolayout
-(void)setupViewsAndAutolayout
{
    [self.view addSubview:self.orderTableView];
    [self.view addSubview:self.defaultImageView];
    [_orderTableView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [_orderTableView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [_orderTableView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [_orderTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:50];
    
    [_defaultImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_defaultImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [_defaultImageView autoSetDimensionsToSize:CGSizeMake(220, 226)];
}

#pragma mark --- 已处理订单新订单
#pragma mark - WebService
-(void)getProcessedOrdersListFromNetWork
{
    
    NSDictionary* dict=@{
                         @"app_key":ProcessedOrders,
                         @"shop_id":userDefault(userUid),
                         @"type":_typeStr,
                         };
    [Base64Tool postSomethingToServe:ProcessedOrders andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        if ([param[@"code"] integerValue]==200)
        {
            [SVProgressHUD showSuccessWithStatus:param[@"message"]];
            NSArray* arr=[OrderModule objectArrayWithKeyValuesArray:param[@"obj"]];
                [self.orderArray addObjectsFromArray:arr];
                self.defaultImageView.hidden=self.orderArray.count?YES:NO;
                [self.orderTableView reloadData];
            
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:param[@"message"]];
            
        }
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请检查网络连接"];
    }];
    
    

}
-(void)getOrderListFromNetWork
{
    
    NSDictionary* dict=@{
                         @"app_key":OrderList,
                         @"shop_id":userDefault(userUid),
                         @"type":_typeStr,
                         };
    [Base64Tool postSomethingToServe:OrderList andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        if ([param[@"code"] integerValue]==200)
        {
            [SVProgressHUD showSuccessWithStatus:param[@"message"]];
            NSArray* arr=[OrderModule objectArrayWithKeyValuesArray:[param[@"obj"] objectForKey:@"list"]];
                [self.orderArray addObjectsFromArray:arr];
                self.defaultImageView.hidden=self.orderArray.count?YES:NO;
                [self.orderTableView reloadData];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:param[@"message"]];
            
        }
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请检查网络连接"];
    }];
    
    [self getProcessedOrdersListFromNetWork];
    [self.orderTableView headerEndRefreshing];
    
}

#pragma mark - segmentControl Selected
- (void)segmentSelected
{
    _typeStr=[NSString stringWithFormat:@"%ld",_segmentedControl.selectedSegmentIndex+1];
    [self.orderArray removeAllObjects];
    [self getOrderListFromNetWork];
    
}

#pragma mark - get color from color type
-(UIColor*)getColorFromColorType:(NSString*) colorType
{
    NSInteger typeNum=[colorType integerValue];
    UIColor* color=nil;
    switch (typeNum)
    {
            //绿:0x00aa00 红: 0xe34a51 棕 0xdda51e
        case 1:
            color=UIColorFromRGB(0xe34a51);
            break;
        case 2:
        case 4:
        case 6:
            color=UIColorFromRGB(0xdda51e);
            break;
        case 3:
        case 5:
            color=UIColorFromRGB(0x00aa00);
            break;
        case 7:
            color=UIColorFromRGB(0xa5a5a5);
            break;
        default:
            color=[UIColor blackColor];
            break;
    }
    
    return color;
}

#pragma mark-------tableViewDelegateAndDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewOrderTableViewCell* cell=[NewOrderTableViewCell cellWithTableView:tableView];
    OrderModule* module=[self.orderArray objectAtIndex:indexPath.row];
    cell.nameLabel.text=module.user_nickname;
    cell.timeLabel.text=module.add_time;
    cell.typeLabel.text=module.type;
    cell.typeLabel.textColor=[self getColorFromColorType:module.color_type];

    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.orderArray.count;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击cell");
    
    OrderDetailViewController* odvc=[[OrderDetailViewController alloc]initWithNibName:NSStringFromClass([OrderDetailViewController class]) bundle:nil];
    odvc.module=[self.orderArray objectAtIndex:indexPath.row];
    if (_segmentedControl.selectedSegmentIndex==1)
    {
        odvc.isHiddenView=YES;
    }
    [self.navigationController pushViewController:odvc animated:YES];
}

#pragma mark - tableview separatorinset
-(void)setTableviewSeparatorInset
{
    if ([self.orderTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.orderTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.orderTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.orderTableView setLayoutMargins:UIEdgeInsetsZero];
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
-(NYSegmentedControl *)segmentedControl
{
    if (!_segmentedControl)
    {
        _segmentedControl=[[NYSegmentedControl alloc]initWithItems:@[@"新订单",@"已处理"]];
        [_segmentedControl addTarget:self action:@selector(segmentSelected) forControlEvents:UIControlEventValueChanged];
        _segmentedControl.titleTextColor=[UIColor whiteColor];
        _segmentedControl.selectedTitleTextColor=SelectColor;
        _segmentedControl.borderWidth=1.0f;
        _segmentedControl.borderColor=[UIColor whiteColor];
        _segmentedControl.selectedSegmentIndex = 0;
        _segmentedControl.segmentIndicatorBackgroundColor=[UIColor whiteColor];
        _segmentedControl.backgroundColor=[UIColor clearColor];
        _segmentedControl.segmentIndicatorBorderColor=[UIColor whiteColor];
        [_segmentedControl sizeToFit];
        

    }
    return _segmentedControl;
}


-(UITableView *)orderTableView
{
    if (!_orderTableView)
    {
        _orderTableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _orderTableView.delegate=self;
        _orderTableView.dataSource=self;
        [self setTableviewSeparatorInset];
        [UZCommonMethod hiddleExtendCellFromTableview:_orderTableView];
        
        __block id weakSelf=self;
        [_orderTableView addHeaderWithCallback:^{
            [weakSelf removeOrderArrayObjects];
            [weakSelf getOrderListFromNetWork];
    
        }];
    }
    return _orderTableView;
}
- (void)removeOrderArrayObjects{
    [self.orderArray removeAllObjects];
}
-(NSMutableArray *)orderArray
{
    if (!_orderArray)
    {
        _orderArray=[[NSMutableArray alloc]init];
    }
    return _orderArray;
}

-(NSMutableDictionary *)cacheDict
{
    if (!_cacheDict)
    {
        _cacheDict=[[NSMutableDictionary alloc]init];
    }
    return _cacheDict;
}

-(UIImageView *)defaultImageView
{
    if (!_defaultImageView)
    {
        _defaultImageView=[[UIImageView alloc]initForAutoLayout];
        [_defaultImageView setUserInteractionEnabled:YES];
        _defaultImageView.image=[UIImage imageNamed:@"defaultPage"];
    }
    return _defaultImageView;
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
