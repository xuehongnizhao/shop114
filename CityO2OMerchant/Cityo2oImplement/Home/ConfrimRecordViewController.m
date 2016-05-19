//
//  ConfrimRecordViewController.m
//  CityO2OMerchant
//
//  Created by Sky on 15/3/10.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "ConfrimRecordViewController.h"
#import "DOPDropDownMenu.h"
#import "MJExtension.h"
#import <RMDateSelectionViewController.h>

#import "RecordModule.h"
#import "GroupRecordTableViewCell.h"
#import "CouponRecordTableViewCell.h"


@interface ConfrimRecordViewController ()<UITableViewDelegate,UITableViewDataSource,DOPDropDownMenuDelegate,DOPDropDownMenuDataSource,RMDateSelectionViewControllerDelegate>

@property(nonatomic,strong)UITableView* productTableView;

@property(nonatomic,strong)NSArray* dateArray;

@property(nonatomic,strong)DOPDropDownMenu* downMenu;

@property(nonatomic,strong)NSString* typeStr;

@property(nonatomic,strong)NSMutableArray* recordArray;

@property(nonatomic,strong)NSMutableDictionary* cacheDict;


@end

@implementation ConfrimRecordViewController

//- (NSMutableArray *)productTypeArray{
//    if (!_productTypeArray) {
//      _productTypeArray=[NSMutableArray arrayWithArray:@[@{@"type_name":@"all",@"type_value":@"全部"},@{@"type_name":@"group",@"type_value":@"团购"},@{@"type_name":@"spike",@"type_value":@"优惠券"}]];
//    }
//    return _productTypeArray;
//}
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setNavBarTitle:@"验证记录" withFont:20];
    
    _typeStr=@"all";
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *strHour = [dateFormatter stringFromDate:date];
    _dateArray=@[strHour];
    
    [self setBackButton];
    
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];

    [self createDropDownMenu];
    
    [self getRecordListFromNetWork];
    
    [self setTableviewSeparatorInset];
    
    [self setupViewsAndAutolayout];
    
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


#pragma mark - Web Service
-(void)getRecordListFromNetWork
{
    NSDictionary* dict=@{
                         @"app_key":ConfirmRecord,
                         @"shop_id":userDefault(userUid),
                         @"time":[_dateArray firstObject],
                         @"type":_typeStr,
                         };
    [SVProgressHUD showWithStatus:@"查询记录中"];
    [Base64Tool postSomethingToServe:ConfirmRecord andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        
        if ([param[@"code"] integerValue]==200)
        {
            [SVProgressHUD showSuccessWithStatus:param[@"message"]];
            NSArray* tempArray=[RecordModule objectArrayWithKeyValuesArray:[param[@"obj"] objectForKey:@"list"]];
            [self.recordArray removeAllObjects];
            [self.recordArray addObjectsFromArray:tempArray];
            
            [self.productTableView reloadData];
            /**
             *  添加缓存
             */
            //创建缓存标识
            NSString* flagStr=[NSString stringWithFormat:@"%@ %@",_typeStr,[_dateArray firstObject]];
            [self.cacheDict setObject:tempArray forKey:flagStr];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:param[@"message"]];
        }
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请检查网络连接"];
    }];
}


#pragma mark - Find datasource from cacheDict
-(BOOL)findDataSourceFromCache
{
    NSString* flagStr=[NSString stringWithFormat:@"%@ %@",_typeStr,[_dateArray firstObject]];

    if (((NSArray*)[self.cacheDict objectForKey:flagStr]).count==0)  return NO;
    
    
    [self.recordArray removeAllObjects];
    [self.recordArray addObjectsFromArray:[self.cacheDict objectForKey:flagStr]];
    [self.productTableView reloadData];
    return YES;
        
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

        case 0:{
            NSDictionary *dic=self.productTypeArray[indexPath.row];
            return [dic allValues][0];
        }
          
            break;
        case 1: return self.dateArray[indexPath.row];
            break;
        default:
            return nil;
            break;
    }
}

