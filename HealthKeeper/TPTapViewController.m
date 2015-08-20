//
//  TPTapViewController.m
//  HealthKeeper
//
//  Created by wangzhipeng on 15/8/6.
//  Copyright (c) 2015年 山西协康云享科技有限公司. All rights reserved.
//

#import "TPTapViewController.h"
#import "TPMainViewController.h"
#import "TPNextDayViewController.h"
#import "TPUserSettingViewController.h"
@interface TPTapViewController ()
@property (nonatomic,strong) UINavigationController *myNav1;
@property (nonatomic,strong) UINavigationController *myNav2;
@property (nonatomic,strong) UINavigationController *myNav3;

@property (nonatomic,strong) UITabBarController *myTabBarController;

@property (nonatomic,strong) TPMainViewController *myVc1;
@property (nonatomic,strong) UIViewController *myVc2;
@property (nonatomic,strong) TPUserSettingViewController  *myVc3;

@property (nonatomic) CGPoint myStartPoint;
@property (nonatomic,strong) TPNextDayViewController *myNextDayViewController;
@end

@implementation TPTapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = YES;
    self.myNextDayViewController = [[TPNextDayViewController alloc]init];
    self.myNextDayViewController.view.frame = self.view.frame;
    [self.view addSubview:self.myNextDayViewController.view];
    NSMutableArray *controllers = [NSMutableArray array];
    
    NSArray *item = [NSArray arrayWithObjects:@"调养",@"健康档案",@"我的", nil];
    
    self.myVc1= [[TPMainViewController alloc]init];
    self.myVc1.view.frame = self.view.frame;
    //绑定tabViewController用来响应按钮点击事件
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:self.myVc1];
    
    //设置标题
    nav1.title = [item objectAtIndex:0];
    nav1.tabBarItem.title = [item objectAtIndex:0];
    nav1.tabBarItem.image = [UIImage imageNamed:@"tapTiaoYang"];
    self.myVc1.tabBarItem = [[UITabBarItem alloc]initWithTitle:[item objectAtIndex:0] image:[UIImage imageNamed:@"tapTiaoYang"] tag:1];
    
    
    self.myVc2 = [[UIViewController alloc]init];
    self.myVc2.view.frame = self.view.frame;
    //绑定tabViewController用来响应按钮点击事件
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:self.myVc2];
    nav2.tabBarItem = [[UITabBarItem alloc]initWithTitle:[item objectAtIndex:1] image:[UIImage imageNamed:@"tapRecord"] tag:2];
    //设置标题
    nav2.title = [item objectAtIndex:1];
    nav2.tabBarItem.title = [item objectAtIndex:1];
    self.myVc2.tabBarItem = [[UITabBarItem alloc]initWithTitle:[item objectAtIndex:1] image:[UIImage imageNamed:@"tapRecord"] tag:2];
    
    
    self.myVc3= [[TPUserSettingViewController alloc]init];
    self.myVc3.view.frame = self.view.frame;
    //绑定tabViewController用来响应按钮点击事件
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:self.myVc3];
    //设置标题
  
    nav3.tabBarItem.title = [item objectAtIndex:2];
    nav3.tabBarItem.image = [UIImage imageNamed:@"tapMine"];
    self.myVc3.tabBarItem = [[UITabBarItem alloc]initWithTitle:[item objectAtIndex:2] image:[UIImage imageNamed:@"tapMine"] tag:3];
    
    //创建UITabBarController，将显示的内容添加进去
   self.myTabBarController = [[UITabBarController alloc] init];
    self.myTabBarController.viewControllers = controllers;
    self.myTabBarController.customizableViewControllers = controllers;
    self.myTabBarController.delegate = self;
    self.myNav1 = nav1;
    self.myNav2 = nav2;
    self.myNav3 = nav3;
    
    self.myNav1.navigationBarHidden = YES;
    
//    [controllers addObject:self.myNav1];
//    [controllers addObject:self.myNav2];
//    [controllers addObject:self.myNav3];
//    self.myVc1 = vc1;
//    self.myVc2 = vc2;
//    self.myVc3 = vc3;
    
    
    [controllers addObject:self.myNav1];
    [controllers addObject:self.myNav2];
    [controllers addObject:self.myNav3];

    
    self.myTabBarController.tabBar.selectedImageTintColor = [UIColor orangeColor];
    self.myTabBarController.viewControllers = controllers;
    
    
    //添加到显示窗口中
    [self.view addSubview:self.myTabBarController.view];
    
    [self.view bringSubviewToFront:self.myNextDayViewController.view];
    
    // self.hidesBottomBarWhenPushed = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
   
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    NSLog(@"%ld", (long)viewController.tabBarItem.tag);
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
    UITouch *touch = [touches anyObject];
    CGPoint pointone = [touch locationInView:self.view];//获得初始的接触点
    self.myStartPoint = pointone;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint currentLocation = [touch locationInView:self.view];
    
    CGFloat distance = self.myStartPoint.y-currentLocation.y;
    NSLog(@"touches:%f,%f,distance:%f",currentLocation.x,currentLocation.y,distance);
    
    
    if (distance>0){//向上
        if (self.myNextDayViewController.view.frame.origin.y==-self.myNextDayViewController.view.frame.size.height){
            
            return;
        }
        else
            self.myNextDayViewController.view.frame= CGRectMake(0, -distance, self.myNextDayViewController.view.frame.size.width, self.myNextDayViewController.view.frame.size.height);
    }
    else{//向下
        if (self.myNextDayViewController.view.frame.origin.y==0){
            
            return;
        }
        else
            self.myNextDayViewController.view.frame= CGRectMake(0, -self.myNextDayViewController.view.frame.size.height-distance, self.myNextDayViewController.view.frame.size.width, self.myNextDayViewController.view.frame.size.height);
    }
    
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint endLocation = [touch locationInView:self.view];
    NSLog(@"END,distance:%f",self.myStartPoint.y-endLocation.y);
    //在上面影藏
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    if ((self.myStartPoint.y-endLocation.y)>50){
        self.myNextDayViewController.view.frame = CGRectMake(0, -self.myNextDayViewController.view.frame.size.height, 320, self.myNextDayViewController.view.frame.size.height);
        //self.zheZhaoHidden = YES;
    }
    else if ((self.myStartPoint.y-endLocation.y)<50&&(self.myStartPoint.y-endLocation.y)>5){
        self.myNextDayViewController.view.frame = CGRectMake(0, 0, 320, self.myNextDayViewController.view.frame.size.height);
        //self.zheZhaoHidden = NO;
    }
    
    
    
    
    else  if ((self.myStartPoint.y-endLocation.y)<-25){
        self.myNextDayViewController.view.frame = CGRectMake(0, 0, 320, self.myNextDayViewController.view.frame.size.height);
        //self.zheZhaoHidden = NO;
    }
    else if ((self.myStartPoint.y-endLocation.y)>-25&&(self.myStartPoint.y-endLocation.y)<-5){
        //  self.zheZhaoHidden = YES;
        self.myNextDayViewController.view.frame = CGRectMake(0, -self.myNextDayViewController.view.frame.size.height, 320, self.myNextDayViewController.view.frame.size.height);
    }
    [UIView commitAnimations];
    
}

-(void)touchesCancelled:(NSSet *)touches
              withEvent:(UIEvent *)event
{
    
}

@end
