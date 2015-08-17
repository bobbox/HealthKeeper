//
//  SBLNumberPickerView.m
//  A themed number picker.
//
//  Created by Jon Manning on 21/04/12.
//  Copyright (c) 2012 Secret Lab. All rights reserved.
//

#import "SLNumberPickerView.h"

@interface SLNumberPickerView () {
    NSInteger _number1Value;
    NSInteger _number2Value;
    NSInteger _number3Value;
    
    SLNumberPickerView* _internalPickerView;
    BOOL _isStandIn;
}

@end

@implementation SLNumberPickerView

// *** v CHANGE THESE METHODS FOR CUSTOM APPEARANCE! v ***

// What font should we use?
+ (UIFont*)numberFont {
    return [UIFont fontWithName:@"Palatino" size:36];
}

// What color should the text be?
+ (UIColor*)numberColor {
    return [UIColor blackColor];
}

// Which tiled image should we use for each column?
+ (UIImage*)backgroundImage {
    return [UIImage imageNamed:@"SLNumberPickerTicks"];
}

// *** ^ CHANGE THESE METHODS FOR CUSTOM APPEARANCE! ^ ***


@synthesize number1 = _number1;


@synthesize delegate = _delegate;

// Adapted from a technique from Yang Meyer:
// https://blog.compeople.eu/apps/?p=142
- (id) awakeAfterUsingCoder:(NSCoder*)aDecoder {
    
    // We are a stand-in view if we have zero sub-views.
    BOOL wasPlaceholder = ([[self subviews] count] == 0);
    
    if (wasPlaceholder) {
        
        // Load the real view, and add it as a subview of ourself. Also mark ourself
        // as a stand-in view, so that we know to forward hit tests and requests for properties.
        _internalPickerView = [SLNumberPickerView numberPickerView];
        _internalPickerView.frame = self.bounds;
        _isStandIn = YES;
        [self addSubview:_internalPickerView];
        
        // Set the background to clear, so that at design-time we can use an opaque color to help identify this custom view.
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

// Load the nib and return the newly-created picker view.
+ (SLNumberPickerView*)numberPickerView {
    UINib* nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
    NSArray* objects = [nib instantiateWithOwner:self options:nil];
    return [objects objectAtIndex:0];
}


// Given a scroll view, fill it with labels from 0 to 9 - one label per "page".
// Also add the tick marks as a background.
- (void)prepareScrollView:(UIScrollView*)scrollView {
        
    // Add 10 labels - 0 to 9.
//    for (int i = 0; i < 100; i++) {
////        UILabel* label = [[UILabel alloc] initWithFrame:scrollView.bounds];
////        label.backgroundColor = [UIColor clearColor];
////        label.textColor = [SLNumberPickerView numberColor];
////        label.font = [SLNumberPickerView numberFont];
////        label.textAlignment = UITextAlignmentCenter;
////        
////        label.text = [NSString stringWithFormat:@"%i", i];
////        
////        CGRect frame = label.frame;
////        frame.origin.y = frame.size.height * i;
////        frame.size.width -= 11; // allow for side ticks
////        label.frame = frame;
//////        [scrollView addSubview:label];
////        UIView *bgView = [[UIView alloc] initWithFrame:scrollView.bounds];
////        bgView.backgroundColor = [UIColor clearColor];
////        UIView *keDuView = [[UIView alloc]initWithFrame:CGRectMake(0, 7, 30, 2)];
////        keDuView.backgroundColor = [UIColor greenColor];
////        [bgView addSubview:keDuView];
////        [scrollView addSubview:bgView];
//        scrollView.delegate = self;
//    }
    
    // This scroll view is 10 pages tall, is paged, and does not clip to bounds.
    // This is important, since we want to be able to see the numbers above and below the
    // currently selected one.
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(scrollView.bounds.size.width, scrollView.bounds.size.height*100);
    scrollView.pagingEnabled = YES;
    scrollView.clipsToBounds = NO;
    
    scrollView.showsVerticalScrollIndicator = NO;
    
    // Add a view behind all of the numbers that is extremely tall and uses a tiled background image. 
    UIView* backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    CGRect frame = (CGRect){CGPointMake(0, -scrollView.bounds.size.height*20), CGSizeMake(scrollView.bounds.size.width, scrollView.bounds.size.height*150)};
    backgroundView.frame = frame;
    [scrollView insertSubview:backgroundView atIndex:0];
    
    for (int i = -20; i < 130; i++) {
        //        UILabel* label = [[UILabel alloc] initWithFrame:scrollView.bounds];
        //        label.backgroundColor = [UIColor clearColor];
        //        label.textColor = [SLNumberPickerView numberColor];
        //        label.font = [SLNumberPickerView numberFont];
        //        label.textAlignment = UITextAlignmentCenter;
        //
        //        label.text = [NSString stringWithFormat:@"%i", i];
        //
        //        CGRect frame = label.frame;
        //        frame.origin.y = frame.size.height * i;
        //        frame.size.width -= 11; // allow for side ticks
        //        label.frame = frame;
        //        [scrollView addSubview:label];
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(scrollView.frame.origin.x, 14*i, 50, 14)];
        bgView.backgroundColor = [UIColor clearColor];
        UIView *keDuView = [[UIView alloc]initWithFrame:CGRectMake(0, 6, 20, 2)];
        keDuView.backgroundColor = [UIColor grayColor];
        if (i%10==0){
            keDuView.frame = CGRectMake(0, 6, 40, 2);
        keDuView.backgroundColor = [UIColor orangeColor];
            
            UILabel *keduLabel = [[UILabel alloc]initWithFrame:CGRectMake(45, -3+i*14, 60, 20)];
            keduLabel.font = [UIFont systemFontOfSize:18.0];
            keduLabel.textColor = [UIColor darkGrayColor];
            keduLabel.text = [NSString stringWithFormat:@"%icm",210-i];
            if (i<0||i>100)
                keduLabel.textColor = [UIColor grayColor];
            [scrollView addSubview:keduLabel];
            CGAffineTransform transform =CGAffineTransformMakeRotation(M_PI*3/2);
            [keduLabel setTransform:transform];
        }
        [bgView addSubview:keDuView];
        [scrollView addSubview:bgView];
        scrollView.delegate = self;
    }
   // backgroundView.backgroundColor = [UIColor colorWithPatternImage:[SLNumberPickerView backgroundImage]];
}

// When scroll views finish moving, we can check their value.
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger page = scrollView.contentOffset.y / scrollView.bounds.size.height;
    
    if (scrollView == self.number1)
        _number1Value = page;

    [self.delegate numberPickerViewDidChangeValue:self];
}
-(void)resetNumber1OffSet:(CGPoint)point{
    [_number1 setContentOffset:point animated:YES];
       [_number1 setContentOffset:point];
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 滑動完成時觸發
    // 經由 setContentOffset:animated: 滑動完成才會喔
    // 如果是手動滑的不會觸發
     NSInteger page = scrollView.contentOffset.y / scrollView.bounds.size.height;
    if (scrollView == self.number1)
        _number1Value = page;
    
    [self.delegate numberPickerViewDidChangeValue:self];
    
}
// On awakening, set up the columns if we're not a stand-in.
- (void)awakeFromNib {
    
    if (_isStandIn)
        return;
    
    [self prepareScrollView:_number1];
    [_number1 setContentOffset:CGPointMake(_number1.frame.origin.x, 14*42-7)];
 
}

