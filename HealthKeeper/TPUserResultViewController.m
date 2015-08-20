//
//  TPUserResultViewController.m
//  HealthKeeper
//
//  Created by apple on 15/8/10.
//  Copyright (c) 2015年 山西协康云享科技有限公司. All rights reserved.
//

#import "TPUserResultViewController.h"
#import "TPHttpRequest.h"
#import "TPUserHabitCollectionViewCell.h"
@interface TPUserResultViewController ()
@property (nonatomic,strong)NSMutableArray *myTongueAry;
@end

@implementation TPUserResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.myTongueAry = [NSMutableArray array];
    self.myTongueImageView.layer.cornerRadius = 25.0;
    self.myTongueImageView.layer.masksToBounds = YES;
    self.myTongueImageView.layer.borderColor = [UIColor orangeColor].CGColor;
    self.myTongueImageView.layer.borderWidth = 2.0;
    self.myBottomBtn.layer.cornerRadius = 21.0;
    self.myBottomBtn.layer.masksToBounds = YES;
    
    self.myTongueImageView.image = [TPHttpRequest appDelegate].myTongueImg;
    [self.myCollectionView registerNib:[UINib nibWithNibName:@"TPUserHabitCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"cell"];
    
    self.myScollView.contentSize = CGSizeMake(320,1350);
    //个人信息配置
    NSMutableDictionary *userDic = [TPHttpRequest appDelegate].userAccountDic;
    self.mySexLabel.text = [NSString stringWithFormat:@"%@",[userDic objectForKey:@"userSex"]];
    self.myHeightLabel.text = [NSString stringWithFormat:@"%@cm",[userDic objectForKey:@"userHeight"]];
    
 
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
    dateformatter.dateFormat = @"yyyy-MM-dd";
    NSDate *date = [dateformatter dateFromString:[userDic objectForKey:@"userBirthday"]];
    NSTimeInterval dateDiff = [date timeIntervalSinceNow];
    
    int age=trunc(dateDiff/(60*60*24))/365;
    int age1 = abs(age);
    
    self.myAgeLabel.text = [NSString stringWithFormat:@"%i",age1];
    self.myBirthdayLabel.text = [userDic objectForKey:@"userBirthday"];
    self.myWeightLabel.text = [NSString stringWithFormat:@"%@kg",[userDic objectForKey:@"userWeight"]];
    NSString *heightStr = [userDic objectForKey:@"userHeight"];
    NSString *weightStr = [userDic objectForKey:@"userWeight"];
    
    
    NSString *bmiStr = [NSString stringWithFormat:@"%0.2f",weightStr.floatValue/(heightStr.floatValue/100.0*heightStr.floatValue/100)];
    
    NSDictionary *userRegisgerDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"userRegisterDic"];
    NSDictionary *registerDic = [userRegisgerDic objectForKey:@"bean"];
    
    NSString *BMIResultStr = [registerDic objectForKey:@"bmiType"];
//    if (bmiStr.floatValue<18.5)
//    BMIResultStr= @"过轻";
//  else   if (bmiStr.floatValue>=18.5&&bmiStr.floatValue<25)
//        BMIResultStr = @"正常";
//    else
//        BMIResultStr = @"超重";
    
    self.myBMILabel.text = bmiStr;
    self.myShowBMILabel.text = [NSString stringWithFormat:@"您的BMI指数：%@  %@",bmiStr,BMIResultStr];
    
    NSString *locationStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"place"];
    self.myLocationLabel.text = locationStr;
    self.myBMIResultLabel.text = [registerDic objectForKey:@"bmiResult"];
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getNewData];
    self.myMapView.dataAry = [NSArray arrayWithArray:self.myTongueAry];
    self.myMapView.tipAry = [NSArray arrayWithObjects:@"苔色",@"厚度",@"剥落",@"腻腐",@"润燥",@"表面",@"形状",@"舌色", nil];
    self.myMapView.highLevel = 80;
    self.myMapView.lowLevel = 60;
    [self.myMapView setNeedsDisplay];
}

-(void) getNewData{
    NSMutableDictionary *dic =  [TPHttpRequest appDelegate].tongueDic;
    
    if (dic.count!=0){
        self.myTongueNameLabel.text = [dic objectForKey:@"jointTongueName"];
        self.myTongueTimeLabel.text = [NSString stringWithFormat:@"-%@",[dic objectForKey:@"tongueDate"]];
        self.myTongueDesLabel.text = [dic objectForKey:@"jointTongueDesc"];
        [self.myTongueDesLabel sizeToFit];
        
        NSDictionary *subDic = [dic objectForKey:@"cts"];
        NSDictionary *theDic1 = [subDic objectForKey:@"coatedColor"];
        NSString *score1 = [theDic1 objectForKey:@"tongueScore"];
        
        NSDictionary *theDic2 = [subDic objectForKey:@"coatedThickness"];
        NSString *score2 = [theDic2 objectForKey:@"tongueScore"];
        
        NSDictionary *theDic3 = [subDic objectForKey:@"coatedSpalling"];
        NSString *score3 = [theDic3 objectForKey:@"tongueScore"];
        
        NSDictionary *theDic4 = [subDic objectForKey:@"coatedGreasyRot"];
        NSString *score4 = [theDic4 objectForKey:@"tongueScore"];
        
        NSDictionary *theDic5 = [subDic objectForKey:@"coatedMoistDry"];
        NSString *score5 = [theDic5 objectForKey:@"tongueScore"];
        
        NSDictionary *theDic6 = [subDic objectForKey:@"tongueSurface"];
        NSString *score6 = [theDic6 objectForKey:@"tongueScore"];
        
        NSDictionary *theDic7 = [subDic objectForKey:@"tongueShape"];
        NSString *score7 = [theDic7 objectForKey:@"tongueScore"];
        
        NSDictionary *theDic8 = [subDic objectForKey:@"tongueColor"];
        NSString *score8 = [theDic8 objectForKey:@"tongueScore"];
        
        
        [self.myTongueAry removeAllObjects];
        [self.myTongueAry addObject:score1];
        [self.myTongueAry addObject:score2];
        [self.myTongueAry addObject:score3];
        [self.myTongueAry addObject:score4];
        [self.myTongueAry addObject:score5];
        [self.myTongueAry addObject:score6];
        [self.myTongueAry addObject:score7];
        [self.myTongueAry addObject:score8];
        
        }
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)doBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * CellIdentifier = @"cell";
    TPUserHabitCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    return cell;
}
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    self.myRow = (int)indexPath.row;
    //    TPDrinkCollectionViewCell * cell = (TPDrinkCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //    //    if (indexPath.row>3)
    //    //        self.myRusultLabel.text = @"缺水";
    //    //    else
    //    //        self.myRusultLabel.text = @"不缺水";
    //
    //    NSString *textStr = cell.cellStatusLabel.text;
    //    NSString *newText = [textStr stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    //    self.myResultLabel.text = newText;
    //
    //    [self.myCollectionView reloadData];
}

- (IBAction)goMain:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:NO];
  
}
@end
