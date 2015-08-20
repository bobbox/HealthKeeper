//
//  TPTestListCollectionViewCell.m
//  HealthKeeper
//
//  Created by apple on 15/8/14.
//  Copyright (c) 2015年 山西协康云享科技有限公司. All rights reserved.
//

#import "TPTestListCollectionViewCell.h"

@implementation TPTestListCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    self.cellIndexLabel.layer.cornerRadius = 4.0;
    self.cellIndexLabel.layer.borderColor = [UIColor colorWithRed:0.267 green:0.655 blue:0.357 alpha:1.000].CGColor;
    self.cellIndexLabel.layer.borderWidth = 1.0;
    self.cellIndexLabel.layer.masksToBounds = YES;
}

@end
