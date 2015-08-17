//
//  TPUserRegisterUserInfoViewController.h
//  HealthKeeper
//
//  Created by apple on 15/7/18.
//  Copyright (c) 2015年 山西协康云享科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLNumberPickerView.h"
#import "TPTabSubViewController.h"
@interface TPUserRegisterUserInfoViewController : TPTabSubViewController<SLNumberPickerViewDelegate>

@property (strong, nonatomic) IBOutlet SLNumberPickerView *myHeightView;
@property (weak, nonatomic) IBOutlet UILabel *myHeightLabel;
- (IBAction)doNextStep:(id)sender;

@end
