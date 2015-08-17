//
//  TPNextDayViewController.m
//  HealthKeeper
//
//  Created by apple on 15/7/23.
//  Copyright (c) 2015年 山西协康云享科技有限公司. All rights reserved.
//

#import <ShareSDK/ShareSDK.h>
#import "TPNextDayViewController.h"
#import "UIImageView+WebCache.h"
#import "TPHttpRequest.h"
#import "customDefine.h"

@interface TPNextDayViewController ()
@property (nonatomic,strong)CLLocationManager  *myLocationManager;
@property (nonatomic,strong) NSTimer *myTimer;
@property (nonatomic,strong) NSString *myLocationStr;
@end

@implementation TPNextDayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
    [tap addTarget:self action:@selector(doTap)];
    [self.view addGestureRecognizer:tap];
    
    self.myWeatherView.color = [UIColor whiteColor];
    if([CLLocationManager locationServicesEnabled]) {
        CLLocationManager  *locationManager = [[CLLocationManager alloc]init];
        self.myLocationManager = locationManager;
        //    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        //
        //        [locationManager requestWhenInUseAuthorization];
        
        locationManager.delegate = self;
        [locationManager requestAlwaysAuthorization];
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        [locationManager startUpdatingLocation];
    }
    else{
        NSString *locationStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"place"];
        if (locationStr!=nil){
            NSString *tipStr = [NSString stringWithFormat:@"定位服务不可用,是否使用上次的位置(%@)?",locationStr];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:tipStr delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag=2;
            [alert show];
        }
        else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"定位服务不可用" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        }
    }
    
    self.myWordLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 455, 288, 21)];
    self.myWordLabel.font = [UIFont systemFontOfSize:13.0];
    self.myWordLabel.textColor = [UIColor whiteColor];
    self.myWordLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.myWordLabel.numberOfLines = 0;
    //[self.view addSubview:self.myWordLabel];
    [self.view addSubview:self.myWordLabel];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"YYYY-MM-dd";
    NSDate *date = [NSDate date];
    NSString *dateStr = [formatter stringFromDate:date];
    NSData *theData = [[NSUserDefaults standardUserDefaults] objectForKey:dateStr];
    if (theData==nil){
        
        [self getHttpData];
    }
    else{
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:theData options:NSJSONReadingMutableLeaves error:nil];
        NSDictionary *theDic = [dic  objectForKey:@"bean"];
        NSString  *urlStr= [theDic objectForKey:@"imagePath"];
        [self.myBgImageView setImageWithURL:[NSURL URLWithString:urlStr]];
        [[NSUserDefaults standardUserDefaults] setObject:urlStr forKey:@"nextDayImgUrl"];
        [self.myTimer invalidate];
        [self configData];
        
    }
    if (![TPHttpRequest netReached]){
        [self performSelector:@selector(showNoNetWorkTip) withObject:nil afterDelay:2.0];
        //        NSTimer *timer = [NSTimer timerWithTimeInterval:10.0 target:self selector:@selector(getHttpData) userInfo:nil repeats:YES];
        //        self.myTimer = timer;
        //        [[NSRunLoop  currentRunLoop] addTimer:self.myTimer forMode:NSDefaultRunLoopMode];
        [self getWeatherData];
    }
    [self.myLocationManager startUpdatingLocation];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)doTap{
    NSLog(@"taping");
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    
    if (self.myShareView.alpha==0.0)
        self.myShareView.alpha = 1.0;
    else
        self.myShareView.alpha = 0.0;
    [UIView commitAnimations];

}
-(void)showNoNetWorkTip{
    [TPHttpRequest showMessage:@"请检查网络连接"];
    
}/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation{
    NSLog(@"$$$$$");
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *currentLocation = [locations lastObject];
    NSLog(@"获取位置喽");
    
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error)
     {
         if (array.count > 0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];
             
             //获取省
             NSString *state = placemark.administrativeArea;
             //获取城市
             NSString *city = placemark.locality;
             
             NSString *location1 = [state stringByReplacingOccurrencesOfString:@"省" withString:@""];
             NSString *location2 = [city stringByReplacingOccurrencesOfString:@"市" withString:@""];
             NSString *locationStr = [NSString stringWithFormat:@"%@,%@",location1,location2];
             self.myState = [NSString stringWithFormat:@"%@",location1];
             self.myCity = [NSString stringWithFormat:@"%@",location2];
             
             NSLog(@"city = %@",locationStr);
             self.myLocationStr = locationStr;
             NSString *thePlace = [[NSUserDefaults standardUserDefaults] objectForKey:@"place"];
             if (thePlace!=nil&&![thePlace isEqualToString:locationStr]){
                 NSString *str = [NSString stringWithFormat:@"您当前所在的位置是%@,是否切换到该城市？",locationStr];
             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"切换", nil];
             [alert show];
             }
             else{
                 [[NSUserDefaults standardUserDefaults] setObject:locationStr forKey:@"place"];
             [self getWeatherData ];
             }
             [manager stopUpdatingLocation];
         }
     }];
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==2){
        switch (buttonIndex) {
            case 0:
                NSLog(@"0");
               // [self getWeatherData];
                break;
            case 1:
                //[[NSUserDefaults standardUserDefaults] setObject:self.myLocationStr forKey:@"place"];
                [self getWeatherData];
                break;
            default:
                break;
        }

    }
    else{
    switch (buttonIndex) {
        case 0:
            NSLog(@"0");
            [self getWeatherData];
            break;
          case 1:
            [[NSUserDefaults standardUserDefaults] setObject:self.myLocationStr forKey:@"place"];
            [self getWeatherData];
            break;
        default:
            break;
    }
    }
}


