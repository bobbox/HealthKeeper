//
//  TPMainViewController.h
//  HealthKeeper
//
//  Created by apple on 15/7/23.
//  Copyright (c) 2015年 山西协康云享科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HealthText.h"
@interface TPMainViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UITabBarDelegate,tableviewCellSelectedDelegate>
@property (strong, nonatomic) IBOutlet UIView *myNextDayView;
@property (weak, nonatomic) IBOutlet UIImageView *myTopImageView;
@property (weak, nonatomic) IBOutlet UIImageView *myUserPhotoImageView;
@property (weak, nonatomic) IBOutlet UIButton *myLoginBtn;
//任务表格上面的时辰内容
@property (strong, nonatomic) IBOutlet UIView *myForwardView;
@property (strong, nonatomic) IBOutlet UIView *myMissionBgView;
@property (strong, nonatomic) IBOutlet UIView *myMasterBgView;
@property (strong, nonatomic) IBOutlet UILabel *myForwardShiChenLabel;
@property (strong, nonatomic) IBOutlet UIView *myNowView;
@property (strong, nonatomic) IBOutlet UILabel *myNowShiChenLabel;
@property (strong, nonatomic) IBOutlet UIView *myBackwardView;
@property (strong, nonatomic) IBOutlet UILabel *myBackwardShiChenLabel;
@property (strong, nonatomic) IBOutlet UILabel *myYangShengLabel;
@property (strong, nonatomic) IBOutlet UILabel *myShiChenTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *myDoTiaoYangBtn;
@property (weak, nonatomic) IBOutlet UIImageView *myDoTiaoYangImageView;
@property (strong, nonatomic) IBOutlet UICollectionView *myHeathMasterCollectionView;
@property (strong, nonatomic) IBOutlet UIView *myShiChenView;
@property (strong, nonatomic) IBOutlet UIScrollView *myTiaoYangScrollView;
@property (strong, nonatomic) IBOutlet UITableView *myReadTextListTableView;
@property (strong, nonatomic) IBOutlet UITabBarItem *myTabFirstBarItem;
@property (strong, nonatomic) IBOutlet UITabBar *myTapBar;
@property (strong, nonatomic) IBOutlet UILabel *myShiChenImageShiChenLabel;
@property (strong, nonatomic) IBOutlet UILabel *myShiChenImageShiChenTimeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *myShiChenImageView;
@property (strong, nonatomic) IBOutlet UILabel *myShiChenImageTipLabel;

- (IBAction)doLogin:(id)sender;

@end
