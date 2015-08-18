//
//  TPMainViewController.m
//  HealthKeeper
//
//  Created by apple on 15/7/23.
//  Copyright (c) 2015年 山西协康云享科技有限公司. All rights reserved.
//

#import "TPMainViewController.h"
#import "TPNextDayViewController.h"
#import "TPHealthMasterCollectionViewCell.h"
#import "customDefine.h"
#import "UIImageView+WebCache.h"
#import "HealthText.h"
#import "MJRefresh.h"
#import "TPTextDetailViewController.h"
#import "UIScrollView+MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "LoginViewController.h"

NSString *const MJTableViewCellIdentifier = @"Cell";

@interface TPMainViewController ()
@property (nonatomic,strong) TPNextDayViewController *myNextDayViewController;
@property (nonatomic) CGPoint myStartPoint;
@property (nonatomic,strong) NSArray *myShiChenAry;
@property (nonatomic,strong) NSArray *myMasterAry;
@property (nonatomic) int readListPageNum;
@property (nonatomic,strong) HealthText *myHealthText;
@property (nonatomic,strong) NSDictionary *myTextReadDic;
@end

@implementation TPMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.readListPageNum = 0;
    HealthText *tx = [[HealthText alloc]init];
    self.myReadTextListTableView.delegate = tx;
    self.myReadTextListTableView.dataSource =tx;
    self.myHealthText= tx;
    self.myHealthText.delegate = self;
    self.myHealthText.myDataAry = [NSMutableArray array];
   ;
    
    //self.hidesBottomBarWhenPushed = YES;
    //阅读那里增加下拉加载更多
    [self.myReadTextListTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:MJTableViewCellIdentifier];
    
    // 2.集成刷新控件
    [self setupRefresh];
    
   
    
    
    self.myTiaoYangScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 800);
    
    
     [self.myHeathMasterCollectionView registerNib:[UINib nibWithNibName:@"TPHealthMasterCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"cell"];
    
     NSString *imgUlr = [[NSUserDefaults standardUserDefaults] objectForKey:@"nextDayImgUrl"];
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [imgView setImageWithURL:[NSURL URLWithString:imgUlr]];
    [imgView setImageWithURL:[NSURL URLWithString:imgUlr] success:^(UIImage *image){
        self.myTopImageView.image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, 64, 320, 120))];
        
        self.myDoTiaoYangImageView.image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([image CGImage], CGRectMake(34, 232, 254, 61))];
    } failure:nil];
   
   
    
    self.myShiChenView.layer.cornerRadius = 5.0;
    self.myShiChenView.layer.masksToBounds = YES;
    
    self.myDoTiaoYangImageView.layer.cornerRadius = 4.0;
    self.myDoTiaoYangImageView.layer.masksToBounds = YES;
    
    self.myDoTiaoYangBtn.layer.cornerRadius = 4.0;
    self.myDoTiaoYangBtn.layer.masksToBounds = YES;
    
    self.myTapBar.selectedImageTintColor = [UIColor orangeColor];
    
    self.myShiChenAry = [NSArray arrayWithObjects:@"子",@"丑",@"寅",@"卯",@"辰",@"巳",@"午",@"未",@"申",@"酉",@"戌",@"亥", nil];
    
    self.myUserPhotoImageView.layer.cornerRadius = 21;
    self.myUserPhotoImageView.layer.masksToBounds = YES;
    
    self.myLoginBtn.layer.cornerRadius = 11;
    self.myLoginBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.myLoginBtn.layer.borderWidth = 1.0;
    self.myLoginBtn.layer.masksToBounds = YES;
    
    [self configMissionListUpView];
    [self getMasterList];
    [self getHealthBookList];
    [self countScrollViewHeight];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear: animated];
    // self.tabBarController.tabBar.hidden = NO;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)cellSelectedWithRow:(int)row{
    NSDictionary *dic = [self.myHealthText.myDataAry objectAtIndex:row];
    TPTextDetailViewController *vc = [[TPTextDetailViewController alloc]init];
    vc.myDataDic = dic;
   //  self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
       // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.myTiaoYangScrollView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    
    self.myTiaoYangScrollView.footerPullToRefreshText = @"上拉加载更多";
    self.myTiaoYangScrollView.footerReleaseToRefreshText = @"松开马上加载更多";
    self.myTiaoYangScrollView.footerRefreshingText = @"数据加载中...";
}

