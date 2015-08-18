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
#import "TPHttpRequest.h"

@interface TPRegisterPasswordViewController ()
@property (nonatomic,strong) NSDictionary *myRegisterSuccessDic;
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
    [request setPostValue:[NSString stringWithFormat:@"%@",self.userPhoneNum] forKey:@"username"];
    [request setPostValue:self.myPasswordTextField.text forKey:@"password"];
    request.delegate = self;
    [request setTimeOutSeconds:10];
    [request startAsynchronous];
    
}

- (IBAction)doNextStep:(id)sender {
    [self MBProgressWithTitle:@"正在保存..."];
    [self updateUserInfo];
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
    self.myRegisterSuccessDic = dic;
    if ([msg isEqualToString:@"SUCCESS"]){
    
    [[NSUserDefaults standardUserDefaults] setObject:self.userPhoneNum forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setObject:self.myPasswordTextField.text  forKey:@"password"];
//        [TPTonguePhoto appDelegate].newUser = YES;
        [self updateUserInfo];
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

-(void)updateUserInfo{
    NSString *sex = @"";
    NSString *sexSaved = [[TPHttpRequest appDelegate].userAccountDic objectForKey:@"userSex"];
    if ([sexSaved isEqualToString:@"男"])
        sex = @"M";
    else sex = @"F";
    NSString *locationStr = [NSString stringWithFormat:@"&home=%@",[[NSUserDefaults  standardUserDefaults] objectForKey:@"place"]];
    
    NSDictionary *theDic = [self.myRegisterSuccessDic objectForKey:@"bean"];
    NSMutableDictionary *delegateDic = [TPHttpRequest appDelegate].userAccountDic;
    NSString *sendStr = [NSString stringWithFormat:@"authToken=%@&userId=%@&height=%@&weight=%@%@&birthday=%@",[theDic objectForKey:@"authToken"],[theDic objectForKey:@"id"],[delegateDic  objectForKey:@"userHeight"],[delegateDic  objectForKey:@"userWeight"],locationStr,[delegateDic objectForKey:@"userBirthday"]];
    
   NSString  *myUrl =[NSString  stringWithFormat: @"%@?%@",USER_UPLOAD_INFO_URL,sendStr];
    //myUrl =[NSString  stringWithFormat: @"%@?phoneNum=15296611713",TPSERVERADDRESS];
    NSLog(@"%@",myUrl);
    NSURL *url = [NSURL URLWithString: myUrl];
    
    NSData *imageData = UIImageJPEGRepresentation([TPHttpRequest appDelegate].myTongueImg,0.7);
    
    ASIFormDataRequest *myRequest = [ASIFormDataRequest requestWithURL:url];
    //获取系统时间定义图片名字
    NSString* date;
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYYMMddHHmmss"];
    date = [formatter stringFromDate:[NSDate date]];
    
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSString *fileName = [NSString stringWithFormat:@"%@%@.jpg",username,date];
    NSLog(@"%@,DATA legth:%lu",fileName, (unsigned long)imageData.length);
    
    UIProgressView *myProgress = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleBar];
    myProgress.frame = CGRectMake(10, 50, 300, 20);
    
    [myRequest setData:imageData withFileName:fileName andContentType:nil forKey:@"file"];
    myRequest.timeOutSeconds = 360;
    [myRequest buildPostBody];
    myRequest.tag =2;
    [myRequest setDelegate:self];
    [myRequest startSynchronous];
    
    NSData *data = myRequest.responseData;
    NSString *resposeStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",resposeStr);
    progress.hidden = YES;
    
}
@end
