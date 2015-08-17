//
//  TPVersionUpdateViewController.m
//  TonguePep
//
//  Created by apple on 15/4/14.
//  Copyright (c) 2015年 山西协康云享科技有限公司. All rights reserved.
//

#import "TPVersionUpdateViewController.h"
#import "ASIFormDataRequest.h"
#import <PgySDK/PgyManager.h>
@interface TPVersionUpdateViewController ()

@end

@implementation TPVersionUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)update:(id)sender {
    ASIFormDataRequest *appRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://www.pgyer.com/apiv1/app/getAppKeyByShortcut"]];
    [appRequest setPostValue:@"17M5" forKey:@"shortcut"];
    [appRequest setPostValue:@"1e9bf8d7241f978c5a2773ab276d0e66" forKey:@"_api_key"];
    
    [appRequest startSynchronous];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:appRequest.responseData options:NSJSONReadingMutableLeaves error:nil];
    NSString *code = [dic    objectForKey:@"code"];
    if (code.intValue==0){
    
   // NSString *returnStr = [[NSString alloc]initWithData:appRequest.responseData encoding:NSUTF8StringEncoding];
        NSDictionary *dic1 = [dic objectForKey:@"data"];
       
        NSString *appKey = [dic1 objectForKey:@"appKey"];
        
    
    //NSString *requestString = [NSString stringWithFormat:@"itms-services://?action=download-manifest&url=https://ssl.pgyer.com/app/plist/f59c58fccb57e83f4ac46c049d17c2d9"];
    // NSString *childName = [postStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
   // NSString *requestString = [NSString stringWithFormat:@"itms-services://?action=download-manifest&url=https://ssl.pgyer.com/app/plist/f59c58fccb57e83f4ac46c049d17c2d9"];
   // NSString *requestStr = [requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *requestString = [NSString stringWithFormat:@"http://www.pgyer.com/apiv1/app/install?_api_key=1e9bf8d7241f978c5a2773ab276d0e66&aKey=%@",appKey];
    // 请求的URL地址
   // NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[ NSURL URLWithString:requestString]];
        [[PgyManager sharedPgyManager] updateLocalBuildNumber];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:requestString]];
      
        exit(0);
    }
}

- (IBAction)cancel:(id)sender {
    [self.view removeFromSuperview];
}

- (IBAction)close:(id)sender {
    [self.view removeFromSuperview];
}
@end
