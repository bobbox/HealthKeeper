//
//  TPUserTonguePepViewController.h
//  HealthKeeper
//
//  Created by wangzhipeng on 15/8/8.
//  Copyright (c) 2015年 山西协康云享科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPTabSubViewController.h"
@interface TPUserTonguePepViewController : TPTabSubViewController
@property (weak, nonatomic) IBOutlet UIImageView *myTongueImageView;

- (IBAction)doTonguePep:(id)sender;

@end
