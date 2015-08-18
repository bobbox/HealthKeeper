//
//  TPRegisterViewController.h
//  TonguePep
//
//  Created by apple on 15-2-8.
//  Copyright (c) 2015年 山西协康云享科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPTabSubViewController.h"
@interface TPRegisterViewController : TPTabSubViewController<UIAlertViewDelegate>

- (IBAction)showPasswordPage:(id)sender;
- (IBAction)back:(id)sender;
- (IBAction)getAuth:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *telField;
@property (strong, nonatomic) IBOutlet UITextField *verifyCodeField;
@property (weak, nonatomic) IBOutlet UIView *myBgView;
@property (weak, nonatomic) IBOutlet UIImageView *myBgImageView;
@property (nonatomic,strong)UIImage *myImg;
@property (strong, nonatomic) IBOutlet UIButton *myCodeBtn;
- (IBAction)next:(id)sender;

@end
