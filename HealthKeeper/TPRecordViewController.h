//
//  TPRecordViewController.h
//  HealthKeeper
//
//  Created by wangzhipeng on 15/8/8.
//  Copyright (c) 2015年 山西协康云享科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPTabSubViewController.h"
@interface TPRecordViewController : TPTabSubViewController<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *myAnswerTableView;
@property (strong, nonatomic) IBOutlet UICollectionView *myCollectionView;

- (IBAction)back:(id)sender;

@end
