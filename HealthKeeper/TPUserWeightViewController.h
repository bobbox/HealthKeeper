//
//  TPUserWeightViewController.h
//  HealthKeeper
//
//  Created by apple on 15/8/8.
//  Copyright (c) 2015年 山西协康云享科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPWeightView.h"
#import "TPTabSubViewController.h"
@interface TPUserWeightViewController : TPTabSubViewController<TPWeightDelegate>
@property (strong, nonatomic) IBOutlet UIView *myKeDuBgView;
@property (strong, nonatomic) IBOutlet UILabel *myWeightNumLabel;
@property (strong, nonatomic) IBOutlet TPWeightView *myWeightView;
- (IBAction)back:(id)sender;

- (IBAction)doNextStep:(id)sender;
@end
