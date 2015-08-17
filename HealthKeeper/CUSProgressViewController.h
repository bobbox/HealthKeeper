//
//  CUSProgressViewController.h
//  HealthRecorder
//
//  Created by apple on 14-9-17.
//  Copyright (c) 2014年 xkyx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "TPTabSubViewController.h"
@interface CUSProgressViewController : TPTabSubViewController
{
    MBProgressHUD *progress;
    
}

@property (retain, nonatomic)MBProgressHUD *progress;

-(void)MBProgressWithTitle:(NSString *)title;
//-(void)MBProgress;
- ( AppDelegate*)appDelegate;
@end
