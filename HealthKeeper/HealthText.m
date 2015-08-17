//
//  HealthText.m
//  HealthKeeper
//
//  Created by apple on 15/8/4.
//  Copyright (c) 2015年 山西协康云享科技有限公司. All rights reserved.
//

#import "HealthText.h"
#import "ReadTextTableViewCell.h"
#import "UIImageView+WebCache.h"
@implementation HealthText
#pragma mark  tableView datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  self.myDataAry.count;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *myCell = @"cell1";
    ReadTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myCell ];
    if (cell==nil){
        cell= [[[NSBundle mainBundle]loadNibNamed:@"ReadTextTableViewCell" owner:nil options:nil] firstObject];
    }
    NSDictionary *dic = [self.myDataAry objectAtIndex:indexPath.row];
    cell.cellTitleLabel.text = [dic   objectForKey:@"title"];
    cell.cellClassLabel.text = [dic   objectForKey:@"category"];
    NSString *second = [dic objectForKey:@"lastUpdateTime"];
    NSString *timeStr = [self getDateStringFormSec:second];
    cell.cellTimeLabel.text = timeStr;
    [cell.cellImageView setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"image"]]];
    return cell;
}
#pragma  mark talblevieW delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath   {
    return 80;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate cellSelectedWithRow:(int)indexPath.row];
}
-(NSString*)getDateStringFormSec:(NSString*)second{
    NSDate *now = [NSDate date];
    NSInteger nowTimeSp = [now timeIntervalSince1970];
    long long secondInteger = second.longLongValue;
    NSInteger theSecond = secondInteger/1000;
    NSInteger useSecond = nowTimeSp - theSecond;
    NSString *returnStr = @"";
    NSInteger minute = 60;
    NSInteger hour = 60*60;
    NSInteger day = 3600*24;
    NSInteger month = 3600*24*30;
    NSInteger year = 3600*34*30*12;
    
    
    if (useSecond<60){
        returnStr = @"刚刚";
    }
    else if (useSecond>=60&&useSecond<3600){
        NSInteger num = useSecond/minute;
        returnStr = [NSString stringWithFormat:@"%ld分钟前",(long)num];
    }
    else if (useSecond>=3600&&useSecond<3600*24){
        NSInteger num = useSecond/hour;
        returnStr = [NSString stringWithFormat:@"%ld小时前",(long)num];

    }
    else if (useSecond>=3600*24&&useSecond<3600*24*30){
        NSInteger num = useSecond/day;
        returnStr = [NSString stringWithFormat:@"%ld天前",(long)num];
        
    }
    else if (useSecond>=3600*24*30&&useSecond<3600*24*30*12){
        NSInteger num = useSecond/month;
        returnStr = [NSString stringWithFormat:@"%ld月前",(long)num];
        
    }
    else {
        NSInteger num = useSecond/year;
        returnStr = [NSString stringWithFormat:@"%ld年前",(long)num];
    }
    
    return returnStr;
}
@end
