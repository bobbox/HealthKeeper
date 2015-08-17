//
//  TPTakeTonguePhotoViewController.m
//  TonguePep
//
//  Created by apple on 15-1-17.
//  Copyright (c) 2015年 山西协康云享科技有限公司. All rights reserved.
//

#import "TPTakeTonguePhotoViewController.h"
#import "CameraImageHelper.h"

#import "UIImagefixOrientation.h"
#import "UIImageExtras.h"
#import "ASIFormDataRequest.h"
#import "customDefine.h"
#import "TPHttpRequest.h"
//#import "TPTongueViewController.h"
@interface TPTakeTonguePhotoViewController ()
@property (nonatomic) int  counter;
@property (nonatomic,strong)UIImageView *myScanImageView;

//保存到首页用来展示的图片
@property (nonatomic ,strong) UIImage *myShowImage;

//传到后台的图片
@property (nonatomic,strong)UIImage *myTongueImg;
//存放获取的舌苔数据
@property (nonatomic,strong) NSMutableArray *myTongueAry;
//保存当前新用户所有拍照数据
@property (nonatomic,strong) NSMutableArray *myTongueListAry;

@property (nonatomic,strong)UIImage *myFaceImage;

@end

@implementation TPTakeTonguePhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.takePhotoBtnView.hidden = NO;
    self.usePhotoBtnView.hidden = YES;
    self.cameraHelper = [[CameraImageHelper alloc]init];
    [self.cameraHelper startRunning];
    [self.cameraHelper embedPreviewInView:self.takePhotoView];
    [self.cameraHelper changePreviewOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    self.counter = 0;
    self.scanBtn.titleLabel.lineBreakMode = 0;
    self.scanBtn.layer.cornerRadius = 4;
    self.scanBtn.layer.masksToBounds = YES;
    
    self.myScanImageView = [[UIImageView alloc]initWithFrame:CGRectMake(95, 275, 131, 39)];
    self.myScanImageView.image = [UIImage imageNamed:@"scanLine.png"];
    [self.view addSubview:self.myScanImageView];
    
    self.myTongueAry = [NSMutableArray array];
    self.myTongueListAry = [NSMutableArray array];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear :(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.takePhotoTimer invalidate];
    [self.myScanTimer    invalidate];
}

-(void)takePhotoAndFaceDetact{
    self.counter++;
    //[self scan];
    //[self performSelectorInBackground:@selector(scan) withObject:nil];
    
    //时间超过5miao钟就提示调整环境并退出
    if (_counter>=20){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请调整拍摄环境再试！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [self.takePhotoTimer invalidate];
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    [self.cameraHelper CaptureStillImage];
    [self.delegate viewController:self getimage:self.cameraHelper.image];
}

-(void)getImage
{
    [self.cameraHelper stopRunning];
    //    self.myView.image = [self.cameraHelper image];
    //    NSLog(@"大大大大大大大%f,%f",self.myView.image.size.height,self.myView.image.size.width);
    self.takePhotoBtnView.hidden = YES;
    self.usePhotoBtnView.hidden = NO;
}

- (IBAction)takePhoto:(id)sender {
    [self.cameraHelper CaptureStillImage];
    [self performSelector:@selector(getImage) withObject:nil afterDelay:0.5];
}

- (IBAction)cancel:(id)sender {
    [self.takePhotoTimer invalidate];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)usePhoto:(id)sender {
    [self.delegate viewController:self getimage:self.cameraHelper.image];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)retakePhoto:(id)sender {
    self.takePhotoBtnView.hidden =NO;
    self.usePhotoBtnView.hidden = YES;
    [self.cameraHelper startRunning];
}

- (IBAction)changeCamera:(id)sender {
    [self.cameraHelper swapFrontAndBackCameras];
}

- (IBAction)beginScan:(id)sender {
    // [self performSelectorInBackground:@selector(getScan) withObject:nil];
//    self.myScanTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(scan) userInfo:nil repeats:YES];
//[[NSRunLoop mainRunLoop] addTimer:self.myScanTimer forMode:NSDefaultRunLoopMode];
    NSThread* timerThread = [[NSThread alloc] initWithTarget:self selector:@selector(getScan) object:nil];
    [timerThread start];
      self.takePhotoTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(takePhotoAndFaceDetact) userInfo:nil repeats:YES];
     }

-(void)getScan{
   // NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
    self.myScanTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(scan) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.myScanTimer forMode:NSRunLoopCommonModes];
    [runLoop run];
}

