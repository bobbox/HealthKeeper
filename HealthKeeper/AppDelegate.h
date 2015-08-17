//
//  AppDelegate.h
//  HealthKeeper
//
//  Created by wangzhipeng on 15/7/16.
//  Copyright (c) 2015年 山西协康云享科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic,strong) UINavigationController *myNav;
//保存用户登录以后的个人数据
@property (nonatomic,strong) NSDictionary *appUserDic;
//保存用户的nextday信息
@property (nonatomic,strong) NSDictionary *appNextDayDic;
//保存用户的舌拍数据
@property (nonatomic,strong) NSMutableDictionary *tongueDic;
//保存舌头图片
@property (nonatomic,strong) UIImage *myTongueImg;
//保存注册用户的个人信息
@property (nonatomic,strong) NSMutableDictionary *userAccountDic;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

