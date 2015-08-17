//
//  TPUserBirthdayViewController.m
//  HealthKeeper
//
//  Created by wangzhipeng on 15/8/8.
//  Copyright (c) 2015年 山西协康云享科技有限公司. All rights reserved.
//

#import "TPUserBirthdayViewController.h"
#import "TPUserRegisterUserInfoViewController.h"
#import "TPHttpRequest.h"
@interface TPUserBirthdayViewController ()

@end

@implementation TPUserBirthdayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.myDatePicker.maximumDate = [NSDate date];
    
    NSDate *date = self.myDatePicker.date;
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
    dateformatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [dateformatter stringFromDate:date];
    [[TPHttpRequest appDelegate].userAccountDic setObject:dateStr forKey:@"userBirthday"];
    
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

- (IBAction)datePickerValueChanged:(id)sender {
    NSDate *date = self.myDatePicker.date;
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
    dateformatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [dateformatter stringFromDate:date];
    NSLog(@"date:%@",dateStr);
    [[TPHttpRequest appDelegate].userAccountDic setObject:dateStr forKey:@"userBirthday"];

    
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}
- (IBAction)doNextStep:(id)sender {
    TPUserRegisterUserInfoViewController *vc = [[TPUserRegisterUserInfoViewController  alloc]init];
    [self.navigationController pushViewController:vc animated:NO];
}
@end
