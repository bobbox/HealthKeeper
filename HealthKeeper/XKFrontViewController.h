//
//  XKFrontViewController.h
//  HealthKeeper
//
//  Created by wangzhipeng on 15/7/17.
//  Copyright (c) 2015年 山西协康云享科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XKFrontViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *myLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *myNoLoginBtn;
@property (strong, nonatomic) IBOutlet UIImageView *myBgImageView;

- (IBAction)doLogin:(id)sender;
- (IBAction)doMain:(id)sender;

@end