-(BOOL)menu:(DOPDropDownMenu *)menu didSelectMenuAtIndexPath:(NSInteger)menuIndex
{

    if (menuIndex==1)
    {
        [RMDateSelectionViewController setLocalizedTitleForCancelButton:@"取消"];
        [RMDateSelectionViewController setLocalizedTitleForSelectButton:@"确定"];
        RMDateSelectionViewController* rsvc=[RMDateSelectionViewController dateSelectionController];
        rsvc.tintColor=[UIColor lightGrayColor];
        rsvc.delegate=self;
        rsvc.hideNowButton=YES;
        rsvc.disableBouncingWhenShowing = NO;
        rsvc.disableMotionEffects = NO;
        rsvc.disableBlurEffects = YES;
        rsvc.titleLabel.text=@"请选择日期";
        rsvc.datePicker.datePickerMode=UIDatePickerModeDate;
        rsvc.datePicker.minuteInterval=10;
        rsvc.datePicker.maximumDate=[[NSDate alloc]init];
        [rsvc.datePicker setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"Chinese"]];
        
        [rsvc show];
        
        return NO;
    }

    return YES;

}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath {
    NSLog(@"column:%li row:%li", (long)indexPath.column, (long)indexPath.row);
    //NSLog(@"%@",[menu titleForRowAtIndexPath:indexPath]);
    NSString* title=[menu titleForRowAtIndexPath:indexPath];
    if (indexPath.column==0)
    {
        for (NSDictionary *rootDic in self.productTypeArray) {
            if ([title isEqualToString:[rootDic allValues][0]]) {
                _typeStr=[rootDic allKeys][0];
                
            }
        }
    }
    
    //重新获取
    if ([self findDataSourceFromCache]==NO)
    {
        [self getRecordListFromNetWork];
    }
    
    
}




#pragma mark - RMDAteSelectionViewController Delegates
- (void)dateSelectionViewController:(RMDateSelectionViewController *)vc didSelectDate:(NSDate *)aDate {
    //NSLog(@"Successfully selected date: %@", aDate);

    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *strHour = [dateFormatter stringFromDate:aDate];
    _dateArray=nil;
    _dateArray=@[strHour];
    
    DOPIndexPath* indexPath=[DOPIndexPath indexPathWithCol:1 row:0];
    
    [_downMenu setMenuTitle:strHour atIndexPath:indexPath];
    
    
    //重新获取
    if ([self findDataSourceFromCache]==NO)
    {
        [self getRecordListFromNetWork];
    }

}

- (void)dateSelectionViewControllerDidCancel:(RMDateSelectionViewController *)vc {
    NSLog(@"Date selection was canceled");
}



#pragma mark - talbeviewDeleagteAndDatasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"   共有%ld条记录",self.recordArray.count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecordModule* module=[self.recordArray objectAtIndex:indexPath.row];
    if ([module.type isEqualToString:@"group"])
    {
        GroupRecordTableViewCell* cell=[GroupRecordTableViewCell cellWithTableView:tableView];
        cell.productNameLabel.text=module.name;
        cell.productConsumeCodeLabel.text=module.pass;
        cell.productPriceLabel.text=[NSString stringWithFormat:@"价格：￥%@",module.price];
        cell.productTimeLabel.text=module.time;
        return cell;
    }
    else
    {
        CouponRecordTableViewCell* cell=[CouponRecordTableViewCell cellWithTableView:tableView];
        cell.productNameLabel.text=module.name;
        cell.productConsumeCodeLabel.text=module.pass;
        cell.productTimeLabel.text=module.time;
        return cell;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecordModule* module=[self.recordArray objectAtIndex:indexPath.row];
   // NSLog(@"module.type:%@",module.type);
    if ([module.type isEqualToString:@"group"])
    {
        return 90;
    }
    else
    {
        return 60;
    }
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
