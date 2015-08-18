//
//  TPWeightView.m
//  HealthKeeper
//
//  Created by apple on 15/8/8.
//  Copyright (c) 2015年 山西协康云享科技有限公司. All rights reserved.
//

#import "TPWeightView.h"
#import "TPHttpRequest.h"
@interface TPWeightView () {
    NSInteger _number1Value;
    NSInteger _number2Value;
    NSInteger _number3Value;
    
    TPWeightView* _internalPickerView;
    BOOL _isStandIn;
}

@end

@implementation TPWeightView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//- (id) awakeAfterUsingCoder:(NSCoder*)aDecoder {
//    
//    // We are a stand-in view if we have zero sub-views.
//    BOOL wasPlaceholder = ([[self subviews] count] == 0);
//    
//    if (wasPlaceholder) {
//        
//        // Load the real view, and add it as a subview of ourself. Also mark ourself
//        // as a stand-in view, so that we know to forward hit tests and requests for properties.
////        _internalPickerView = [TPWeightView numberPickerView];
////        _internalPickerView.frame = self.bounds;
////        _isStandIn = YES;
////        [self addSubview:_internalPickerView];
////        
////        // Set the background to clear, so that at design-time we can use an opaque color to help identify this custom view.
////        self.backgroundColor = [UIColor clearColor];
//    }
//    return self;
//}
//- (void)awakeFromNib {
//    
//    if (_isStandIn)
//        return;
//    
//    [self prepareScrollView:self.myScrollView];
//    
//}
// Load the nib and return the newly-created picker view.

-(void)drawRect:(CGRect)rect{
    self.myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(153, 0, 14, self.frame.size.height)];
    [self addSubview:self.myScrollView];
    self.myScrollView.delegate =self;
    [self prepareScrollView:self.myScrollView];
    
    NSString *sexStr = [[TPHttpRequest appDelegate].userAccountDic objectForKey:@"userSex"];
    if ([sexStr isEqualToString:@"男"]){
        [self.myScrollView setContentOffset:CGPointMake(14*60, 0)];

    }
    else
    [self.myScrollView setContentOffset:CGPointMake(14*50, 0)];
    
    
}
+ (TPWeightView*)numberPickerView {
    UINib* nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
    NSArray* objects = [nib instantiateWithOwner:self options:nil];
    return [objects objectAtIndex:0];
}




- (void)prepareScrollView:(UIScrollView*)scrollView {
    
    
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(scrollView.bounds.size.width*151, scrollView.bounds.size.height);
    scrollView.pagingEnabled = YES;
    scrollView.clipsToBounds = NO;
    
    scrollView.showsVerticalScrollIndicator = NO;
    
    // Add a view behind all of the numbers that is extremely tall and uses a tiled background image.
    UIView* backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    CGRect frame = (CGRect){CGPointMake(-14*5, 0), CGSizeMake(scrollView.bounds.size.width*155, scrollView.bounds.size.height)};
    backgroundView.frame = frame;
    [scrollView insertSubview:backgroundView atIndex:0];
    
    for (int i = 0; i < 155; i++) {
              UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(14*i, scrollView.frame.origin.y, 50, 14)];
        bgView.backgroundColor = [UIColor clearColor];
        UIView *keDuView = [[UIView alloc]initWithFrame:CGRectMake(6, 0, 2, 20)];
        keDuView.backgroundColor = [UIColor grayColor];
        if (i%10==0){
            keDuView.frame = CGRectMake(6, 0, 2, 40);
            keDuView.backgroundColor = [UIColor orangeColor];
            
            UILabel *keduLabel = [[UILabel alloc]initWithFrame:CGRectMake(-3+i*14, 45, 60, 20)];
            keduLabel.font = [UIFont systemFontOfSize:18.0];
            keduLabel.textColor = [UIColor darkGrayColor];
            keduLabel.text = [NSString stringWithFormat:@"%ikg",i];
            if (i<5||i>150)
                keduLabel.textColor = [UIColor grayColor];
            [scrollView addSubview:keduLabel];
//            CGAffineTransform transform =CGAffineTransformMakeRotation(M_PI*3/2);
//            [keduLabel setTransform:transform];
        }
        [bgView addSubview:keDuView];
        [scrollView addSubview:bgView];
        scrollView.delegate = self;
    }
    // backgroundView.backgroundColor = [UIColor colorWithPatternImage:[SLNumberPickerView backgroundImage]];
}

// When scroll views finish moving, we can check their value.
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger page = scrollView.contentOffset.x / scrollView.bounds.size.width;
    
    
    [self.delegate  numberPickerViewDidChangeValue:page];
}
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSInteger page = scrollView.contentOffset.y / scrollView.bounds.size.height;
//    
//    
//    [self.delegate  numberPickerViewDidChangeValue:(int)page];
//}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    //    if (_isStandIn) {
    //        return [_internalPickerView hitTest:point withEvent:event];
    //    }
    
    // because all of the views are layed out in column fashion, the x coord of the touch corresponds to the view
    CGFloat y = point.y;
    NSLog(@"%f,%f",CGRectGetMinY(self.myScrollView.frame),CGRectGetMaxY(self.myScrollView.frame));
    if (y >= CGRectGetMinY(self.myScrollView.frame) && y <= CGRectGetMaxY(self.myScrollView.frame))
        return self.myScrollView;
    
    
    
    if (CGRectContainsPoint(self.frame, point))
        return self;
    
    
    return nil;
}
@end
