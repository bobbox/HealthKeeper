//
//  TPTestMapView.m
//  TonguePep
//
//  Created by wangzhipeng on 15/4/1.
//  Copyright (c) 2015年 山西协康云享科技有限公司. All rights reserved.
//

#import "TPTestMapView.h"

@implementation TPTestMapView


-(void)drawRect:(CGRect)rect{
    for (UIView *vw in self.subviews) {
        [vw removeFromSuperview];
    }
    
    int width = self.frame.size.width;
    int height = self.frame.size.height;
    int singleWidth = (width-40)/self.dataAry.count;
    int distance = 40/self.dataAry.count;
    CGFloat heightDegree = (height-20)/100.00;
   
    UIView *higherView = [[UIView alloc] initWithFrame:CGRectMake(0, (100-self.highLevel)*heightDegree, self.frame.size.width, 1)];
    higherView.backgroundColor = [UIColor colorWithRed:0.161 green:0.675 blue:0.659 alpha:1.000];
    UIView *lowerView = [[UIView alloc]initWithFrame:CGRectMake(0, (100-self.lowLevel)*heightDegree, self.frame.size.width, 1)];
    lowerView.backgroundColor = [UIColor colorWithRed:0.922 green:0.541 blue:0.400 alpha:1.000];
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 100*heightDegree, self.frame.size.width, 1)];
    bottomView.backgroundColor = [UIColor colorWithWhite:0.710 alpha:1.000];
    [self addSubview:higherView];
    [self addSubview:lowerView];
    [self addSubview:bottomView];
    
    for(int i=0;i<self.dataAry.count;i++){
        NSString *num = [self.dataAry objectAtIndex:i];
        UIView *vw = [[UIView alloc]initWithFrame:CGRectMake((distance+singleWidth)*i, (100-num.intValue)*heightDegree, singleWidth, num.intValue*heightDegree)];
        if (num.intValue>=self.highLevel)
            vw.backgroundColor = [UIColor colorWithRed:0.161 green:0.675 blue:0.659 alpha:1.000];
        else if (num.intValue<self.highLevel&&num.intValue>=self.lowLevel)
            vw.backgroundColor = [UIColor colorWithRed:0.922 green:0.541 blue:0.400 alpha:1.000];
        else
            vw.backgroundColor = [UIColor colorWithWhite:0.710 alpha:1.000];
        
        [self addSubview:vw];
        
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake((distance+singleWidth)*i, 100*heightDegree, singleWidth, 20)];
        lbl.backgroundColor = [UIColor clearColor];
        lbl.textColor = [UIColor colorWithWhite:0.710 alpha:1.000];
        lbl.font  = [UIFont boldSystemFontOfSize:6.0];
        lbl.numberOfLines = 1;
        //[lbl sizeToFit];
        lbl.text = [self.tipAry objectAtIndex:i];
        [self addSubview:lbl];
    }
    
}

@end
