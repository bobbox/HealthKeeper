//
//  TPHttpRequest.m
//  HealthKeeper
//
//  Created by wangzhipeng on 15/7/18.
//  Copyright (c) 2015年 山西协康云享科技有限公司. All rights reserved.
//

#import "TPHttpRequest.h"
#import "Reachability.h"
@implementation TPHttpRequest
@synthesize myRequestData;
+(NSData*)getHttpRequestWithUrl:(NSString*)url andRequestData:(NSData*)theData{
   
   
   __block NSData *returnData;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:theData];
    //[request setValue:@"application" forHTTPHeaderField:@"Content-Type"];
    
//    NSString *tempStr = [[NSString alloc]initWithData:tempJsonData encoding:NSUTF8StringEncoding];
//    
//    NSLog(@"%@",tempStr);
    // 4.发送请求
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"~~~~~~~%lu,%@", (unsigned long)data.length,str);
        NSString *resultStr = @"保存失败";
        if (data!=nil){
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSString *result = [dic   objectForKey:@"status"];
            if ([result isEqualToString:@"SUCCESS"]||[result isEqualToString:@"SUCCESS_AND_TASK_COMPLETED"]){
                resultStr = @"保存成功";
                NSDictionary *dic1 = [dic objectForKey:@"bean"];
                NSArray *ary = [dic1 objectForKey:@"shitRecords"];
            
//                [self.myRecordAry removeAllObjects];
//                [self.myRecordAry addObjectsFromArray:ary];
//                [self startTimer];
//                [self cleanSelects];
                //[self performSelectorInBackground:@selector(commitMissionCompleted) withObject:nil];
            }
            
        }
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"已保存" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//        return data ;
        
    }];
    return returnData;
    }


+ ( AppDelegate*)appDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

+(BOOL)netReached{
    // 1.检测wifi状态
       Reachability *wifi = [Reachability reachabilityForLocalWiFi];
    
         // 2.检测手机是否能上网络(WIFI\3G\2.5G)
         Reachability *conn = [Reachability reachabilityForInternetConnection];
    
       // 3.判断网络状态
        if ([wifi currentReachabilityStatus] != NotReachable) { // 有wifi
                NSLog(@"有wifi");
            return YES;
    
            } else if ([conn currentReachabilityStatus] != NotReachable) { // 没有使用wifi, 使用手机自带网络进行上网
                    NSLog(@"使用手机自带网络进行上网");
                return YES;
            
                 } else { // 没有网络
                     
                         NSLog(@"没有网络");
                     return NO;
                    }
}
+(void)showMessage:(NSString *)message
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *showview =  [[UIView alloc]init];
    showview.backgroundColor = [UIColor blackColor];
    showview.frame = CGRectMake(1, 1, 1, 1);
    showview.alpha = 1.0f;
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    [window addSubview:showview];
    
    UILabel *label = [[UILabel alloc]init];
    CGSize LabelSize = [message sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(290, 9000)];
    label.frame = CGRectMake(10, 5, LabelSize.width, LabelSize.height);
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = 1;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:15];
    [showview addSubview:label];
    showview.frame = CGRectMake(( [UIScreen mainScreen].bounds.size.width- LabelSize.width - 20)/2, [UIScreen mainScreen].bounds.size.height/2, LabelSize.width+20, LabelSize.height+10);
    
//    [UIView animateWithDuration:2.0 animations:^{
//        showview.alpha = 0;
//    } completion:^(BOOL finished) {
//        [showview removeFromSuperview];
//    }];
    
    [UIView animateKeyframesWithDuration:2.0 delay:2.0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
        showview.alpha = 0;
    } completion:^(BOOL finished) {
        [showview removeFromSuperview];
    }];
}

+(void)checkUpdate{
    
}
@end
