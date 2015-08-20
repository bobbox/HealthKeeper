//
//  TPDetectWithImageViewController.m
//  HealthKeeper
//
//  Created by apple on 15/8/18.
//  Copyright (c) 2015年 山西协康云享科技有限公司. All rights reserved.
//

#import "TPDetectWithImageViewController.h"

@interface TPDetectWithImageViewController ()

@end

@implementation TPDetectWithImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.myTestTableVIew.transform =  CGAffineTransformMakeRotation((90.0f * M_PI) / 180.0f);
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

@end
