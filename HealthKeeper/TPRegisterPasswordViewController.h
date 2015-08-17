//
//  TPRegisterPasswordViewController.h
//  TonguePep
//
//  Created by apple on 15-2-8.
//  Copyright (c) 2015年 山西协康云享科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CUSProgressViewController.h"

@interface TPRegisterPasswordViewController : CUSProgressViewController
@property (nonatomic,strong)NSString *userPhoneNum;
@property (strong, nonatomic) IBOutlet UITextField *myPasswordTextField;
@property (strong, nonatomic) IBOutlet UITextField *myCheckPasswordTextField;
@property (weak, nonatomic) IBOutlet UIImageView *myBgImageView;
@property (weak, nonatomic) IBOutlet UIView *myBgView;
@property (nonatomic,strong)UIImage *myImg;


- (IBAction)back:(id)sender;
- (IBAction)finishRegister:(id)sender;
- (IBAction)doNextStep:(id)sender;

@end
