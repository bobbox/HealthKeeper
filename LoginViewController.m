//
//  LoginViewController.m
//  HealthKeeper
//
//  Created by apple on 15/7/21.
//  Copyright (c) 2015年 山西协康云享科技有限公司. All rights reserved.
//

#import "LoginViewController.h"
#import "ASIFormDataRequest.h"
#import "customDefine.h"
#import "TPMainViewController.h"
#import "TPUserSexSettingViewController.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doHidden)];
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)doHidden{
    [self.view endEditing:YES];
}

- (IBAction)doLogin:(id)sender {
    [self.view endEditing:YES];
    [self MBProgressWithTitle:@"登录中..."];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:LOGINADDRESS]];
    [request setPostValue:self.myPhoneNumTextField.text forKey:@"username"];
    [request setPostValue:self.myPassWordTextField.text forKey:@"password"];
    request.delegate = self;
    [request setTimeOutSeconds:10];
    [request startAsynchronous];
}

-(void)requestFinished:(ASIHTTPRequest*)request{
    NSData *data = [request responseData];
    NSString *getStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSString *str2 = [getStr stringByReplacingOccurrencesOfString:@"null" withString:@"\"未设置\""];
    NSData *newData = [str2 dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSLog(@"data:%@",getStr);
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:newData options:NSJSONReadingMutableLeaves error:nil];
    NSString *result = [dic objectForKey:@"status"];
    if ([result isEqualToString:@"SUCCESS"]){
        
        [[NSUserDefaults standardUserDefaults] setObject:self.myPhoneNumTextField.text forKey:@"username"];
        [[NSUserDefaults standardUserDefaults] setObject:self.myPassWordTextField.text  forKey:@"password"];
        [[NSUserDefaults standardUserDefaults] setObject:dic  forKey:@"userDic"];
        
        
        [self.navigationController popViewControllerAnimated:YES];
//        [[NSUserDefaults standardUserDefaults] setObject:self.myPhoneNumTextField.text forKey:@"phoneNum"];
//        [[NSUserDefaults standardUserDefaults] setObject:self.myPassWordTextField.text  forKey:@"password"];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"登录完成" object:nil];
//       
//        NSDictionary *userDic = [dic objectForKey:@"bean"];
//        [[NSUserDefaults standardUserDefaults] setObject:userDic forKey:@"userLoginDic"];
//        
//        //获取舌拍数据
//        NSDictionary *dataDic = [userDic objectForKey:@"profile"];
//        NSDictionary *tongueDic =  [dataDic objectForKey:@"tongueProfile"];
//        NSDictionary *bodyTestDic = [dataDic objectForKey:@"physiqueProfile"];
//        [[NSUserDefaults standardUserDefaults] setObject:tongueDic forKey:@"tongueDic"];
//        [[NSUserDefaults standardUserDefaults] setObject:bodyTestDic forKey:@"bodyTestDic"];
//        //获取舌拍图片
//        if(tongueDic!=nil){
//            NSString *urlStr = [tongueDic objectForKey:@"tonguePath"];
//            ASIHTTPRequest *imgRequest = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:urlStr]];
//            [imgRequest startSynchronous];
//            NSData *imgData = [imgRequest responseData];
//            [[NSUserDefaults standardUserDefaults] setObject:imgData forKey:@"tongueImage"];
//            
//            
//        }
        
    }
    else{
        NSString *msg = [dic objectForKey:@"msg"];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    progress.hidden = YES;
}
- (void)requestFailed:(ASIHTTPRequest *)request{
    NSError *error = [request error];
    NSLog(@"error:%@",[error localizedDescription]);
    progress.hidden = YES;
}

- (IBAction)doForgertPassWord:(id)sender {
}

- (IBAction)doRegister:(id)sender {
    TPUserSexSettingViewController *vc = [[TPUserSexSettingViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)doBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