#pragma mark 开始进入刷新状态

- (void)footerRereshing
{
    [self getHealthBookList];
    [self countScrollViewHeight];
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.myReadTextListTableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.myTiaoYangScrollView footerEndRefreshing];
    });
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.myMasterAry.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * CellIdentifier = @"cell";
    TPHealthMasterCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
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



-(void)configMissionListUpView{
    self.myForwardView.layer.cornerRadius = 12.0;
    self.myForwardShiChenLabel.layer.cornerRadius = 10.0;
    self.myForwardShiChenLabel.layer.borderColor = [UIColor colorWithWhite:0.839 alpha:1.000].CGColor;
    self.myForwardShiChenLabel.layer.borderWidth = 1.0;
    self.myForwardShiChenLabel.layer.masksToBounds = YES;
    
    self.myNowView.layer.cornerRadius = 12.0;
    self.myNowShiChenLabel.layer.cornerRadius = 10.0;
    self.myNowView.layer.masksToBounds = YES;
    self.myNowShiChenLabel.layer.masksToBounds = YES;
    
    self.myBackwardView.layer.cornerRadius = 12.0;
    self.myBackwardShiChenLabel.layer.cornerRadius = 10.0;
    self.myBackwardShiChenLabel.layer.borderColor = [UIColor colorWithWhite:0.839 alpha:1.000].CGColor;
    self.myBackwardShiChenLabel.layer.borderWidth = 1.0;
    
    int shiChen = [self getNowShiChenIndex];
    NSMutableArray *ary = [NSMutableArray array];
    for (int i=0;i<3;i++){
        int dex= shiChen-1+i;
        if (dex<0)
            dex = 11;
        else if (dex>11)
            dex = 0;
        NSString *dexStr = [NSString stringWithFormat:@"%i",dex];
        [ary addObject:dexStr];
    }
    NSString *forwardStr = [ary objectAtIndex:0];
    NSString *nowStr = [ary objectAtIndex:1];
    NSString *backwardStr = [ary objectAtIndex:2];
    self.myForwardShiChenLabel.text = [self.myShiChenAry objectAtIndex:forwardStr.intValue];
    self.myNowShiChenLabel.text = [self.myShiChenAry objectAtIndex:nowStr.intValue];
    self.myBackwardShiChenLabel.text =[self.myShiChenAry objectAtIndex:backwardStr.intValue];
    self.myTapBar.delegate = self;
    self.myYangShengLabel.text = [NSString stringWithFormat:@"我的%@时养生",self.myNowShiChenLabel.text ];
    NSArray *theAry = [NSArray arrayWithObjects:@"23:00",@"01:00",@"03:00",@"05:00",@"07:00",@"09:00",@"11:00",@"13:00",@"15:00",@"17:00",@"19:00",@"21:00", nil];
    
    NSString *timeStr = [theAry  objectAtIndex:nowStr.intValue];
    NSString *timeStr1 = [theAry objectAtIndex:backwardStr.intValue];
    self.myShiChenTimeLabel.text =[ NSString stringWithFormat:@"%@-%@",timeStr,timeStr1];
    
    self.myShiChenImageShiChenLabel.text = [NSString stringWithFormat:@"%@时",self.myNowShiChenLabel.text];
    NSString *shiChenStr = self.myShiChenImageShiChenLabel.text;
    self.myShiChenImageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:shiChenStr ofType:@"jpg"]];
    self.myShiChenImageShiChenTimeLabel.text = self.myShiChenTimeLabel.text;
    //时辰下面说明
    NSArray *tipAry = [NSArray arrayWithObjects:@"子时胆经当令。子时是阴阳交汇之时，也是万籁俱静之时，这个时候最好是睡觉，睡的时候宜屈膝卧，变换姿势。环境宜静，全神凝聚，不悲不喜，不念不妄。如果这个时候还在用思不宁，劳作不息，就会干扰阴阳交合，使元气生发受到干扰。",@"丑时肝经当令。此时必须进入熟睡状态，让肝脏得到最充足的能量。而此时如果不能入睡，肝脏还在输出能量来维持人的思维和活动，新陈代谢会受到影响。《黄帝内经》讲“卧则血归于肝”。所以丑时没入睡者，面色呈青灰，情志倦怠而躁，易生肝病。",@"寅时肺经当令。3点到5点是人体气血从静变为动的过程，这个转化的过程是通过深度睡眠来完成的。肝脏在丑时把血液推陈出新之后，把新鲜的血液输送给肺，通过肺送往全身。所以此时睡眠好的人清晨起来面色红润，精力充沛。",@"卯时大肠经当令。这个时候，天也基本上亮了，天门开了，五点醒是正常的。这个时候我们应该正常地排便，把垃圾毒素排出来。这个时候代表地户开，也就是肛门要开，所以要养成早上排便的习惯。排便不畅，应该憋一口气，而不是攥拳。",@"辰时胃经当令。人体经过一夜的睡眠和休息，由于排尿、呼吸等原因，水分排泄的比较多，致使血液的黏稠度比较高, 因此健康饮水，从辰时就应该开始了。此时胃肠正处于空乏状态，水可以很快被吸收，并渗透至细胞组织内，使肌体补充到充足的水分，血液循环恢复正常，从而提高人体的抗病能力，大大降低心脑血管的发病率。这个时辰也是天地阳气最旺的时候，吃早饭是最容易消化的时候。",@"巳时脾经当令。脾是主运化的，早上吃的饭在这个时候开始运化。脾的功能好，消化吸收就好，血的质量也会好，嘴唇红润光亮。否则嘴唇会苍白或紫暗，唇白标志血气不足，唇暗、唇紫标志寒入脾经。",@"午时心经当令。子时和午时是天地气机的转换点，人体也要注重这种天地之气的转换点。人在午时能睡片刻，对于养心大有好处，可使下午乃至晚上精力充沛。尤其对于高血压患者，午休最有补益。午休也有助于消化。当然，午睡时间不要太长，最多也不要超过1个小时。",@"未时小肠经当令。小肠理顺清浊，把水液归于膀胱，糟粕送入大肠，精华输入至脾脏。小肠经在未时会对人一天的营养进行调整。应在午时1点前用餐，这样才能在小肠功能最旺盛的时候把营养物资充分吸收和分配。否则，好的东西没有吸收完全，造成所吃的营养物资浪费，在人体内形成垃圾。",@"申时膀胱经当令。膀胱经是很重要的经脉，在中医里号称太阳。膀胱就像太阳一样，能够把精液气化，因为膀胱与肾相表里，膀胱的气化功能不足，肾经里面的水液调不上来，就会出现口干舌燥的情况。膀胱最活跃最旺盛的申时，宜多喝水，有尿就尿，不要憋着，否则，时间长了，就会有尿滞留现象，也就是说膀胱括约肌将失去弹性。",@"酉时肾经当令。肾主藏精,乃先天之根本。精是人体中最具有创造力的一个原始力量。五脏六腑之精也即中国人所讲的“元气”就藏在肾经当中，中医讲元气可以用咸的东西来调动，所以炒菜做饭一定要放适量的盐，但太淡太咸都不可取。人体经过申时泻火排毒，肾在酉时进入贮藏精华的阶段。",@"戌时心包经当令。心包是心脏外膜组织，主要是保护心肌正常工作的，此时阴气正盛，阳气将尽，喜乐出焉，人应在这时放松娱乐，古人在这时都是聊天休闲。此刻应该给自己创造一个准备安然入睡的条件，最好不要有剧烈的活动，否则容易失眠，而最好的运动就是散步。",@"亥时三焦经当令。三焦指连缀五脏六腑的那个网膜状的区域。三焦一定要通畅，不通则生病。亥时是人体细胞休养生息、推陈出新的时间，此刻要保持心境平静。不生气，不狂喜，不大悲。如果情绪波动到11点还没结束，那第二天的精神一定会萎靡不振。", nil];
    
    self.myShiChenImageTipLabel.text = [tipAry objectAtIndex:shiChen];
    
}
-(int)getNowShiChenIndex{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter  = [[NSDateFormatter  alloc]init];
    [formatter setDateFormat:@"HH"];
    NSString *timeStr = [formatter stringFromDate:date];
    int timeValue = timeStr.intValue;
    if (timeValue>=1&&timeValue<3){
        return 1;
    }
    else if (timeValue>=3&&timeValue<5){
        return 2;
    }
    else if (timeValue>=5&&timeValue<7){
        return 3;
    }
    else if (timeValue>=7&&timeValue<9){
        return 4;
    }
    else if (timeValue>=9&&timeValue<11){
        return 5;
    }
    else if (timeValue>=11&&timeValue<13){
        return 6;
    }
    else if (timeValue>=13&&timeValue<15){
        return 7;
    }
    
    else if (timeValue>=15&&timeValue<17){
        return 8;
    }
    else if (timeValue>=17&&timeValue<19){
        return 9;
    }
    else if (timeValue>=19&&timeValue<21){
        return 10;
    }
    else if (timeValue>=21&&timeValue<23){
        return 11;
    }
    else{
        return 0;
    }
}

