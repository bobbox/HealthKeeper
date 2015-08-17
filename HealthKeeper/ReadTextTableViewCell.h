//
//  ReadTextTableViewCell.h
//  HealthKeeper
//
//  Created by apple on 15/8/4.
//  Copyright (c) 2015年 山西协康云享科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReadTextTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *cellBgView;
@property (strong, nonatomic) IBOutlet UIImageView *cellImageView;
@property (strong, nonatomic) IBOutlet UILabel *cellTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *cellClassLabel;
@property (strong, nonatomic) IBOutlet UILabel *cellTimeLabel;

@end
