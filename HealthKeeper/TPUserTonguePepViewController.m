//
//  TPUserTonguePepViewController.m
//  HealthKeeper
//
//  Created by wangzhipeng on 15/8/8.
//  Copyright (c) 2015年 山西协康云享科技有限公司. All rights reserved.
//

#import "TPUserTonguePepViewController.h"
#import "TPTakeTonguePhotoViewController.h"
#import "TPRegisterViewController.h"
#import "TPUserResultViewController.h"
#import "TPHttpRequest.h"
@interface TPUserTonguePepViewController ()

@end

@implementation TPUserTonguePepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  // NSData *data= [[NSUserDefaults standardUserDefaults] objectForKey:@"tongueImage"];
   // self.myTongueImageView.image = [TPHttpRequest appDelegate].myTongueImg;
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
   
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)doNextStep:(id)sender {
    UIImage *img = [TPHttpRequest appDelegate].myTongueImg;
    if (img==nil){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"清先进行舌拍" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    else{
    TPRegisterViewController *vc = [[TPRegisterViewController alloc]init];
    [self.navigationController pushViewController:vc animated:NO];
    }
}

- (IBAction)doTonguePep:(id)sender {
    TPTakeTonguePhotoViewController *vc = [[TPTakeTonguePhotoViewController alloc]init];
    vc.delegate = vc;
    [self presentViewController:vc animated:YES completion:nil];

}
- (IBAction)showResult:(id)sender {
    TPUserResultViewController *vc = [[TPUserResultViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
