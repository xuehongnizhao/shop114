//
//  ScanQRCodeViewController.h
//  CityO2OMerchant
//
//  Created by Sky on 15/3/11.
//  Copyright (c) 2015年 Sky. All rights reserved.
//
//  扫描页面

#import "BaseViewController.h"

@protocol ScanQRCodeViewControllerDelegate <NSObject>

-(void)getQRcodeFromCamera:(NSString*)code;

@end

@interface ScanQRCodeViewController : BaseViewController


@property(nonatomic,weak)id<ScanQRCodeViewControllerDelegate> delegate;

@end
