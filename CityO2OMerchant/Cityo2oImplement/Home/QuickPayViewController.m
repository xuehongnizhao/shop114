//
//  QuickPayViewController.m
//  CityO2OMerchant
//
//  Created by mac on 16/7/22.
//  Copyright © 2016年 Sky. All rights reserved.
//

#import "QuickPayViewController.h"
#define ZQButtonTag 20167
#define ZQButtonColor [UIColor colorWithRed:1.0 green:0.5573 blue:0.4955 alpha:1.0]
@interface QuickPayViewController()<UITextViewDelegate,UIAlertViewDelegate>
{
    CGFloat buttonWidth;
    UIViewController *firVC;
}
@property (strong, nonatomic)UILabel *textLabel;
@property (strong, nonatomic)UIButton *payAction;
@property (strong, nonatomic)UIButton *clearB;
@property (strong, nonatomic)UIButton *clearAll;
@property (strong, nonatomic)UIButton *equal;
@property (strong, nonatomic)UIButton *comment;
@property (strong, nonatomic)UIButton *zeroB;
@property (strong, nonatomic)UIButton *plusB;
@property (strong, nonatomic)UIButton *pointB;
@property (strong, nonatomic)NSString *textDetail;
@property (strong, nonatomic)UITextView *textView;
@end
@implementation QuickPayViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    [self setUI];
    
}
- (void)setUI{
    [self setNumberButton];
    self.view.backgroundColor=[UIColor colorWithWhite:.9 alpha:1];
    [self.view addSubview:self.zeroB];
    [self.view addSubview:self.clearB];
    [self.view addSubview:self.clearAll];
    [self.view addSubview:self.equal];
    [self.view addSubview:self.plusB];
    [self.view addSubview:self.pointB];
    [self.view addSubview:self.textLabel];
    [_textLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:150*Balance_Heith];
    [_textLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:40*Balance_Width];
    [_textLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:40*Balance_Width];
    [_textLabel autoSetDimension:ALDimensionHeight toSize:40*Balance_Width];
    [self.view addSubview:self.comment];
    [_comment autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.equal withOffset:20*Balance_Width];
    [_comment autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.pointB];
    [_comment autoSetDimensionsToSize:CGSizeMake(buttonWidth*2+10*Balance_Width, buttonWidth)];
    [self.view addSubview:self.payAction];
    [_payAction autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.equal withOffset:20*Balance_Width];
    [_payAction autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.comment withOffset:10*Balance_Width];
    [_payAction autoSetDimensionsToSize:CGSizeMake(buttonWidth*2+10*Balance_Width, buttonWidth)];
    
}