-(void)scan{
    NSLog(@"scan............");
    CGFloat yValue = self.myScanImageView.frame.origin.y;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.8];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    if ((int)yValue==275)
    self.myScanImageView.frame = CGRectMake(95, 275+130, 131, 39);
    else
        self.myScanImageView.frame = CGRectMake(95, 275, 131, 39);

    //  self.myGuideView.layer.transform = CATransform3DMakeScale(0.5, 0.5, 0.5);
    // self.myGuideView.frame = CGRectMake(80, 142, 160, 284);
    [UIView commitAnimations];
}


-(void)viewController:(TPTakeTonguePhotoViewController *)viewContorller getimage:(UIImage *)image{
    UIImage * theImage = image;
    NSLog(@"大大大大大大大%f,%f",theImage.size.height,theImage.size.width);
    UIImage *img1 = [theImage fixOrientation];
    self.myFaceImage = img1;
    
    CIImage* faceImg = [CIImage imageWithCGImage:img1.CGImage];
    
    //create a face detector
    //此处是CIDetectorAccuracyHigh，若用于real-time的人脸检测，则用CIDetectorAccuracyLow，更快
    NSDictionary  *opts = [NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh
                                                      forKey:CIDetectorAccuracy];
    CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:nil
                                              options:opts];
    
    //Pull out the features of the face and loop through them
    NSArray* features = [detector featuresInImage:faceImg];
    
    if ([features count]==0) {
        NSLog(@">>>>> 人脸监测【失败】啦 ～！！！");
    }
    else{
        NSLog(@">>>>> 人脸监测【成功】～！！！>>>>>> ");
        [self cutTongueImage:img1];
        if ([self uploadPhoto]){
            
            [viewContorller.cameraHelper stopRunning];
            [viewContorller.takePhotoTimer setFireDate:[NSDate distantFuture]];
            [viewContorller.myScanTimer setFireDate:[NSDate distantFuture]];
            CGSize size = CGSizeMake(320,568);
            UIGraphicsBeginImageContext(size);
            [img1 drawInRect:CGRectMake(0, 0, 320, 568)];
            UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            self.myShowImage = [self imageFromImage:resultingImage inRect:CGRectMake(95, 275, 130, 130)];
           // [HealthText appDelegate].tongueImage = self.myShowImage;
             [self performSelectorInBackground:@selector(commitMissionCompleted) withObject:nil];
            
            [self dismissViewControllerAnimated:NO completion:nil];
            [self.finishedDelegate photoFinished];

//            TPTongueViewController *vc = [[TPTongueViewController alloc]init];
//            [viewContorller.navigationController  pushViewController:vc animated:YES];
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"拍照完毕" object:nil];
        }
        else{
            [viewContorller.takePhotoTimer setFireDate:[NSDate distantPast]];
        }
        
        //[viewContorller.takePhotoTimer  invalidate];
    }
}
-(void)cutTongueImage:(UIImage*)tongueImage{
    UIImage *img;
    if (iPhone5) {
        img = [tongueImage rescaleImageToSize:CGSizeMake(320, 568)];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"she5" ofType:@"png"];
        UIImage *imageOne = [UIImage imageWithContentsOfFile:path];
        //合成有背景图的新照片
        UIImage *endImage = [self createImageWithImage1:img image2:imageOne];
        self.myTongueImg = [self imageFromImage:endImage inRect:CGRectMake(90, 275, 140, 165)];
        //UIImageWriteToSavedPhotosAlbum(self.myImage, self,  nil , nil ) ;
    }
    else
    {
        if (IOS7_OR_LATER) {
            img = [tongueImage rescaleImageToSize:CGSizeMake(320, 480)];
            NSString *path = [[NSBundle mainBundle] pathForResource:@"she7" ofType:@"png"];
            UIImage *imageOne = [UIImage imageWithContentsOfFile:path];
            //合成有背景图的新照片
            UIImage *endImage = [self createImageWithImage1:img image2:imageOne];
            self.myTongueImg = [self imageFromImage:endImage inRect:CGRectMake(90, 260, 140, 160)];
        }
        else
        {
            img = [tongueImage rescaleImageToSize:CGSizeMake(320, 480)];
            NSString *path = [[NSBundle mainBundle] pathForResource:@"she1" ofType:@"png"];
            UIImage *imageOne = [UIImage imageWithContentsOfFile:path];
            //合成有背景图的新照片
            UIImage *endImage = [self createImageWithImage1:img image2:imageOne];
            self.myTongueImg = [self imageFromImage:endImage inRect:CGRectMake(90, 280, 140, 160)];
        }
    }
    
}
-(UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect {
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    return newImage;
}
-(UIImage *)createImageWithImage1:(UIImage *)image1 image2:(UIImage *)image2{
    
    CGSize size = CGSizeMake(320,568);
    UIImage *img1 = [image1 rescaleImageToSize:CGSizeMake(320, 568)];
    UIImage *img2 = [image2 rescaleImageToSize:CGSizeMake(320, 568)];
    UIGraphicsBeginImageContext(size);
    CGRect myRect = CGRectMake(0, 0, 320, 568);
    [img1 drawInRect:myRect];
    
    [img2 drawInRect:CGRectMake(0, 0, 320, 568)];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}
-(BOOL)uploadPhoto{
    if (self.myTongueImg==nil)
        return NO;
    NSString *username=@"";
    NSString *myUrl = @"";
    
    //        myUrl =[NSString  stringWithFormat: @"%@hdfs!tongueHandle.action?mr.userName=%@",TONGUEADDRESS,username];
   // myUrl =[NSString  stringWithFormat: @"%@tongue/uploadAndAnalyze?username=aa",TPSERVERADDRESS];
    NSString *phoneNum = [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNum"];
    if (phoneNum==nil)
        phoneNum = DEFINEUSERID;
    
   // myUrl =[NSString  stringWithFormat: @"%@?username=%@",TPSERVERADDRESS,phoneNum];
    myUrl =[NSString  stringWithFormat: @"%@?phoneNum=15296611713",TPSERVERADDRESS];
    NSLog(@"%@",myUrl);
    NSURL *url = [NSURL URLWithString: myUrl];
    
    NSData *imageData = UIImageJPEGRepresentation(self.myTongueImg,0.7);
   
    ASIFormDataRequest *myRequest = [ASIFormDataRequest requestWithURL:url];
    //获取系统时间定义图片名字
    NSString* date;
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYYMMddHHmmss"];
    date = [formatter stringFromDate:[NSDate date]];
    
    NSString *fileName = [NSString stringWithFormat:@"%@%@.jpg",username,date];
    NSLog(@"%@,DATA legth:%lu",fileName, (unsigned long)imageData.length);
    
    UIProgressView *myProgress = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleBar];
    myProgress.frame = CGRectMake(10, 50, 300, 20);
    
    [myRequest setData:imageData withFileName:fileName andContentType:nil forKey:@"file"];
    myRequest.timeOutSeconds = 360;
    [myRequest buildPostBody];
    myRequest.tag =2;
    [myRequest setDelegate:self];
    [myRequest startSynchronous];
    
    NSData *data = myRequest.responseData;
    NSString *resposeStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",resposeStr);
    NSString *getStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSString *str2 = [getStr stringByReplacingOccurrencesOfString:@"null" withString:@"\"未设置\""];
    NSData *newData = [str2 dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:newData options:NSJSONReadingMutableLeaves error:nil];
    NSString *resultStatus = [dic objectForKey:@"status"];
    if (resultStatus!=nil&&[resultStatus isEqualToString:@"MATCHING_SECCESS"]){
//    NSString *tongueNmae = [dic  objectForKey:@"tongueName"];
//    if ([tongueNmae isEqualToString:@"T T"])
//        return NO;
//    else{
    
        // self.myResultTextView.text = resposeStr;
      
        NSDictionary *subDic = [dic objectForKey:@"bean"];
    //    NSDictionary *subSubDic = [subDic objectForKey:@"cts"];
        [[TPHttpRequest appDelegate].tongueDic removeAllObjects];
    [[TPHttpRequest appDelegate].tongueDic addEntriesFromDictionary:subDic];
        [TPHttpRequest appDelegate].myTongueImg = self.myTongueImg;
        
        [[NSUserDefaults standardUserDefaults] setObject:subDic forKey:@"tongueDic"];
        [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"tongueImage"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
   }
    else
        return NO;
}
-(void)commitMissionCompleted{
    if(self.myAllTaskDic!=nil){
        NSArray *array = [self.myAllTaskDic objectForKey:@"tasks"];
        NSDictionary *taskDic = [array objectAtIndex:self.selectedNum];
        
        
        NSString *postStr = [NSString stringWithFormat:@"%@?phoneNum=%@&personalTaskId=%@&timeText=%@&taskItemId=%@&isCompleted=true",TIAOYANGFINISHEDURL,[self.myAllTaskDic objectForKey:@"userId"],[self.myAllTaskDic objectForKey:@"id"],[self.myAllTaskDic objectForKey:@"taskTimeText"],[taskDic objectForKey:@"id"]];
        NSString *childName = [postStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        // 请求的URL地址
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:childName]];
        //    // 设置请求方式
        
        // 执行请求
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *srrr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        // NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSString *result = [responseDic objectForKey:@"status"];
        if ([result isEqualToString:@"UPDATE_SUCCESS"]){
            
            NSLog(@"任务完成");
        }
    }
}
@end
