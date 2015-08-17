//
//  TPUserSexSettingViewController.h
//  HealthKeeper
//
//  Created by apple on 15/8/8.
//  Copyright (c) 2015年 山西协康云享科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPTabSubViewController.h"
@interface TPUserSexSettingViewController : TPTabSubViewController

@property (strong, nonatomic) IBOutlet UIButton *myWomenBtn;
@property (strong, nonatomic) IBOutlet UIButton *myManBtn;
- (IBAction)sexBtnPressed:(id)sender;
- (IBAction)back:(id)sender;
- (IBAction)doNextStep:(id)sender;

@end
