//
//  TPTakeTonguePhotoViewController.h
//  TonguePep
//
//  Created by apple on 15-1-17.
//  Copyright (c) 2015年 山西协康云享科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraImageHelper.h"
@class TPTakeTonguePhotoViewController;
@protocol getPhotoDelegate

-(void)viewController:(TPTakeTonguePhotoViewController *) viewContorller getimage:(UIImage *)image;

@end

@protocol photoFinishedDelegate

-(void)photoFinished;

@end
@interface TPTakeTonguePhotoViewController : UIViewController<getPhotoDelegate>
@property (strong,nonatomic) CameraImageHelper *cameraHelper;

@property (strong, nonatomic) IBOutlet UIView *takePhotoView;

@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;
@property (strong, nonatomic) IBOutlet UIButton *takePhotoBtn;
@property (strong, nonatomic) IBOutlet UIButton *usePhotoBtn;

@property (strong, nonatomic) IBOutlet UIView *takePhotoBtnView;
@property (strong, nonatomic) IBOutlet UIView *usePhotoBtnView;
//定时器，用来获取人脸照片并人脸识别
@property (nonatomic,strong) NSTimer *takePhotoTimer;

@property (nonatomic,strong) NSTimer *myScanTimer;

- (IBAction)takePhoto:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)usePhoto:(id)sender;
- (IBAction)retakePhoto:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *getImageView;
- (IBAction)changeCamera:(id)sender;

@property(assign)id<getPhotoDelegate> delegate;
@property(assign)id<photoFinishedDelegate> finishedDelegate;
//开始扫描按钮
@property (weak, nonatomic) IBOutlet UIButton *scanBtn;
- (IBAction)beginScan:(id)sender;

//存放排便任务相关数据，如果用户保存数据并且成功以后，发送信息，任务完成
@property (nonatomic,strong) NSDictionary *myAllTaskDic;
@property (nonatomic) NSInteger selectedNum;
@property (nonatomic,strong) NSString *myPersonIdStr;


-(BOOL)uploadPhoto;
@end