-(void)getWeatherData{
    NSLog(@"获取天气喽");
    // 数据内容转换为UTF8编码，第二个参数为数据长度
    if (![TPHttpRequest netReached]){
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"YYYY-MM-dd";
        NSDate *date = [NSDate date];
        NSString *dateStr = [formatter stringFromDate:date];
        NSString  *weatherKeyStr= [NSString stringWithFormat:@"%@temp",dateStr];
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:weatherKeyStr];
        if (data!=nil){
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            formatter.dateFormat = @"YYYY-MM-dd";
            NSDate *date = [NSDate date];
            NSString *dateStr = [formatter stringFromDate:date];
            NSString  *weatherKeyStr= [NSString stringWithFormat:@"%@temp",dateStr];
            [[NSUserDefaults standardUserDefaults] setValue:data forKey:weatherKeyStr];
            
            //            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            //            NSString *result = [dic   objectForKey:@"status"];
            //            if ([result isEqualToString:@"SUCCESS"]){
            NSDictionary *dic = [NSJSONSerialization  JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if (dic!=nil){
                NSDictionary *dic1 = [dic objectForKey:@"data"];
                NSArray *resultAry = [dic1 objectForKey:@"forecast"];
                self.myTodayTempLabel.text = [NSString stringWithFormat:@"%@",[dic1 objectForKey:@"wendu"]];
                
                NSDictionary *dic11 = [resultAry objectAtIndex:0];
                NSString *weather = [dic11  objectForKey:@"type"];
                
                NSDictionary *dic22 = [resultAry objectAtIndex:1];
                NSString *low22 = [dic22 objectForKey:@"low"];
                NSString *low2= [low22 substringFromIndex:3];
                
                NSString *high22 = [dic22  objectForKey:@"high"];
                NSString *high2 = [high22 substringFromIndex:3];
                NSString *weather2 = [dic22 objectForKey:@"type"];
                NSString *lastStr2 = [NSString stringWithFormat:@"%@/%@%@",low2,high2,weather2];
                self.myTomorrowWeatherLabel.text = [lastStr2 stringByReplacingOccurrencesOfString:@"℃" withString:@"°"];
                
                
                NSDictionary *dic33 = [resultAry objectAtIndex:2];
                NSString *low33 = [dic33 objectForKey:@"low"];
                NSString *low3= [low33 substringFromIndex:3];
                
                NSString *high33 = [dic33  objectForKey:@"high"];
                NSString *high3 = [high33 substringFromIndex:3];
                NSString *weather3 = [dic33 objectForKey:@"type"];
                NSString *lastStr3 = [NSString stringWithFormat:@"%@/%@%@",low3,high3,weather3];
                self.myTomorrowNextDayWeatherLabel.text = [lastStr3 stringByReplacingOccurrencesOfString:@"℃" withString:@"°"];
                
                
                self.myTempLabel.text = weather;
                self.myWeatherView.type = [self getIconViewType:weather];
                [self.myWeatherView setNeedsDisplay];
         
            }
        }
        
    }
    else{
        NSString *locationStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"place"];
        NSArray *array = [locationStr componentsSeparatedByString:@","];
        NSString *city = [array lastObject];
        
    NSString *requestString = [NSString stringWithFormat:@"http://wthrcdn.etouch.cn/weather_mini?city=%@",city];
    // NSString *childName = [postStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *requestStr = [requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    // 请求的URL地址
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[ NSURL URLWithString:requestStr]];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"~~~~~~~%lu,%@", (unsigned long)data.length,str);
        // NSString *resultStr = @"保存失败";
        if (data!=nil){
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            formatter.dateFormat = @"YYYY-MM-dd";
            NSDate *date = [NSDate date];
            NSString *dateStr = [formatter stringFromDate:date];
            NSString  *weatherKeyStr= [NSString stringWithFormat:@"%@temp",dateStr];
            [[NSUserDefaults standardUserDefaults] setValue:data forKey:weatherKeyStr];

            //            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            //            NSString *result = [dic   objectForKey:@"status"];
            //            if ([result isEqualToString:@"SUCCESS"]){
            NSDictionary *dic = [NSJSONSerialization  JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            if (dic!=nil){
                NSDictionary *dic1 = [dic objectForKey:@"data"];
                NSArray *resultAry = [dic1 objectForKey:@"forecast"];
                self.myTodayTempLabel.text = [NSString stringWithFormat:@"%@",[dic1 objectForKey:@"wendu"]];
                
                NSDictionary *dic11 = [resultAry objectAtIndex:0];
                NSString *weather = [dic11  objectForKey:@"type"];
                
                NSDictionary *dic22 = [resultAry objectAtIndex:1];
                NSString *low22 = [dic22 objectForKey:@"low"];
                NSString *low2= [low22 substringFromIndex:3];
                
                NSString *high22 = [dic22  objectForKey:@"high"];
                NSString *high2 = [high22 substringFromIndex:3];
                NSString *weather2 = [dic22 objectForKey:@"type"];
                NSString *lastStr2 = [NSString stringWithFormat:@"%@/%@%@",low2,high2,weather2];
                self.myTomorrowWeatherLabel.text = [lastStr2 stringByReplacingOccurrencesOfString:@"℃" withString:@"°"];
                
                
                NSDictionary *dic33 = [resultAry objectAtIndex:2];
                NSString *low33 = [dic33 objectForKey:@"low"];
                NSString *low3= [low33 substringFromIndex:3];
                
                NSString *high33 = [dic33  objectForKey:@"high"];
                NSString *high3 = [high33 substringFromIndex:3];
                NSString *weather3 = [dic33 objectForKey:@"type"];
                NSString *lastStr3 = [NSString stringWithFormat:@"%@/%@%@",low3,high3,weather3];
                self.myTomorrowNextDayWeatherLabel.text = [lastStr3 stringByReplacingOccurrencesOfString:@"℃" withString:@"°"];
                
                
                self.myTempLabel.text = weather;
                self.myWeatherView.type = [self getIconViewType:weather];
                [self.myWeatherView setNeedsDisplay];
            }
            
            
        }
        
        
        
    }];
    }
    
}
//判断天气改选用哪个图标
-(SKYIconType)getIconViewType:(NSString*)weather{
    SKYIconType type;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH"];
    NSString *str = [formatter stringFromDate:[NSDate date]];
    int time = [str intValue];
    if([weather rangeOfString:@"晴"].location !=NSNotFound){
        
        if (time>=18||time<=06) {
            NSLog(@"晚上");
            type = SKYClearNight;
        }
        else{
            NSLog(@"早上");
            type = SKYClearDay;
        }
        
    }
    else if ([weather rangeOfString:@"多云"].location !=NSNotFound){
        if (time>=18||time<=06) {
            // NSLog(@"晚上");
            type = SKYPartlyCloudyNight;
        }
        else{
            //     NSLog(@"早上");
            type = SKYPartlyCloudyDay;
        }
        
    }
    else if ([weather rangeOfString:@"阴"].location !=NSNotFound){
        type = SKYCloudy;
    }
    else if ([weather rangeOfString:@"雨"].location !=NSNotFound){
        type = SKYRain;
    }
    else if ([weather rangeOfString:@"雪"].location !=NSNotFound){
        type = SKYSnow;
    }
    return type;
}
-(void)configData{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"YYYY-MM-dd";
    NSDate *date = [NSDate date];
    NSString *dateStr = [formatter stringFromDate:date];

    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:dateStr];

    NSDictionary *nextDayDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    
    if (nextDayDic!=nil){
        NSString *result = [nextDayDic objectForKey:@"status"];
        if ([result isEqualToString:@"SUCCESS"]){
            NSDictionary *dic = [nextDayDic objectForKey:@"bean"];
            
            NSString  *urlStr= [dic objectForKey:@"imagePath"];
            [self.myBgImageView setImageWithURL:[NSURL URLWithString:urlStr]];
            //        NSString *placeStr = [dic     objectForKey:@"imagePlace"];
            //        self.placeNameLabel.text = placeStr;
            NSDate *date = [NSDate date];
            NSString *nongLi = [self getChineseCalendarWithDate:date];
            NSString *festivalStr = [dic objectForKey:@"festival"];
            if ([festivalStr isKindOfClass:[NSNull class]])
                festivalStr = @"";
            
            self.myPlaceNameLabel.text = [NSString stringWithFormat:@"%@ %@",nongLi,festivalStr];
            
            NSString *theWordStr = [dic   objectForKey:@"imageDesc"];
            self.myWordLabel.text = theWordStr;
            self.myWordLabel.lineBreakMode = NSLineBreakByWordWrapping;
            self.myWordLabel.numberOfLines = 0;
            
            NSString *bgColorStr = [dic objectForKey:@"fontBgColor"];
            NSString *str = [NSString stringWithFormat:@"0x%@",bgColorStr];
            // NSLog(@"ssssss----%X",str.integerValue);
            long colorLong = strtoul([str cStringUsingEncoding:NSUTF8StringEncoding], 0, 16);
            // 通过位与方法获取三色值
            int R = (colorLong & 0xFF0000 )>>16;
            int G = (colorLong & 0x00FF00 )>>8;
            int B = colorLong & 0x0000FF;
            
            //string转color
            UIColor *wordColor = [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0];
            //self.myColor = wordColor;
            //self.myTiaoYangTimeVIew.backgroundColor = [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:0.4 ];
            //            self.mySepView.backgroundColor = [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:0.4 ];
            self.myWordLabel.backgroundColor = wordColor;
            
            
            
        }
        else{
            
            UIColor *theColor = [UIColor colorWithRed:0.410 green:0.474 blue:0.934 alpha:1.000];
            // self.myTiaoYangTimeVIew.backgroundColor = [UIColor colorWithRed:0.410 green:0.474 blue:0.934 alpha:0.4];
            
            self.myWordLabel.backgroundColor = theColor;
        }
    }
    else{
        
        UIColor *theColor = [UIColor colorWithRed:0.410 green:0.474 blue:0.934 alpha:1.000];
        
        self.myWordLabel.backgroundColor = theColor;
        
    
       }
    // [self syncShiChenView];
    [self.myWordLabel sizeToFit];
}
//农历
-(NSString*)getChineseCalendarWithDate:(NSDate *)date{
    
    //    NSArray *chineseYears = [NSArray arrayWithObjects:
    //                             @"甲子", @"乙丑", @"丙寅", @"丁卯",  @"戊辰",  @"己巳",  @"庚午",  @"辛未",  @"壬申",  @"癸酉",
    //                             @"甲戌",   @"乙亥",  @"丙子",  @"丁丑", @"戊寅",   @"己卯",  @"庚辰",  @"辛己",  @"壬午",  @"癸未",
    //                             @"甲申",   @"乙酉",  @"丙戌",  @"丁亥",  @"戊子",  @"己丑",  @"庚寅",  @"辛卯",  @"壬辰",  @"癸巳",
    //                             @"甲午",   @"乙未",  @"丙申",  @"丁酉",  @"戊戌",  @"己亥",  @"庚子",  @"辛丑",  @"壬寅",  @"癸丑",
    //                             @"甲辰",   @"乙巳",  @"丙午",  @"丁未",  @"戊申",  @"己酉",  @"庚戌",  @"辛亥",  @"壬子",  @"癸丑",
    //                             @"甲寅",   @"乙卯",  @"丙辰",  @"丁巳",  @"戊午",  @"己未",  @"庚申",  @"辛酉",  @"壬戌",  @"癸亥", nil];
    
    NSArray *chineseMonths=[NSArray arrayWithObjects:
                            @"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",
                            @"九月", @"十月", @"冬月", @"腊月", nil];
    
    
    NSArray *chineseDays=[NSArray arrayWithObjects:
                          @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                          @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                          @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];
    
    
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:date];
    
    NSLog(@"%ld_%ld_%ld  %@",(long)localeComp.year,(long)localeComp.month,(long)localeComp.day, localeComp.date);
    
    // NSString *y_str = [chineseYears objectAtIndex:localeComp.year-1];
    NSString *m_str = [chineseMonths objectAtIndex:localeComp.month-1];
    NSString *d_str = [chineseDays objectAtIndex:localeComp.day-1];
    
    NSString *chineseCal_str =[NSString stringWithFormat: @"%@%@",m_str,d_str];
    
    // [localeCalendar release];
    
    return chineseCal_str;
}
- (IBAction)shareBtnPressed:(id)sender {
    self.myShareView.alpha = 0.0;
       CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    if (NULL != /* DISABLES CODE */ (/* DISABLES CODE */ (&UIGraphicsBeginImageContextWithOptions))) {
        UIGraphicsBeginImageContextWithOptions(imageSize, YES, 0);
    }
   
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (UIWindow * window in [[UIApplication sharedApplication] windows]) {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen]) {
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            CGContextConcatCTM(context, [window transform]);
            CGContextTranslateCTM(context, -[window bounds].size.width*[[window layer] anchorPoint].x, -[window bounds].size.height*[[window layer] anchorPoint].y);
            [[window layer] renderInContext:context];
            
            CGContextRestoreGState(context);
        }
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    
   
    
    
    NSData *imageViewData = UIImagePNGRepresentation(image);
    
   
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"分享内容"
                                       defaultContent:@"测试一下"
                                                image:[ShareSDK imageWithData:imageViewData fileName:nil mimeType:nil]
                                                title:@"微养生"
                                                  url:@"http://www.seekang.com"
                                          description:@"这是一条测试信息"
                                            mediaType:SSPublishContentMediaTypeImage];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }
                            }];
}

