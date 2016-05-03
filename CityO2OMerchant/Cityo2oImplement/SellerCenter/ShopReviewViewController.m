//
//  ShopReviewViewController.m
//  CityO2OMerchant
//
//  Created by Sky on 15/3/17.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "ShopReviewViewController.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import <NYSegmentedControl.h>
#import "OrderReviewTableViewCell.h"
#import "ReviewMoudle.h"


@interface ShopReviewViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView* productTableView;

@property(nonatomic,strong)NSDictionary* typeDict;

@property(nonatomic,strong)NSMutableArray* recordArray;

@property(nonatomic,strong)NSMutableDictionary* cacheDict;

@property(nonatomic,strong)NSMutableArray* productTypeArray;

@property(nonatomic,strong)UISegmentedControl* segmentedControl;

@property(nonatomic,strong)UIView* segmentView;

@property(nonatomic,strong)NSString* typeStr;

@property(nonatomic,strong)UITableViewCell* prototypeCell;




@end

@implementation ShopReviewViewController
{
    BOOL isMore;
    NSString* currentPage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self setBackButton];
    
    [self setNavBarTitle:@"商家评论" withFont:20];
    
    [self setTableviewSeparatorInset];
    
    [self getShopStatusFromNetWork];
    
    [self setupViewsAndAutolayout];
    
    _typeStr=@"0";
    currentPage=@"1";
    isMore=NO;
    
    
    UINib *cellNib = [UINib nibWithNibName:@"OrderReviewTableViewCell" bundle:nil];
    [self.productTableView registerNib:cellNib forCellReuseIdentifier:@"reviewCell"];
    self.prototypeCell  = [self.productTableView dequeueReusableCellWithIdentifier:@"reviewCell"];
    
    

}


