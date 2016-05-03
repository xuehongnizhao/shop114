//
//  SellerCenterTableViewCell.h
//  CityO2OMerchant
//
//  Created by mac on 15/3/16.
//  Copyright (c) 2015年 Sky. All rights reserved.
//
//  卖家中心

#import <UIKit/UIKit.h>

@interface SellerCenterTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *cellLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellTitle;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
