//
//  TPTestMapView.h
//  TonguePep
//
//  Created by wangzhipeng on 15/4/1.
//  Copyright (c) 2015年 山西协康云享科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPTestMapView : UIView
@property (nonatomic,strong)NSArray *dataAry;
@property (nonatomic,strong)NSArray *tipAry;
@property (nonatomic) int theNum;//柱状图的个数
//刻度线
@property (nonatomic) int highLevel;
@property (nonatomic) int lowLevel;
@end
