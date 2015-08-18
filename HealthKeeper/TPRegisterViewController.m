//
//  TPRegisterViewController.m
//  TonguePep
//
//  Created by apple on 15-2-8.
//  Copyright (c) 2015年 山西协康云享科技有限公司. All rights reserved.
//

#import "TPRegisterViewController.h"
#import "TPRegisterPasswordViewController.h"
#import "customDefine.h"
#import <SMS_SDK/SMS_SDK.h>
@interface TPRegisterViewController ()
@property (nonatomic,strong) NSTimer *myCodeTimer;
@property (nonatomic) int codeCount;

@end

@implementation TPRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = YES;
    self.myBgView.backgroundColor = STYLECOLOR;
    self.myBgImageView.image = self.myImg;
    self.codeCount = 60;
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showPasswordPage:(id)sender {
    [self.view endEditing:YES];
    
    
    
    if(self.verifyCodeField.text.length!=4)
    {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示"
                                                      message:@"输入的验证码长度有误"
                                                     delegate:self
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        //[[SMS_SDK sharedInstance] commitVerifyCode:self.verifyCodeField.text];
        [SMS_SDK commitVerifyCode:self.verifyCodeField.text result:^(enum SMS_ResponseState state) {
            if (1==state)
            {
                NSLog(@"验证成功");
               // NSString* str=[NSString stringWithFormat:NSLocalizedString(@"verifycoderightmsg", nil)];
//                UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"verifycoderighttitle", nil)
//                                                              message:str
//                                                             delegate:self
//                                                    cancelButtonTitle:NSLocalizedString(@"sure", nil)
//                                                    otherButtonTitles:nil, nil];
//                [alert show];
                
                TPRegisterPasswordViewController *vc = [[TPRegisterPasswordViewController alloc]init];
                vc.myImg = self.myImg;
                vc.userPhoneNum = self.telField.text;
                [self.navigationController pushViewController:vc animated:YES];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            else if(0==state)
            {
                NSLog(@"验证失败");
                NSString* str=[NSString stringWithFormat:NSLocalizedString(@"验证码错误！", nil)];
                UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil)
                                                              message:str
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                                    otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
    }

    
    
    
   
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)getAuth:(id)sender {
    if (self.telField.text.length!=11||[self.telField.text containsString:@"+"]||[self.telField.text containsString:@"*"]||[self.telField.text containsString:@"#"] )
    {
        //手机号码不正确
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示"                                                      message:@"手机号码有误！"
                                                     delegate:self
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    NSString* str=[NSString stringWithFormat:@"%@: %@",NSLocalizedString(@"我们将发送验证码短信到这个号码", nil),self.telField.text];
    //_str=[NSString stringWithFormat:@"%@",self.telField.text];
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"确认手机号码"
                                                  message:str delegate:self
                                        cancelButtonTitle:@"取消"
                                        otherButtonTitles:@"确定", nil];
    [alert show];
    
    self.myCodeBtn.enabled = NO;
    self.myCodeTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(startCount) userInfo:nil repeats:YES];
    [self.myCodeBtn setTitle:@"60秒" forState:UIControlStateNormal];
    [[NSRunLoop currentRunLoop] addTimer:self.myCodeTimer forMode:NSDefaultRunLoopMode];
    

}

-(void)startCount{
    NSLog(@"count,codeCount = %i",self.codeCount);
    NSString *codeStr = [NSString stringWithFormat:@"%i秒",self.codeCount];
    [self.myCodeBtn setTitle:codeStr forState:UIControlStateNormal];
     [self.myCodeBtn setTitle:codeStr forState:UIControlStateDisabled];
    
    if (self.codeCount==0){
        self.codeCount = 60;
        self.myCodeBtn.enabled = YES;
        [self.myCodeBtn setTitle:@"获取" forState:UIControlStateNormal];
        [self.myCodeBtn setTitle:@"获取" forState:UIControlStateDisabled];
        [self.myCodeTimer invalidate];
    }
    else{
        self.codeCount--;
        self.myCodeBtn.enabled = NO;
    }
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1==buttonIndex)
    {
//        SubmitViewController* verify=[[SubmitViewController alloc] init];
        NSString* str2=[@"+86" stringByReplacingOccurrencesOfString:@"+" withString:@""];
       // [verify setPhone:self.telField.text AndAreaCode:str2];
        
        [SMS_SDK getVerificationCodeBySMSWithPhone:self.telField.text
                                                    zone:str2
                                                  result:^(SMS_SDKError *error)
         {
             
             if (!error)
             {
                 NSLog(@"%@",error.description);
             }
             else
             {
                 UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil)
                                                               message:[NSString stringWithFormat:@"状态码：%zi ,错误描述：%@",error.errorCode,error.errorDescription]
                                                              delegate:self
                                                     cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                                     otherButtonTitles:nil, nil];
                 [alert show];
             }
             
         }];
    }
}


- (IBAction)next:(id)sender {
    TPRegisterPasswordViewController *vc = [[TPRegisterPasswordViewController alloc]init];
    vc.myImg = self.myImg;
    vc.userPhoneNum = self.telField.text;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
