//
//  OrderReviewTableViewCell.h
//  CityO2OMerchant
//
//  Created by Sky on 15/3/17.
//  Copyright (c) 2015年 Sky. All rights reserved.
//
//  订单评价

#import <UIKit/UIKit.h>
#import <AXRatingView.h>

@interface OrderReviewTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet AXRatingView *starRatingControl;
@property (strong, nonatomic) IBOutlet UILabel *reviewLabel;
@property (strong, nonatomic) IBOutlet UILabel *addTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *typeLabel;


@end
