//
//  SupportServiceTableViewCell.h
//  CityO2OMerchant
//
//  Created by mac on 15/3/16.
//  Copyright (c) 2015年 Sky. All rights reserved.
//
//  支持服务

#import <UIKit/UIKit.h>

@interface SupportServiceTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
