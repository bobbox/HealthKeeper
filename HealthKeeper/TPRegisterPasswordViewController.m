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
@property (nonatomic,strong) NSString *myUrl;
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
//    [self MBProgressWithTitle:@"正在保存..."];
//    [self updateUserInfo];
//    TPUserResultViewController *vc = [[TPUserResultViewController alloc]init];
//    [self.navigationController pushViewController: vc animated:YES];
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
     self.myRegisterSuccessDic = dic;
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
    NSLog(@"updateUserINFO");
    NSString *sex = @"";
    NSString *sexSaved = [[TPHttpRequest appDelegate].userAccountDic objectForKey:@"userSex"];
    if ([sexSaved isEqualToString:@"男"])
        sex = @"M";
    else sex = @"F";
    NSString *place = [[NSUserDefaults  standardUserDefaults] objectForKey:@"place"];
    NSString *locationStr = @"";
    if (place!=nil)
    locationStr = [NSString stringWithFormat:@"home=%@",[[NSUserDefaults  standardUserDefaults] objectForKey:@"place"]];
    
    
//    NSString *sendStr = [NSString stringWithFormat:@"authToken=%@&userId=%@&height=%@&weight=%@%@&birthday=%@",[theDic objectForKey:@"authToken"],[theDic objectForKey:@"id"],[delegateDic  objectForKey:@"userHeight"],[delegateDic  objectForKey:@"userWeight"],locationStr,[delegateDic objectForKey:@"userBirthday"]];
//    NSString *newStr = [sendStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
   NSString  *myUrl =[NSString  stringWithFormat: @"%@",USER_UPLOAD_INFO_URL];
    self.myUrl = myUrl;
    //myUrl =[NSString  stringWithFormat: @"%@?phoneNum=15296611713",TPSERVERADDRESS];
    NSLog(@"%@",myUrl);
   
    
    ASIFormDataRequest *request =[ [ASIFormDataRequest alloc]initWithURL:[NSURL URLWithString:self.myUrl]];
    //[request setURL:[NSURL URLWithString:@"http://120.27.36.130/MicroHealth/user/register_info?authToken=eeec5bde22ddfb54127412985635fb9a&userId=55d421050cf29c8eb7fd3bf0&height=170&weight=50&home=山西,太原&birthday=2015-08-19"]];
     NSData *imageData = UIImageJPEGRepresentation([TPHttpRequest appDelegate].myTongueImg,0.7);
    //获取系统时间定义图片名字
    NSString* date;
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYYMMddHHmmss"];
    date = [formatter stringFromDate:[NSDate date]];
    
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    username = @"15796611713";
    NSString *fileName = [NSString stringWithFormat:@"%@%@.jpg",username,date];
    NSLog(@"%@,DATA legth:%lu",fileName, (unsigned long)imageData.length);
    
//    UIProgressView *myProgress = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleBar];
//    myProgress.frame = CGRectMake(10, 50, 300, 20);
    
    [request setData:imageData withFileName:fileName andContentType:nil forKey:@"tongueImage"];
    NSDictionary *theDic = [self.myRegisterSuccessDic objectForKey:@"bean"];
    NSMutableDictionary *delegateDic = [TPHttpRequest appDelegate].userAccountDic;
//    [request setPostValue:@"c2ba5efeff5debe8fab44ba5160535a9" forKey:@"authToken"];
    [request setPostValue:[theDic objectForKey:@"id"] forKey:@"userId"];
     [request setPostValue:[delegateDic  objectForKey:@"userHeight"] forKey:@"height"];
     [request setPostValue:[delegateDic  objectForKey:@"userWeight"] forKey:@"weight"];
     [request setPostValue:[delegateDic  objectForKey:@"userBirthday"] forKey:@"birthday"];
    [request setPostValue:sex forKey:@"sexual"];
    if (locationStr.length!=0){
        NSString *str1 = [locationStr stringByReplacingOccurrencesOfString:@"," withString:@" "];
        [request setPostValue:locationStr forKey:@"home"];
    }
    
   // [request setData:imageData forKey:@"tongueImage"];
    [request addRequestHeader:@"authToken" value:[theDic objectForKey:@"authToken"]];
    
    request.timeOutSeconds = 360;
    [request buildPostBody];
    request.tag =2;
    //[request setDelegate:self];
    [request startSynchronous];
    
    NSData *data = request.responseData;
    NSString *resposeStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",resposeStr);
    NSString *getStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSString *str2 = [getStr stringByReplacingOccurrencesOfString:@"null" withString:@"\"未设置\""];
    NSData *newData = [str2 dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    progress.hidden = YES;
    NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:newData options:NSJSONReadingMutableLeaves error:nil];
    NSDictionary *dic1 = [resultDic objectForKey:@"bean"];
    NSDictionary *dic2 = [dic1 objectForKey:@"userTongue"];
    [[NSUserDefaults standardUserDefaults] setObject:dic2 forKey:@"tongueDic"];
    //保存为用户注册成功后返回的数据
    [[NSUserDefaults standardUserDefaults] setObject:resultDic forKey:@"userRegisterDic"];
    [TPHttpRequest appDelegate].tongueDic = [NSMutableDictionary dictionaryWithDictionary:dic2];
    
}
@end