// Figure out the value based on the current number values.
// If we're a stand-in, forward the request to the "real" number picker.
- (NSInteger)value {
    
    if (_isStandIn) {
        return [_internalPickerView value];
    }
    
    return  210-_number1Value ;
}

// We want to be able to tap and drag any part of a column to move it, but only the 
// center number will handle touches by default. We fix this by overriding
// hitTest:withEvent: to treat any touch in the general area of a column as belonging to
// that column's scroll view.

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    if (_isStandIn) {
        return [_internalPickerView hitTest:point withEvent:event];
    }
    
    // because all of the views are layed out in column fashion, the x coord of the touch corresponds to the view
    CGFloat x = point.x;
    
    if (x >= CGRectGetMinX(self.number1.frame) && x <= CGRectGetMaxX(self.number1.frame))
        return self.number1;
    
    
    
    if (CGRectContainsPoint(self.frame, point))
        return self;
    
    
    return nil;
}

- (void)setDelegate:(id<SLNumberPickerViewDelegate>)delegate {
    if (_isStandIn)
        [_internalPickerView setDelegate:delegate];
    else
        _delegate = delegate;
}

- (id<SLNumberPickerViewDelegate>)delegate {
    if (_isStandIn)
        return [_internalPickerView delegate];
    else
        return _delegate;
}

@end
