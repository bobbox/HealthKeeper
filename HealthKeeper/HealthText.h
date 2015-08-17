//
//  HealthText.h
//  HealthKeeper
//
//  Created by apple on 15/8/4.
//  Copyright (c) 2015年 山西协康云享科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol tableviewCellSelectedDelegate
-(void)cellSelectedWithRow:(int)row;
@end

@interface HealthText : NSObject<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)NSMutableArray *myDataAry;
@property id<tableviewCellSelectedDelegate> delegate;

@end
