//
//  CUSProgressViewController.m
//  HealthRecorder
//
//  Created by apple on 14-9-17.
//  Copyright (c) 2014年 xkyx. All rights reserved.
//

#import "CUSProgressViewController.h"

@interface CUSProgressViewController ()

@end

@implementation CUSProgressViewController
@synthesize progress;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //如果设置此属性则当前的view置于后台
    self.progress.hidden = YES;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)MBProgressWithTitle:(NSString *)title{
    
    //设置对话框文字
    MBProgressHUD *pro = [[MBProgressHUD alloc] initWithView:self.view];
    self.progress = pro;

    self.progress.labelText = title;
    [self.view addSubview:self.progress];
    
    [progress show:YES];
}
- ( AppDelegate*)appDelegate
{
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}
@end
