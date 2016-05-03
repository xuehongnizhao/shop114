//
//  SellerCenterTableViewCell.m
//  CityO2OMerchant
//
//  Created by mac on 15/3/16.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "SellerCenterTableViewCell.h"

@implementation SellerCenterTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *identifier = @"sellerCell";
    SellerCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SellerCenterTableViewCell class]) owner:self options:nil] lastObject];
    }
    cell.cellTitle.textColor = [UIColor colorWithRed:122.0f/255.0f green:123.0f/255.0f blue:124.0f/255.0f alpha:1.0f];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
