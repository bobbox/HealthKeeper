//
//  TPTextDetailViewController.h
//  HealthKeeper
//
//  Created by apple on 15/8/7.
//  Copyright (c) 2015年 山西协康云享科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPTabSubViewController.h"
@interface TPTextDetailViewController : TPTabSubViewController<UIWebViewDelegate>
@property (nonatomic)NSDictionary *myDataDic;
@property (strong, nonatomic) IBOutlet UIWebView *myWebView;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (weak, nonatomic) IBOutlet UILabel *myTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *myTopImageView;
@property (weak, nonatomic) IBOutlet UIView *myView1;
@property (weak, nonatomic) IBOutlet UIView *myView2;
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *myLastTimeUpdateLabel;
- (IBAction)back:(id)sender;
- (IBAction)doTest:(id)sender;
@end
