//
//  customDefine.h
//  TonguePep
//
//  Created by apple on 15-1-19.
//  Copyright (c) 2015年 山西协康云享科技有限公司. All rights reserved.
//

#ifndef TonguePep_customDefine_h
#define TonguePep_customDefine_h

//判断设备类型
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
//判断系统版本
#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )

//#define TPSERVERADDRESS @"http://120.27.36.130:8080/health/"

//用户注册成功后上传用户身高体重等数据
#define USER_UPLOAD_INFO_URL @"http://120.27.36.130/MicroHealth/user/register_info"

#define TPSERVERADDRESS @"http://120.27.36.130:80/TonguePepSys/tongue/analyze"
#define  LOGINADDRESS @"http://120.27.36.130/MicroHealth/user/login"

#define  REGISTERADDRESS @"http://120.27.36.130/MicroHealth/user/register"
//重置密码
#define PASSWORDRESET @"HTTP://120.27.36.130/TonguePepSys/user/reset"

//获取调养任务URL http://120.27.36.130/TonguePepSys/task/get?userId=123&timeText=亥
#define TIAOYANGMISSIONLIST @"http://120.27.36.130/TonguePepSys/task/get"
//完成任务需要向服务器传回的url
#define TIAOYANGFINISHEDURL @"http://120.27.36.130/TonguePepSys/task/update"

#define    DEFINEUSERID   [[UIDevice currentDevice].identifierForVendor UUIDString]
//获取调查问卷的Url
#define BODYTESTQUESTIONSLIST @"http://120.27.36.130/TonguePepSys/question/list"
//提交问卷url
#define GETBODYTESTRESULT @"http://120.27.36.130/TonguePepSys/question/submit"
//获取nextday数据
#define NEXTDAYURL @"http://120.27.36.130/MicroHealth/nextday/get"
//风格颜色
#define STYLECOLOR [UIColor colorWithRed:0.973 green:0.961 blue:0.929 alpha:0.9100]
//排尿
#define  GET_SHIT_URL  @"http://120.27.36.130/TonguePepSys/health/get_shit"
#define  ADD_SHIT_URL  @"http://120.27.36.130/TonguePepSys/health/add_shit"
#define  GET_URINE_URL  @"http://120.27.36.130/TonguePepSys/health/get_urine"
#define  ADD_URINE_URL @"http://120.27.36.130/TonguePepSys/health/add_urine"
//个人信息修改
#define USER_UPDATE_URL @"http://120.27.36.130/TonguePepSys/user/update"
//用户头像修改
#define USER_PHOTO_UPDATE_URL @"http://120.27.36.130/TonguePepSys/user/avatar"
//个人健康报告
#define USER_HEALTH_REPORT_URL @"http://120.27.36.130/TonguePepSys/health/report"
//上传计步数据的借口
#define USER_STEP_UPLOAD_URL @"http://120.27.36.130/TonguePepSys/health/add_step"

//获取推荐食物的页面，需要有舌拍记录后再请求
#define USER_FOOD_URL @"http://120.27.36.130/TonguePepSys/health/food"

//选中的食物分析url
#define FOOD_ANALYSE_URL @"http://120.27.36.130/TonguePepSys/health/foodAnalyse"
//增加饮水记录的url
#define DRINK_ADD_URL @"http://120.27.36.130/TonguePepSys/health/add_water"
//获取饮水记录url
#define DRINK_GET_URL @"http://120.27.36.130/TonguePepSys/health/get_water"
//获取养生达人列表url
#define MASTER_USER_LIST_URL @"http://120.27.36.130/MicroHealth/user/recommend"
//获取养生文章列表 method: POSTparameters:timeText:子/丑   page: 0/1/2
#define READ_TEXT_LIST_URL @"http://120.27.36.130/MicroHealth/article/list"
//获取养生文章列表
#define READ_TEXT_DETAIL_URL @"http://120.27.36.130/MicroHealth/article/get"
//获取养生好习惯列表
#define USER_HEALTH_HABIT_LIST_URL @""
#define kUIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#endif
