//
//  XKFrontViewController.m
//  HealthKeeper
//
//  Created by wangzhipeng on 15/7/17.
//  Copyright (c) 2015年 山西协康云享科技有限公司. All rights reserved.
//

#import <PgySDK/PgyManager.h>
#import "XKFrontViewController.h"
#import "TPHttpRequest.h"
#import "TPUserRegisterUserInfoViewController.h"
#import "LoginViewController.h"
#import "TPMainViewController.h"
#import "customDefine.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "TPVersionUpdateViewController.h"
#import "TPTapViewController.h"

@interface XKFrontViewController ()
@property (nonatomic,strong) NSTimer *myTimer;
@property (nonatomic,strong) TPVersionUpdateViewController *myVersionUpdateViewController;
@end

@implementation XKFrontViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = YES;
    
    self.myLoginBtn.layer.cornerRadius = 20;
    self.myLoginBtn.layer.masksToBounds = YES;
    
    self.myNoLoginBtn.layer.cornerRadius = 20;
    self.myNoLoginBtn.layer.masksToBounds = YES;
    self.myNoLoginBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.myNoLoginBtn.layer.borderWidth = 2.0;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"YYYY-MM-dd";
    NSDate *date = [NSDate date];
    NSString *dateStr = [formatter stringFromDate:date];
    NSData *theData = [[NSUserDefaults standardUserDefaults] objectForKey:dateStr];
    if (theData==nil){

    [self getHttpData];
    }
    else{
       NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:theData options:NSJSONReadingMutableLeaves error:nil];
        NSDictionary *theDic = [dic  objectForKey:@"bean"];
        NSString  *urlStr= [theDic objectForKey:@"imagePath"];
        [self.myBgImageView setImageWithURL:[NSURL URLWithString:urlStr]];
        [self.myTimer invalidate];
    }
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    if (username!=nil){
        //可能需要登录获取数据
        
        TPTapViewController *vc = [[TPTapViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    
    
 [[PgyManager sharedPgyManager] checkUpdateWithDelegete:self selector:@selector(versionUpdate:)];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    if (username!=nil){
        //可能需要登录获取数据
        
        TPTapViewController *vc = [[TPTapViewController alloc]init];
        [self.navigationController pushViewController:vc animated:NO];
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (![TPHttpRequest netReached]){
        [self performSelector:@selector(showNoNetWorkTip) withObject:nil afterDelay:2.0];
        NSTimer *timer = [NSTimer timerWithTimeInterval:10.0 target:self selector:@selector(getHttpData) userInfo:nil repeats:YES];
        self.myTimer = timer;
        [[NSRunLoop  currentRunLoop] addTimer:self.myTimer forMode:NSDefaultRunLoopMode];
       
  }


}
-(void)viewDidDisappear:(BOOL)animated  {
    [super viewDidDisappear:animated];
    [self.myTimer invalidate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showNoNetWorkTip{
    [TPHttpRequest showMessage:@"请检查网络连接"];

}
-(void)getHttpData{
    NSLog(@"取数据");
    if([TPHttpRequest netReached]){
       
    //判断用户是否登陆过
    [self getUserData];
    //获取遮罩页数据
    [self getNextDayData];
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"YYYY-MM-dd";
        NSDate *date = [NSDate date];
        NSString *dateStr = [formatter stringFromDate:date];
        NSData *theData = [[NSUserDefaults standardUserDefaults] objectForKey:dateStr];

        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:theData options:NSJSONReadingMutableLeaves error:nil];
        NSDictionary *theDic = [dic  objectForKey:@"bean"];
        NSString  *urlStr= [theDic objectForKey:@"imagePath"];
        [self.myBgImageView setImageWithURL:[NSURL URLWithString:urlStr]];
        [self.myTimer invalidate];
    }
    else{
         [TPHttpRequest showMessage:@"请检查网络连接"];
    }
}

-(void)getUserData{
    
    if ([TPHttpRequest netReached]){
        NSString *phoneNum = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNum"];
        NSString *passWordStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
        //登录
        if (phoneNum!=nil&&phoneNum.length!=0){
            //先要登录
            NSString *postStr = [NSString stringWithFormat:@"username=%@&password=%@",phoneNum,passWordStr];
            
            //        NSString *childName = [postStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSData *requestData = [postStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
            
            // 请求的URL地址
            //NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[@"http://120.27.36.130/TonguePepSys/task/get?"  stringByAppendingString:childName]]];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:LOGINADDRESS]];
            [request setHTTPBody:requestData];
            [request setHTTPMethod:@"post"];
            
            // 执行请求
            NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            NSString *getStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSString *str2 = [getStr stringByReplacingOccurrencesOfString:@"null" withString:@"\"未设置\""];
            NSData *newData = [str2 dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
            NSLog(@"data:%@",getStr);
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:newData options:NSJSONReadingMutableLeaves error:nil];
            
            NSString *result = [dic objectForKey:@"status"];
            if ([result isEqualToString:@"LOGIN_SUCCESS"]){
                [[NSUserDefaults standardUserDefaults] setObject:dic  forKey:@"userDic"];
                
                
                TPMainViewController *vc = [[TPMainViewController alloc]init];
                [self.navigationController pushViewController:vc animated:NO];
            }
        }
    }
    else{
        NSLog(@"无网络    ");
    }
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)getNextDayData{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"YYYY-MM-dd";
    NSDate *date = [NSDate date];
    NSString *dateStr = [formatter stringFromDate:date];
    NSData *theData = [[NSUserDefaults standardUserDefaults] objectForKey:dateStr];
    if (theData==nil){
    
    
        NSString *postStr = [NSString stringWithFormat:@"deviceId=%@",DEFINEUSERID];
    
    //        NSString *childName = [postStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
        NSData *requestData = [postStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    // 请求的URL地址
    //NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[@"http://120.27.36.130/TonguePepSys/task/get?"  stringByAppendingString:childName]]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:NEXTDAYURL]];
        [request setHTTPBody:requestData];
        [request setHTTPMethod:@"post"];
    
    // 执行请求
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //    NSString *getStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    //    NSString *str2 = [getStr stringByReplacingOccurrencesOfString:@"null" withString:@"\"未设置\""];
    //    NSData *newData = [str2 dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    //    NSLog(@"data:%@",getStr);
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"YYYY-MM-dd";
    NSDate *date = [NSDate date];
    NSString *dateStr = [formatter stringFromDate:date];
    [[NSUserDefaults standardUserDefaults] setValue:data forKey:dateStr];
    
    }
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//    [TPHttpRequest appDelegate].appNextDayDic = dic;
}


- (IBAction)doLogin:(id)sender {
    LoginViewController *vc = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)doMain:(id)sender {
    TPTapViewController *vc = [[TPTapViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)versionUpdate:(id)sender{
    NSLog(@"new version");
    NSDictionary *dic = (NSDictionary*)sender;
    if (dic!=nil){
//        NSString *version = [dic  objectForKey:@"versionName"];
//        NSString *myVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
//        if (![myVersion isEqualToString:version]){
            //[[NSUserDefaults standardUserDefaults] setObject:downloadUrl forKey:@"download"];
            
            self.myVersionUpdateViewController = [[TPVersionUpdateViewController alloc]init];
            self.myVersionUpdateViewController.view.frame = self.view.frame;
            self.myVersionUpdateViewController.myUpdateVersionLabel.text = [NSString stringWithFormat:@"更新日志V%@",[dic objectForKey:@"versionName"]];
            NSString *detailStr = [dic objectForKey:@"releaseNote"];
            self.myVersionUpdateViewController.myUpdateDetailTextView.text = detailStr;
            UIWindow * window = [UIApplication sharedApplication].keyWindow;
          [window addSubview:self.myVersionUpdateViewController.view];

            //[[PgyManager sharedPgyManager] updateLocalBuildNumber];
//        }
    }
  //  [[PgyManager sharedPgyManager] checkUpdate];
}

@end
