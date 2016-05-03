//
//  ConfirmResultViewController.m
//  CityO2OMerchant
//
//  Created by Sky on 15/3/10.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "ConfirmResultViewController.h"
#import <RDVTabBarController.h>

@interface ConfirmResultViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *backImgView;
@property (strong, nonatomic) IBOutlet UILabel *typeLabel;
@property (strong, nonatomic) IBOutlet UILabel *consumeCodeLabel;
@property (strong, nonatomic) IBOutlet UITableView *productTableView;
@property (strong, nonatomic) IBOutlet UIButton *confirmConsumeButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelConsumeButton;
@property (nonatomic,strong)NSMutableArray* nameArray;

@end

@implementation ConfirmResultViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self.rdv_tabBarController setTabBarHidden:YES animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setBackButton];
    
    [self setNavBarTitle:@"验证结果" withFont:20];
    /**
     *  cnfirm info
     */
    _consumeCodeLabel.text=_codeModule.pass;
    _backImgView.image=[UIImage imageNamed:@"passwordbg"];
    _typeLabel.text=[_codeModule.type isEqualToString:@"group"]?@"团购密码":@"优惠券密码";
    _confirmConsumeButton.layer.cornerRadius=5;
    _cancelConsumeButton.layer.cornerRadius=5;
    
    [_confirmConsumeButton setBackgroundImage:[self createImageWithColor:UIColorFromRGB(0x79c5d4)] forState:UIControlStateNormal];
    [_confirmConsumeButton setBackgroundImage:[self createImageWithColor:UIColorFromRGB(0x4ba4b9)] forState:UIControlStateSelected];
    
    [_cancelConsumeButton setBackgroundImage:[self createImageWithColor:UIColorFromRGB(0xc6c6c6)] forState:UIControlStateNormal];
    [_cancelConsumeButton setBackgroundImage:[self createImageWithColor:UIColorFromRGB(0xa5a5a5)] forState:UIControlStateSelected];
    
    [UZCommonMethod hiddleExtendCellFromTableview:_productTableView];
    

    
}

- (UIImage*) createImageWithColor: (UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

#pragma mark -  button action
- (IBAction)confirmConsume:(UIButton *)sender
{
    NSDictionary* dict=@{
                         @"app_key":ConfirmConsume,
                         @"type":_codeModule.type,
                         @"pass":_codeModule.pass
                         };
    [SVProgressHUD showWithStatus:@"确认消费中..." maskType:SVProgressHUDMaskTypeBlack];
    [Base64Tool postSomethingToServe:ConfirmConsume andParams:dict isBase64:[IS_USE_BASE64 boolValue] CompletionBlock:^(id param) {
        if ([param[@"code"] integerValue]==200)
        {
            [SVProgressHUD showSuccessWithStatus:param[@"message"]];
            [self.rdv_tabBarController setTabBarHidden:NO animated:YES];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:param[@"message"]];
        }
    } andErrorBlock:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"确认消费失败"];
    }];
}

- (IBAction)cancelConsume:(id)sender
{
    [self.rdv_tabBarController setTabBarHidden:NO animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark-------tableViewDelegateAndDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"normalCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.font=[UIFont systemFontOfSize:14];
    NSString* productInfo=nil;
    if (indexPath.row==0)
    {
       productInfo =[NSString stringWithFormat:@"产品名称:%@",[_nameArray objectAtIndex:indexPath.row]];
        
    }
    else
    {
        productInfo=[NSString stringWithFormat:@"产品价格:%@",[_nameArray objectAtIndex:indexPath.row]];
    }
    NSMutableAttributedString* mutableStr=[[NSMutableAttributedString alloc]initWithString:productInfo];
    
    NSRange range=[productInfo rangeOfString:[_nameArray objectAtIndex:indexPath.row]];
    
    [mutableStr setAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]} range:range];
    
    
    cell.textLabel.attributedText=mutableStr;
    cell.textLabel.textAlignment=NSTextAlignmentLeft;
    cell.textLabel.textColor=[UIColor blackColor];
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.nameArray.count;
}



#pragma mark - Property Accessor
-(NSMutableArray *)nameArray
{
    if (!_nameArray)
    {
        _nameArray=[[NSMutableArray alloc]init];
        [_nameArray addObject:_codeModule.product_name];
        if ([_codeModule.type isEqualToString:@"group"])
        {
            [_nameArray addObject:_codeModule.product_price];
        }
    }
    return _nameArray;
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