- (IBAction)closeShareBtnPressed:(id)sender {
    self.myShareView.alpha = 0.0;

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

-(void)getHttpData{
    NSLog(@"main取数据");
    if([TPHttpRequest netReached]){
        //判断用户是否登陆过
        [self getUserData];
        //获取遮罩页数据
        [self getNextDayData];
        [self configData];
        [self.myTimer invalidate];
    }
    else{
        [TPHttpRequest showMessage:@"请检查网络连接"];
        [self performSelector:@selector(getHttpData) withObject:nil afterDelay:10.0];
    }
}

-(void)getUserData{
    
    if ([TPHttpRequest netReached]){
        NSString *phoneNum = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNum"];
        NSString *passWordStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
        //登录
        if (phoneNum!=nil&&phoneNum.length!=0){
            //先要登录
            NSString *postStr = [NSString stringWithFormat:@"phoneNum=%@&password=%@",phoneNum,passWordStr];
            
            //        NSString *childName = [postStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSData *requestData = [postStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
            
            // 请求的URL地址
            //NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[@"http://120.27.36.130/TonguePepSys/task/get?"  stringByAppendingString:childName]]];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:LOGINADDRESS]];
            [request setHTTPBody:requestData];
            [request setHTTPMethod:@"post"];
            
            // 执行请求
            NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            NSString *getStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSString *str2 = [getStr stringByReplacingOccurrencesOfString:@"null" withString:@"\"未设置\""];
            NSData *newData = [str2 dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
            NSLog(@"data:%@",getStr);
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:newData options:NSJSONReadingMutableLeaves error:nil];
            
            NSString *result = [dic objectForKey:@"status"];
            if ([result isEqualToString:@"LOGIN_SUCCESS"]){
                [[NSUserDefaults standardUserDefaults] setObject:dic  forKey:@"userDic"];

            }
        }
    }
    else{
        NSLog(@"无网络    ");
    }
}
-(void)getNextDayData{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"YYYY-MM-dd";
    NSDate *date = [NSDate date];
    NSString *dateStr = [formatter stringFromDate:date];
    NSData *theData = [[NSUserDefaults standardUserDefaults] objectForKey:dateStr];
    if (theData==nil){
        
        
        NSString *postStr = [NSString stringWithFormat:@"deviceId=%@",DEFINEUSERID];
        
        //        NSString *childName = [postStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSData *requestData = [postStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        
        // 请求的URL地址
        //NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[@"http://120.27.36.130/TonguePepSys/task/get?"  stringByAppendingString:childName]]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:NEXTDAYURL]];
        [request setHTTPBody:requestData];
        [request setHTTPMethod:@"post"];
        
        // 执行请求
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        //    NSString *getStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        //    NSString *str2 = [getStr stringByReplacingOccurrencesOfString:@"null" withString:@"\"未设置\""];
        //    NSData *newData = [str2 dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        //    NSLog(@"data:%@",getStr);
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"YYYY-MM-dd";
        NSDate *date = [NSDate date];
        NSString *dateStr = [formatter stringFromDate:date];
        [[NSUserDefaults standardUserDefaults] setValue:data forKey:dateStr];
}
}
@end
