//
//  TPTestAnswerTableViewCell.m
//  HealthKeeper
//
//  Created by apple on 15/8/13.
//  Copyright (c) 2015年 山西协康云享科技有限公司. All rights reserved.
//

#import "TPTestAnswerTableViewCell.h"

@implementation TPTestAnswerTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.cellTitleLabel.layer.cornerRadius = 12.0;
    self.cellTitleLabel.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
