//
//  SaleHeadView.m
//  CityO2OMerchant
//
//  Created by Sky on 15/3/19.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "SaleHeadView.h"

@interface SaleHeadView ()

@property(nonatomic,strong)UILabel* orderNumLabel;

@property(nonatomic,strong)UILabel* totalPriceLabel;

@end

@implementation SaleHeadView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
        self.backgroundColor=[UIColor whiteColor];
        
        /**
         *  separartor
         */
        CGPoint separatorPosition = CGPointMake(self.frame.size.width/2, self.frame.size.height / 2);
        CAShapeLayer *separator = [self createSeparatorLineWithColor:[UIColor lightGrayColor] andPosition:separatorPosition];
        [self.layer addSublayer:separator];
        
        [self setupViewsAndAutolayout];

    }
    
    return self;
}

#pragma mark - setupviews and autolayout
-(void)setupViewsAndAutolayout
{
    [self addSubview:self.orderNumLabel];
    [self addSubview:self.totalPriceLabel];
    
    [self.orderNumLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [self.orderNumLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [self.orderNumLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [self.orderNumLabel autoSetDimension:ALDimensionWidth toSize:self.frame.size.width/2-1];
    
    [self.totalPriceLabel autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.orderNumLabel];
    [self.totalPriceLabel autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.orderNumLabel];
    [self.totalPriceLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [self.totalPriceLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    
}
#pragma mark - method
-(void)setNumberOfOrder:(NSString *)num andTotalPrice:(NSString *)totalPrice
{
    NSMutableString* numStr=[[NSMutableString alloc]initWithString:self.orderNumLabel.text];
    NSMutableString* priceStr=[[NSMutableString alloc]initWithString:self.totalPriceLabel.text];
    
    [numStr appendFormat:@"\n %@",num];
    
    [priceStr appendFormat:@"\n ￥%@",totalPrice];
    
    self.orderNumLabel.text=numStr;
    
    self.totalPriceLabel.text=priceStr;

}

#pragma mark -  separartor line
- (CAShapeLayer *)createSeparatorLineWithColor:(UIColor *)color andPosition:(CGPoint)point {
    CAShapeLayer *layer = [CAShapeLayer new];
    
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:CGPointMake(160,0)];
    [path addLineToPoint:CGPointMake(160, 30)];
    
    layer.path = path.CGPath;
    layer.lineWidth = 0.5f;
    layer.strokeColor = color.CGColor;
    
    CGPathRef bound = CGPathCreateCopyByStrokingPath(layer.path, nil, layer.lineWidth, kCGLineCapButt, kCGLineJoinMiter, layer.miterLimit);
    layer.bounds = CGPathGetBoundingBox(bound);
    
    layer.position = point;
    //    NSLog(@"separator position: %@",NSStringFromCGPoint(point));
    //    NSLog(@"separator bounds: %@",NSStringFromCGRect(layer.bounds));
    return layer;
}




#pragma mark - Property Accessor
-(UILabel *)orderNumLabel
{
    if (!_orderNumLabel)
    {
        _orderNumLabel=[[UILabel alloc] initForAutoLayout];
        _orderNumLabel.text=@"订单总数";
        _orderNumLabel.numberOfLines=0;
        _orderNumLabel.textAlignment=NSTextAlignmentCenter;
    }
    return _orderNumLabel;
}

-(UILabel *)totalPriceLabel
{
    if (!_totalPriceLabel)
    {
        _totalPriceLabel=[[UILabel alloc]initForAutoLayout];
        _totalPriceLabel.text=@"销售总金额 ";
        _totalPriceLabel.numberOfLines=0;
        _totalPriceLabel.textAlignment=NSTextAlignmentCenter;
    }
    return _totalPriceLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
}
*/

@end
