//
//  TPUserSexSettingViewController.m
//  HealthKeeper
//
//  Created by apple on 15/8/8.
//  Copyright (c) 2015年 山西协康云享科技有限公司. All rights reserved.
//

#import "TPUserSexSettingViewController.h"
#import "TPUserBirthdayViewController.h"
#import "TPHttpRequest.h"
@interface TPUserSexSettingViewController ()
@property (nonatomic,strong) UIColor *myBtnBgColor;
@end

@implementation TPUserSexSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.myBtnBgColor = self.myWomenBtn.backgroundColor;
    self.myBtnBgColor = [self.myWomenBtn.backgroundColor copy];
    self.myWomenBtn.layer.cornerRadius = 4.0;
    self.myWomenBtn.layer.masksToBounds = YES;
    self.myManBtn.layer.cornerRadius = 4.0;
    self.myManBtn.layer.masksToBounds = YES;
    [[TPHttpRequest appDelegate].userAccountDic setObject:[NSString stringWithFormat:@"男"] forKey:@"userSex"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated{
    [super    viewDidAppear:animated];
 
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)sexBtnPressed:(id)sender {
    UIButton *btn = (UIButton*)sender;
    if (btn==self.myWomenBtn){
        self.myWomenBtn.backgroundColor = [UIColor orangeColor];
        self.myManBtn.backgroundColor = [UIColor colorWithWhite:0.859 alpha:1.000];
         [[TPHttpRequest appDelegate].userAccountDic setObject:[NSString stringWithFormat:@"女"] forKey:@"userSex"];
    }
    else{
        self.myWomenBtn.backgroundColor = [UIColor colorWithWhite:0.859 alpha:1.000];
        self.myManBtn.backgroundColor = [UIColor colorWithRed:0.271 green:0.729 blue:0.714 alpha:1.000];
         [[TPHttpRequest appDelegate].userAccountDic setObject:[NSString stringWithFormat:@"男"] forKey:@"userSex"];
    }
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)doNextStep:(id)sender {
    TPUserBirthdayViewController  *vc = [[TPUserBirthdayViewController alloc]init];
    [self.navigationController pushViewController:vc animated:NO];
}
@end
