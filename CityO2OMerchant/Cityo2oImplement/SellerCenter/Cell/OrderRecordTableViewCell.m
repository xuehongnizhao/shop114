//
//  OrderRecordTableViewCell.m
//  CityO2OMerchant
//
//  Created by Sky on 15/3/16.
//  Copyright (c) 2015年 Sky. All rights reserved.
//

#import "OrderRecordTableViewCell.h"

@implementation OrderRecordTableViewCell

- (void)awakeFromNib {
    // Initialization code
}


#pragma mark  创建tableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *promote = @"orderRecordCell";
    OrderRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:promote];
    if (cell == nil)
    {
        //从XIB文件中创建自定义的Cell
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([OrderRecordTableViewCell class]) owner:self options:nil] lastObject];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor whiteColor];
    return cell;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
