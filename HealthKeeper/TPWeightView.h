//
//  TPWeightView.h
//  HealthKeeper
//
//  Created by apple on 15/8/8.
//  Copyright (c) 2015年 山西协康云享科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TPWeightDelegate <NSObject>

- (void) numberPickerViewDidChangeValue:(int)num;

@end
@interface TPWeightView : UIView<UIScrollViewDelegate>
@property (strong, nonatomic)  UIScrollView *myScrollView;
@property (nonatomic, weak) id <TPWeightDelegate> delegate;




    
 


@end
