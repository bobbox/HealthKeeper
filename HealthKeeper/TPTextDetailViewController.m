//
//  TPTextDetailViewController.m
//  HealthKeeper
//
//  Created by apple on 15/8/7.
//  Copyright (c) 2015年 山西协康云享科技有限公司. All rights reserved.
//

#import "TPTextDetailViewController.h"
#import "customDefine.h"
#import "UIImageView+WebCache.h"
#import "TPUserHabitCollectionViewCell.h"
#import "TPRecordViewController.h"
@interface TPTextDetailViewController ()

@end

@implementation TPTextDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.myWebView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
    [self getTextDetail];
    self.myTitleLabel.text = [self.myDataDic objectForKey:@"title"];
   // NSString *imgUrlStr = [self.myDataDic objectForKey:@"image"];
    //[self.myTopImageView setImageWithURL:[NSURL URLWithString:imgUrlStr]];
    [self.myCollectionView registerNib:[UINib nibWithNibName:@"TPUserHabitCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"cell"];
   
    self.hidesBottomBarWhenPushed = YES;
    NSString *updateTime = [self.myDataDic objectForKey:@"lastUpdateTime"];
    NSString *timeStr = [self getDateStringFormSec:updateTime];
    self.myLastTimeUpdateLabel.text = timeStr;
    
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
-(void)getTextDetail{
    if (self.myDataDic!=nil){
        NSString *idStr = [self.myDataDic objectForKey:@"id"];
        
    NSString *postStr = [NSString stringWithFormat:@"id=%@",idStr];
    NSData *requestData = [postStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    
    // 请求的URL地址
    //NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[@"http://120.27.36.130/TonguePepSys/task/get?"  stringByAppendingString:childName]]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:READ_TEXT_DETAIL_URL]];
    [request setHTTPBody:requestData];
    [request setHTTPMethod:@"post"];
    //    // 设置请求方式
    
    // 执行请求
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding ];
    NSLog(@"tasks:%@",str);
    if(data!=nil){
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
//        NSString *status = [dic objectForKey:@"status"];
//        if ([status isEqualToString:@"SUCCESS"]){
//            NSDictionary *dic1 = [dic objectForKey:@"bean"];
//            NSString *contentStr = [dic1 objectForKey:@"content"];
////            [self.myWebView loadHTMLString:contentStr baseURL:nil];
////            [self.myWebView stopLoading];
//            
//            NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,   NSUserDomainMask, YES);
//            
//            NSString *saveDirectory=[paths objectAtIndex:0];
//            
//            NSString *saveFileName=@"myHTML.html";
//            
//            NSString *filepath=[saveDirectory stringByAppendingPathComponent:saveFileName];
//           BOOL result =   [contentStr  writeToFile:filepath atomically:YES encoding:NSUTF8StringEncoding error:nil];
//            if        (result)
//                NSLog(@"SUCCESS");
//            else
//                NSLog(@"FAIL");
//            
//            
//            
//            NSURL *url = [NSURL fileURLWithPath:filepath];
//            
//            NSURLRequest *request = [NSURLRequest requestWithURL:url];
//            
//            [self.myWebView loadRequest:request];
        NSDictionary *dic1 = [dic objectForKey:@"bean"];
        NSString *urlStr = [NSString stringWithFormat:@"http://120.27.36.130%@",[dic1 objectForKey:@"readerUrl"]];
        NSLog(@"%@",urlStr);
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
         //[request setHTTPMethod:@"post"];
        NSData *htmlData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *htmlStr = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
        [self.myWebView loadHTMLString:htmlStr baseURL:nil];
        }
    
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
     [self configScrollView];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"%@",error.description);
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"LOADED");
    [self configScrollView];
    
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"LOADING");
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doTest:(id)sender {
    TPRecordViewController *vc = [[TPRecordViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)configScrollView{
    NSString *htmlHeight = [self.myWebView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"];
    self.myWebView.frame = CGRectMake(self.myWebView.frame.origin.x, self.myWebView.frame.origin.y, self.myWebView.frame.size.width, htmlHeight.intValue);
    
    self.myView1.frame = CGRectMake(self.myView1.frame.origin.x, self.myWebView.frame.origin.y+self.myWebView.frame.size.height, self.myView1.frame.size.width, self.myView1.frame.size.height);
    self.myView2.frame = CGRectMake(self.myView2.frame.origin.x, self.myView1.frame.origin.y+self.myView1.frame.size.height, self.myView2.frame.size.width, self.myView2.frame.size.height);
    self.myScrollView.contentSize = CGSizeMake(320, htmlHeight.intValue+self.myWebView.frame.origin.y+self.myView1.frame.size.height+self.myView2.frame.size.height+50);

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
-(NSString*)getDateStringFormSec:(NSString*)second{
    NSDate *now = [NSDate date];
    NSInteger nowTimeSp = [now timeIntervalSince1970];
    long long secondInteger = second.longLongValue;
    NSInteger theSecond = secondInteger/1000;
    NSInteger useSecond = nowTimeSp - theSecond;
    NSString *returnStr = @"";
    NSInteger minute = 60;
    NSInteger hour = 60*60;
    NSInteger day = 3600*24;
    NSInteger month = 3600*24*30;
    NSInteger year = 3600*34*30*12;
    
    
    if (useSecond<60){
        returnStr = @"刚刚";
    }
    else if (useSecond>=60&&useSecond<3600){
        NSInteger num = useSecond/minute;
        returnStr = [NSString stringWithFormat:@"%ld分钟前",(long)num];
    }
    else if (useSecond>=3600&&useSecond<3600*24){
        NSInteger num = useSecond/hour;
        returnStr = [NSString stringWithFormat:@"%ld小时前",(long)num];
        
    }
    else if (useSecond>=3600*24&&useSecond<3600*24*30){
        NSInteger num = useSecond/day;
        returnStr = [NSString stringWithFormat:@"%ld天前",(long)num];
        
    }
    else if (useSecond>=3600*24*30&&useSecond<3600*24*30*12){
        NSInteger num = useSecond/month;
        returnStr = [NSString stringWithFormat:@"%ld月前",(long)num];
        
    }
    else {
        NSInteger num = useSecond/year;
        returnStr = [NSString stringWithFormat:@"%ld年前",(long)num];
    }
    
    return returnStr;
}

@end
