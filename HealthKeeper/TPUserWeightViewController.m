//
//  TPUserWeightViewController.m
//  HealthKeeper
//
//  Created by apple on 15/8/8.
//  Copyright (c) 2015年 山西协康云享科技有限公司. All rights reserved.
//

#import "TPUserWeightViewController.h"
#import "TPUserTonguePepViewController.h"
#import "TPHttpRequest.h"
@interface TPUserWeightViewController ()

@end

@implementation TPUserWeightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   // [self prepareScrollView:self.myScrollView];
    self.myWeightView.delegate = self;
     [[TPHttpRequest appDelegate].userAccountDic setObject:[NSString stringWithFormat:@"50"] forKey:@"userWeight"];
    
    NSString *sexStr = [[TPHttpRequest appDelegate].userAccountDic objectForKey:@"userSex"];
    if ([sexStr isEqualToString:@"男"]){
        self.myWeightNumLabel.text = [NSString stringWithFormat:@"%i",60];
}
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)numberPickerViewDidChangeValue:(int)num{

    self.myWeightNumLabel.text = [NSString stringWithFormat:@"%i",num];
     [[TPHttpRequest appDelegate].userAccountDic setObject:self.myWeightNumLabel.text forKey:@"userWeight"];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)doNextStep:(id)sender {
    TPUserTonguePepViewController *vc = [[TPUserTonguePepViewController alloc]init];
    [self.navigationController pushViewController:vc animated:NO];
}
@end