#pragma mark  获取微养生达人列表
-(void)getMasterList{
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:MASTER_USER_LIST_URL]];
    
        [request setHTTPMethod:@"post"];
        
        // 执行请求
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];

    NSString *STR = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if (data!=nil){
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    if (dic!=nil){
        NSString *status = [dic objectForKey:@"status"];
        if ([status isEqualToString:@"SUCCESS"]){
            NSArray *ary = [dic objectForKey:@"bean"];
            self.myMasterAry = ary;
            [self.myHeathMasterCollectionView reloadData];
        }
    }
  }
}
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
//    self.myTabFirstBarItem.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tapTiaoYang" ofType:@"png"]];
}

#pragma  mark   获取养生阅读文章列表
-(void)getHealthBookList{
       int time = [self getNowShiChenIndex];
    NSString *shichen = [self.myShiChenAry objectAtIndex:time];
    //NSString *urlStr = TIAOYANGMISSIONLIST;
    
    NSString *postStr = [NSString stringWithFormat:@"page=%i&timeText=%@",self.readListPageNum,shichen];
    
    NSString *childName = [postStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData *requestData = [postStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    
    // 请求的URL地址
    //NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[@"http://120.27.36.130/TonguePepSys/task/get?"  stringByAppendingString:childName]]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:READ_TEXT_LIST_URL]];
    [request setHTTPBody:requestData];
    [request setHTTPMethod:@"post"];
    //    // 设置请求方式
    
    // 执行请求
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding ];
    NSLog(@"tasks:%@",str);
    if(data!=nil){
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
        NSString *status = [dic objectForKey:@"status"];
        if ([status isEqualToString:@"SUCCESS"]){
            NSArray *ary = [dic objectForKey:@"bean"];
            if (ary.count!=0){
            [self.myHealthText.myDataAry addObjectsFromArray:ary];
            [self.myHeathMasterCollectionView reloadData];
            self.readListPageNum++;
            }
                
        }
    }
}

//根据展示内容更改scrollview的长度
-(void)countScrollViewHeight{
    
    self.myReadTextListTableView.frame = CGRectMake(self.myReadTextListTableView.frame.origin.x, self.myReadTextListTableView.frame.origin.y, self.myReadTextListTableView.frame.size.width, (80*abs(self.myHealthText.myDataAry.count)));
    
    self.myTiaoYangScrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.myMissionBgView.frame.origin.y+self.myMissionBgView.frame.size.height+20+self.myMasterBgView.frame.size.height+20+self.myShiChenView.frame.size.height+20+self.myReadTextListTableView.frame.size.height);
}
- (IBAction)doLogin:(id)sender {
    LoginViewController *vc = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
