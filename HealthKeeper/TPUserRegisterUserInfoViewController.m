//
//  TPUserRegisterUserInfoViewController.m
//  HealthKeeper
//
//  Created by apple on 15/7/18.
//  Copyright (c) 2015年 山西协康云享科技有限公司. All rights reserved.
//

#import "TPUserRegisterUserInfoViewController.h"
#import "TPUserWeightViewController.h"
#import "TPHttpRequest.h"
@interface TPUserRegisterUserInfoViewController ()

@end

@implementation TPUserRegisterUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.myHeightView.delegate = self;
    [[TPHttpRequest appDelegate].userAccountDic setObject:[NSString stringWithFormat:@"170"] forKey:@"userHeight"];
    
    


}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.myHeightView resetNumber1OffSet:CGPointMake(0, 14*50)];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
   }
- (void)numberPickerViewDidChangeValue:(SLNumberPickerView *)picker {
    NSString* valueString = [NSString stringWithFormat:@"%li", (long)picker.value];
    self.myHeightLabel.text = [NSString stringWithFormat:@"%@",valueString];
    NSLog(@"value%@",valueString);
    [[TPHttpRequest appDelegate].userAccountDic setObject:[NSString stringWithFormat:@"%@",valueString] forKey:@"userHeight"];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"myCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell==nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%li",(long)indexPath.row];
    
    return cell;
    
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)doNextStep:(id)sender {
    TPUserWeightViewController  *vc = [[TPUserWeightViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:NO];
}
@end
