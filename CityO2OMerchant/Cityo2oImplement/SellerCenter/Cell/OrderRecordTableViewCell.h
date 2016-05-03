//
//  OrderRecordTableViewCell.h
//  CityO2OMerchant
//
//  Created by Sky on 15/3/16.
//  Copyright (c) 2015年 Sky. All rights reserved.
//
//  订单记录

#import <UIKit/UIKit.h>

@interface OrderRecordTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *orderNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *OrderOrPhoneNumLabel;
@property (strong, nonatomic) IBOutlet UILabel *addTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *isPayLabel;

/**
 *  createWithtableview
 *
 *  @param tableView tableview
 *
 *  @return cell
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
