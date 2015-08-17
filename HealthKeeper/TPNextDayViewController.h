//
//  TPNextDayViewController.h
//  HealthKeeper
//
//  Created by apple on 15/7/23.
//  Copyright (c) 2015年 山西协康云享科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKYIconView.h"
#import <CoreLocation/CoreLocation.h>
@interface TPNextDayViewController : UIViewController<CLLocationManagerDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *myShareView;
@property (strong, nonatomic) IBOutlet SKYIconView *myWeatherView;
@property (strong, nonatomic) IBOutlet UILabel *myTempLabel;
@property (strong, nonatomic) IBOutlet UILabel *myTodayTempLabel;

@property (strong, nonatomic) IBOutlet UIImageView *myBgImageView;
@property (strong, nonatomic) IBOutlet UILabel *myTomorrowWeatherLabel;
@property (strong, nonatomic) IBOutlet UILabel *myTomorrowNextDayWeatherLabel;

@property (nonatomic,strong) NSString *myCity;
@property (nonatomic,strong) NSString *myState;
@property (strong, nonatomic)  UILabel *myWordLabel;
@property (strong, nonatomic) IBOutlet UILabel *myPlaceNameLabel;
//图片url
@property (nonatomic,strong) NSString *myBgImgUrlStr;

- (IBAction)shareBtnPressed:(id)sender;
- (IBAction)closeShareBtnPressed:(id)sender;

-(int)getNowShiChenIndex;
@end
