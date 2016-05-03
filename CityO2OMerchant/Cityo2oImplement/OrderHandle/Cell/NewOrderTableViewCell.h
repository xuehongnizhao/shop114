//
//  NewOrderTableViewCell.h
//  CityO2OMerchant
//
//  Created by Sky on 15/3/12.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewOrderTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *typeLabel;

/**
 *  createWithtableview
 *
 *  @param tableView tableview
 *
 *  @return cell
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
