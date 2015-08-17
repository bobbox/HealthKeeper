//
//  TPUserResultViewController.h
//  HealthKeeper
//
//  Created by apple on 15/8/10.
//  Copyright (c) 2015年 山西协康云享科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPTestMapView.h"
#import "TPTabSubViewController.h"
@interface TPUserResultViewController : TPTabSubViewController
@property (strong, nonatomic) IBOutlet TPTestMapView *myMapView;

- (IBAction)doBack:(id)sender;

#pragma mark 基本信息
@property (strong, nonatomic) IBOutlet UILabel *mySexLabel;
@property (strong, nonatomic) IBOutlet UILabel *myAgeLabel;
@property (strong, nonatomic) IBOutlet UILabel *myBirthdayLabel;
@property (strong, nonatomic) IBOutlet UILabel *myLocationLabel;
@property (strong, nonatomic) IBOutlet UILabel *myHeightLabel;
@property (strong, nonatomic) IBOutlet UILabel *myWeightLabel;
@property (strong, nonatomic) IBOutlet UILabel *myBMILabel;

#pragma mark   生理表现
@property (strong, nonatomic) IBOutlet UILabel *myTongueNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *myTongueTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *myTongueDesLabel;
@property (strong, nonatomic) IBOutlet UIImageView *myTongueImageView;
@property (strong, nonatomic) IBOutlet UILabel *myShowBMILabel;
@property (strong, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property (strong, nonatomic) IBOutlet UIView *myFirstView;
@property (strong, nonatomic) IBOutlet UIView *mySecondView;
@property (strong, nonatomic) IBOutlet UIView *myThirdView;
@property (strong, nonatomic) IBOutlet UIView *myForthView;

@property (strong, nonatomic) IBOutlet UIScrollView *myScollView;
@property (strong, nonatomic) IBOutlet UIButton *myBottomBtn;

@end
