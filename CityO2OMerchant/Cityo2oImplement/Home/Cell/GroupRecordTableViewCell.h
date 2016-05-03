//
//  GroupRecordTableViewCell.h
//  CityO2OMerchant
//
//  Created by Sky on 15/3/11.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupRecordTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *productNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *productConsumeCodeLabel;
@property (strong, nonatomic) IBOutlet UILabel *productPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *productTimeLabel;



/**
 *  createWithtableview
 *
 *  @param tableView tableview
 *
 *  @return cell
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
