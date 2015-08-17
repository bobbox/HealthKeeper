//
//  TPTabSubViewController.m
//  HealthKeeper
//
//  Created by wangzhipeng on 15/8/15.
//  Copyright (c) 2015年 山西协康云享科技有限公司. All rights reserved.
//

#import "TPTabSubViewController.h"

@interface TPTabSubViewController ()

@end

@implementation TPTabSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tabBarController.tabBar.hidden = YES;
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
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
}
@end
