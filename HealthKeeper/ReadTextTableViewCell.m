//
//  ReadTextTableViewCell.m
//  HealthKeeper
//
//  Created by apple on 15/8/4.
//  Copyright (c) 2015年 山西协康云享科技有限公司. All rights reserved.
//

#import "ReadTextTableViewCell.h"

@implementation ReadTextTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.cellBgView.layer.cornerRadius = 5.0;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