#pragma mark - setupviews and autolayout
-(void)setupViewsAndAutolayout
{
    [self.view addSubview:self.productTableView];
    [self.view addSubview:self.segmentView];
    
    [_productTableView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:50];
    [_productTableView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [_productTableView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [_productTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    
    [_segmentView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [_segmentView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [_segmentView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [_segmentView autoSetDimension:ALDimensionHeight toSize:50];
}



#pragma mark - Web Service
-(void)getShopStatusFromNetWork
{
    NSDictionary * dict=@{
                          @"app_key":shopStatus,
                          @"shop_id":userDefault(userUid),
                          };
    [Base64Tool postSomethingToServe:shopStatus andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        if ([param[@"code"] integerValue]==200)
        {
            [SVProgressHUD showSuccessWithStatus:param[@"message"]];
            NSString* tempStr=[param[@"obj"] objectForKey:@"shop_status"];
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

            [self.productTypeArray insertObject:@"全部" atIndex:0];
            [self.segmentView addSubview:self.segmentedControl];
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

-(void)getShopReviewFromNetwork
{
    NSDictionary* dict=@{
                         @"app_key":shopReview,
                         @"shop_id":userDefault(userUid),
                         @"page":currentPage,
                         @"rev_type":_typeStr,
                         };
    [Base64Tool postSomethingToServe:shopReview andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        if ([param[@"code"] integerValue]==200)
        {
            [SVProgressHUD showSuccessWithStatus:param[@"message"]];
            NSArray* tempArr=[ReviewMoudle objectArrayWithKeyValuesArray:param[@"obj"]];
            if (isMore==NO)  [self.recordArray removeAllObjects];
            
            [self.recordArray addObjectsFromArray:tempArr];
            
            [self.productTableView reloadData];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:param[@"message"]];
        }
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"请检查网络"];
    }];
    
    [self.productTableView headerEndRefreshing];
    [self.productTableView footerEndRefreshing];

}


#pragma mark - segmentControl Selected
- (void)segmentSelected
{
    NSLog(@"segment selected at index:%ld",_segmentedControl.selectedSegmentIndex);
    
    NSString* title=[_segmentedControl titleForSegmentAtIndex:_segmentedControl.selectedSegmentIndex];
    if ([title isEqualToString:@"全部"])
    {
        _typeStr=@"0";
    }
    if ([title isEqualToString:@"团购"])
    {
        _typeStr=@"1";
    }
    else if ([title isEqualToString:@"优惠券"])
    {
        _typeStr=@"3";
    }
    else if ([title isEqualToString:@"外卖"])
    {
        _typeStr=@"2";
    }
    else if ([title isEqualToString:@"订座"])
    {
        _typeStr=@"4";
    }
    else if ([title isEqualToString:@"酒店"])
    {
        _typeStr=@"5";
    }
    else if ([title isEqualToString:@"活动"])
    {
    
    }
    [self.productTableView headerBeginRefreshing];
    
}

#pragma mark - talbeviewDeleagteAndDatasource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderReviewTableViewCell* cell=[self.productTableView dequeueReusableCellWithIdentifier:@"reviewCell"];
    
    
    
    ReviewMoudle* module=[self.recordArray objectAtIndex:indexPath.row];
    cell.userNameLabel.text=module.user_nickname;
    cell.addTimeLabel.text=module.add_time;
    cell.typeLabel.text=module.rev_type;
    cell.reviewLabel.text=module.rev_text;
    
    [cell.starRatingControl setMarkImage:[UIImage imageNamed:@"per_star"]];
    [cell.starRatingControl setBaseColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"per_star"]]];
    [cell.starRatingControl setHighlightColor:SelectColor];
    [cell.starRatingControl setStepInterval:0.5];
    cell.starRatingControl.value=[module.score floatValue];

    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderReviewTableViewCell *cell = (OrderReviewTableViewCell *)self.prototypeCell;
    
    
    cell.translatesAutoresizingMaskIntoConstraints = NO;
    cell.userNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    cell.addTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    cell.typeLabel.translatesAutoresizingMaskIntoConstraints=NO;
    cell.reviewLabel.translatesAutoresizingMaskIntoConstraints=NO;
    cell.starRatingControl.translatesAutoresizingMaskIntoConstraints=NO;
    
    ReviewMoudle* module=[self.recordArray objectAtIndex:indexPath.row];
    
    
    cell.userNameLabel.text=module.user_nickname;
    cell.addTimeLabel.text=module.add_time;
    cell.typeLabel.text=module.rev_type;
    cell.reviewLabel.text=module.rev_text;
    
    [cell.starRatingControl setMarkImage:[UIImage imageNamed:@"per_star"]];
    [cell.starRatingControl setBaseColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"per_star"]]];
    [cell.starRatingControl setHighlightColor:SelectColor];
    [cell.starRatingControl setStepInterval:0.5];
    cell.starRatingControl.value=[module.score floatValue];
    
    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    NSLog(@"h=%f", size.height + 1);
    return 1  + size.height;

}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
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
        __block NSString* page=currentPage;
        __block BOOL ismore=isMore;
        [_productTableView addHeaderWithCallback:^{
            page=@"0";
            ismore=NO;
            [weakSelf getShopReviewFromNetwork];
        }];
        
        [_productTableView addFooterWithCallback:^{
            page=[NSString stringWithFormat:@"%ld",[page integerValue]+1];
            ismore=YES;
            [weakSelf getShopReviewFromNetwork];
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


#pragma mark - Property Accessor
-(UISegmentedControl *)segmentedControl
{
    if (!_segmentedControl)
    {
        _segmentedControl=[[UISegmentedControl alloc]initWithItems:self.productTypeArray];
        [_segmentedControl addTarget:self action:@selector(segmentSelected) forControlEvents:UIControlEventValueChanged];
        _segmentedControl.tintColor=SelectColor;
        [_segmentedControl sizeToFit];
        _segmentedControl.frame=CGRectMake(10, 0, SCREEN_WIDTH-20, 32);
        _segmentedControl.center=self.segmentView.center;

        
        
    }
    return _segmentedControl;
}

-(UIView *)segmentView
{
    if (!_segmentView)
    {
        _segmentView=[[UIView alloc]initForAutoLayout];
        
        CALayer* subLayer=[CALayer layer];
        
        subLayer.frame=CGRectMake(0, 50, SCREEN_WIDTH, 1);
        subLayer.borderColor=[UIColor lightGrayColor].CGColor;
        subLayer.borderWidth=1.0f;
        [_segmentView.layer addSublayer:subLayer];
        
        
    }
    return _segmentView;
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
