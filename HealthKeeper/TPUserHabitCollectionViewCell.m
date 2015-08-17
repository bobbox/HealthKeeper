//
//  TPUserHabitCollectionViewCell.m
//  HealthKeeper
//
//  Created by apple on 15/8/11.
//  Copyright (c) 2015年 山西协康云享科技有限公司. All rights reserved.
//

#import "TPUserHabitCollectionViewCell.h"

@implementation TPUserHabitCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    self.cellImageView.layer.cornerRadius = 4.0;
    self.cellImageView.layer.masksToBounds = YES;
    
}

@end
