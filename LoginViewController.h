//
//  LoginViewController.h
//  HealthKeeper
//
//  Created by apple on 15/7/21.
//  Copyright (c) 2015年 山西协康云享科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CUSProgressViewController.h"
@interface LoginViewController : CUSProgressViewController
@property (strong, nonatomic) IBOutlet UITextField *myPhoneNumTextField;
@property (strong, nonatomic) IBOutlet UITextField *myPassWordTextField;

- (IBAction)doLogin:(id)sender;

- (IBAction)doForgertPassWord:(id)sender;
- (IBAction)doRegister:(id)sender;

- (IBAction)doBack:(id)sender;
@end
