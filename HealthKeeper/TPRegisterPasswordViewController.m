//
//  TPRegisterPasswordViewController.m
//  TonguePep
//
//  Created by apple on 15-2-8.
//  Copyright (c) 2015年 山西协康云享科技有限公司. All rights reserved.
//

#import "TPRegisterPasswordViewController.h"
#import "ASIFormDataRequest.h"
#import "customDefine.h"
#import "TPUserResultViewController.h"

@interface TPRegisterPasswordViewController ()

@end

@implementation TPRegisterPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = YES;
    self.myBgView.backgroundColor = STYLECOLOR;
    self.myBgImageView.image = self.myImg;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)finishRegister:(id)sender {
    if (self.myPasswordTextField.text==nil||(![self.myPasswordTextField.text isEqualToString:self.myCheckPasswordTextField.text])){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您输入的密码不一致" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if (self.myPasswordTextField.text.length<6){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您输入最少6位的密码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if (self.myPasswordTextField.text.length>20){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您输入的密码长度超过了20位" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }

    [self MBProgressWithTitle:@"提交中..."];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:REGISTERADDRESS]];
    [request setPostValue:[NSString stringWithFormat:@"%@",self.userPhoneNum] forKey:@"phoneNum"];
    [request setPostValue:self.myPasswordTextField.text forKey:@"password"];
    request.delegate = self;
    [request setTimeOutSeconds:10];
    [request startAsynchronous];
    
}

- (IBAction)doNextStep:(id)sender {
    TPUserResultViewController *vc = [[TPUserResultViewController alloc]init];
    [self.navigationController pushViewController: vc animated:YES];
}


-(void)requestFinished:(ASIHTTPRequest*)request{
    NSData *data = [request responseData];
    NSString *getStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"data:%@",getStr);
    progress.hidden = YES;
    //判断返回的数据是否注册成功
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSString *msg = [dic  objectForKey:@"status"];
    if ([msg isEqualToString:@"SUCCESS"]){
    
    [[NSUserDefaults standardUserDefaults] setObject:self.userPhoneNum forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setObject:self.myPasswordTextField.text  forKey:@"password"];
//        [TPTonguePhoto appDelegate].newUser = YES;
     
        TPUserResultViewController *vc = [[TPUserResultViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该手机号已经注册" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"登录完成" object:nil];
    
}
- (void)requestFailed:(ASIHTTPRequest *)request{
    NSError *error = [request error];
    NSLog(@"error:%@",[error localizedDescription]);
    progress.hidden = YES;
}

@end