- (void)setNumberButton{
    buttonWidth = SCREEN_WIDTH/4-30*Balance_Width;
    int j = -1;
    int k = 7;
    for (int i=0; i<9; i++) {
        if (i%3==0) {
            j++;
        }
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame= CGRectMake((SCREEN_WIDTH/4-(buttonWidth+20*Balance_Width)/2)+(i%3*(buttonWidth+10*Balance_Width)), 200*Balance_Heith+(j*(buttonWidth+10*Balance_Width)), buttonWidth, buttonWidth);
        button.tag=ZQButtonTag+k;
        button.layer.cornerRadius=buttonWidth/2;
        button.layer.borderWidth=1;
        button.layer.borderColor=[UIColor lightGrayColor].CGColor;
        [button addTarget:self action:@selector(numberButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:[NSString stringWithFormat:@"%d",k] forState:UIControlStateNormal];
        button.backgroundColor=ZQButtonColor;
        [self.view addSubview:button];
        
        if (k%3==0) {
            k-=6;
        }
        k++;
    }
}
- (void)numberButtonClick:(UIButton *)sender{
    self.textDetail=[NSMutableString stringWithFormat:@"%@%d",self.textDetail,(sender.tag-ZQButtonTag)];
    self.textLabel.text=self.textDetail;
}


- (UIButton *)comment{
    if (!_comment) {
        _comment=[[UIButton alloc]initForAutoLayout];
        [_comment addTarget:self action:@selector(commentViewShow) forControlEvents:UIControlEventTouchUpInside];
        _comment.layer.cornerRadius=buttonWidth/2;
        _comment.layer.borderWidth=1;
        _comment.layer.borderColor=[UIColor lightGrayColor].CGColor;
        [_comment setTitle:@"备注" forState:UIControlStateNormal];
        _comment.backgroundColor=[UIColor colorWithRed:0.7527 green:0.2769 blue:1.0 alpha:1.0];

    }
    return _comment;
}


- (void)commentViewShow{
    firVC=[[UIViewController alloc]init];
    [firVC.view addSubview:self.textView];
    [_textView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [_textView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [_textView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [_textView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    
    UIBarButtonItem *barButton=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(disMisViewC)];
    firVC.navigationItem.rightBarButtonItem=barButton;
    firVC.title=@"备注";
    [self.navigationController pushViewController:firVC animated:YES];

    
}

- (void)disMisViewC{
    [firVC.navigationController popViewControllerAnimated:YES];
}
- (UIButton *)payAction{
    if (!_payAction) {
        _payAction =[[UIButton alloc]initForAutoLayout];
        _payAction.layer.cornerRadius=buttonWidth/2;
        _payAction.layer.borderWidth=1;
        _payAction.layer.borderColor=[UIColor lightGrayColor].CGColor;
        [_payAction addTarget:self action:@selector(payViewShow:) forControlEvents:UIControlEventTouchUpInside];
        [_payAction setTitle:[NSString stringWithFormat:@"支付"] forState:UIControlStateNormal];
        _payAction.backgroundColor=[UIColor colorWithRed:1.0 green:0.8544 blue:0.3697 alpha:1.0];

    }
    return _payAction;
}
- (void)payViewShow:(UIButton *)sender{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"选择支付方式" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"微信支付",@"支付宝支付", nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%d",buttonIndex);
}
- (UIButton *)equal{
    if (!_equal) {
        _equal=[[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH/4-(buttonWidth+20*Balance_Width)/2)+(3*(buttonWidth+10*Balance_Width)), 200*Balance_Heith+(2*(buttonWidth+10*Balance_Width)), buttonWidth, buttonWidth*2+20*Balance_Width/2)];
        _equal.layer.cornerRadius=buttonWidth/2;
        _equal.layer.borderWidth=1;
        _equal.layer.borderColor=[UIColor lightGrayColor].CGColor;
        [_equal addTarget:self action:@selector(equalAction) forControlEvents:UIControlEventTouchUpInside];
        [_equal setTitle:[NSString stringWithFormat:@"="] forState:UIControlStateNormal];
        _equal.backgroundColor=ZQButtonColor;
        
    }
    return _equal;
}
- (void)equalAction{
    
    if (self.textDetail.length>0) {
        NSArray *arr=[self.textDetail componentsSeparatedByString:@"+"];
        float i = 0;
        for (NSString *string in arr) {
            i = i+string.floatValue;
        }
        self.textLabel.text=[NSString stringWithFormat:@"%.2f",i];
    }
    self.textDetail=@"";
}

- (UIButton *)zeroB{
    if (!_zeroB) {
        _zeroB =[[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH/4-(buttonWidth+20*Balance_Width)/2)+(1*(buttonWidth+10*Balance_Width)), 200*Balance_Heith+(3*(buttonWidth+10*Balance_Width)), buttonWidth, buttonWidth)];
        _zeroB.tag=ZQButtonTag;
        _zeroB.layer.cornerRadius=buttonWidth/2;
        _zeroB.layer.borderWidth=1;
        _zeroB.layer.borderColor=[UIColor lightGrayColor].CGColor;
        [_zeroB addTarget:self action:@selector(numberButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_zeroB setTitle:[NSString stringWithFormat:@"%d",0] forState:UIControlStateNormal];
        _zeroB.backgroundColor=ZQButtonColor;
    }
    return _zeroB;
}
- (UIButton *)plusB{
    if (!_plusB) {
        _plusB=[[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH/4-(buttonWidth+20*Balance_Width)/2)+(2*(buttonWidth+10*Balance_Width)), 200*Balance_Heith+(3*(buttonWidth+10*Balance_Width)), buttonWidth, buttonWidth)];
        _plusB.layer.cornerRadius=buttonWidth/2;
        _plusB.layer.borderWidth=1;
        _plusB.layer.borderColor=[UIColor lightGrayColor].CGColor;
        [_plusB addTarget:self action:@selector(plusBAction) forControlEvents:UIControlEventTouchUpInside];
        [_plusB setTitle:[NSString stringWithFormat:@"+"] forState:UIControlStateNormal];
        _plusB.backgroundColor=ZQButtonColor;

    }
    return _plusB;
}
- (void)plusBAction{
    self.textDetail=[NSString stringWithFormat:@"%@+",self.textDetail];
    self.textLabel.text=self.textDetail;
}
- (UIButton *)pointB{
    if (!_pointB) {
        _pointB=[[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH/4-(buttonWidth+20*Balance_Width)/2)+(0*(buttonWidth+10*Balance_Width)), 200*Balance_Heith+(3*(buttonWidth+10*Balance_Width)), buttonWidth, buttonWidth)];
        _pointB.layer.cornerRadius=buttonWidth/2;
        _pointB.layer.borderWidth=1;
        _pointB.layer.borderColor=[UIColor lightGrayColor].CGColor;
        [_pointB addTarget:self action:@selector(pointBAction) forControlEvents:UIControlEventTouchUpInside];
        [_pointB setTitle:[NSString stringWithFormat:@"."] forState:UIControlStateNormal];
        _pointB.backgroundColor=ZQButtonColor;

    }
    return _pointB;
}
- (void)pointBAction{
    self.textDetail=[NSMutableString stringWithFormat:@"%@.",self.textDetail];
    self.textLabel.text=self.textDetail;

}
- (UIButton *)clearAll{
    if (!_clearAll) {
        _clearAll=[[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH/4-(buttonWidth+20*Balance_Width)/2)+(3*(buttonWidth+10*Balance_Width)), 200*Balance_Heith+(0*(buttonWidth+10*Balance_Width)), buttonWidth, buttonWidth)];
        _clearAll.layer.cornerRadius=buttonWidth/2;
        _clearAll.layer.borderWidth=1;
        _clearAll.layer.borderColor=[UIColor lightGrayColor].CGColor;
        [_clearAll addTarget:self action:@selector(clearAllAction) forControlEvents:UIControlEventTouchUpInside];
        [_clearAll setTitle:[NSString stringWithFormat:@"清空"] forState:UIControlStateNormal];
        _clearAll.backgroundColor=[UIColor redColor];

    }
    return _clearAll;
}
- (void)clearAllAction{
    self.textDetail=[NSMutableString stringWithFormat:@""];
    self.textLabel.text=@"请输入收款金额";
}
- (UIButton *)clearB{
    if (!_clearB) {
        _clearB=[[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH/4-(buttonWidth+20*Balance_Width)/2)+(3*(buttonWidth+10*Balance_Width)), 200*Balance_Heith+(1*(buttonWidth+10*Balance_Width)), buttonWidth, buttonWidth)];
        _clearB.layer.cornerRadius=buttonWidth/2;
        _clearB.layer.borderWidth=1;
        _clearB.layer.borderColor=[UIColor lightGrayColor].CGColor;
        [_clearB addTarget:self action:@selector(clearBAction) forControlEvents:UIControlEventTouchUpInside];
        [_clearB setTitle:[NSString stringWithFormat:@"删除"] forState:UIControlStateNormal];
        _clearB.backgroundColor=[UIColor redColor];

    }
    return _clearB;
}
- (void)clearBAction{
    if (self.textDetail.length>0) {
        self.textDetail=[self.textDetail substringToIndex:self.textDetail.length-1];
        self.textLabel.text=self.textDetail;
    }
  }
- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel=[[UILabel alloc]initForAutoLayout];
        _textLabel.text=@"请输入收款金额";
        _textLabel.textAlignment=NSTextAlignmentRight;
        _textLabel.backgroundColor=[UIColor lightGrayColor];
        _textLabel.layer.cornerRadius=10;
        _textLabel.clipsToBounds=YES;
    }
    return _textLabel;
}
- (NSString *)textDetail{
    if (!_textDetail) {
        _textDetail=[NSString stringWithFormat:@""];
    }
    return _textDetail;
}

- (UITextView *)textView{
    if (!_textView) {
        _textView=[[UITextView alloc]initForAutoLayout];
        _textView.text=@"请输入收款相关信息";
        _textView.delegate=self;
        _textView.backgroundColor=[UIColor colorWithWhite:.9 alpha:1];
    }
    return _textView;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@"请输入收款相关信息"]) {
        textView.text=@"";
    }
       return YES;
}
@end
