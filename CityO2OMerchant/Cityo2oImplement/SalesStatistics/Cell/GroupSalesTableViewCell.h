//
//  GroupSalesTableViewCell.h
//  CityO2OMerchant
//
//  Created by Sky on 15/3/19.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupSalesTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *groupNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *gourPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *saleInfoLabel;


+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
