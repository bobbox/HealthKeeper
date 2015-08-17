//
//  TPVersionUpdateViewController.h
//  TonguePep
//
//  Created by apple on 15/4/14.
//  Copyright (c) 2015年 山西协康云享科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPVersionUpdateViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *myUpdateVersionLabel;
@property (weak, nonatomic) IBOutlet UILabel *myUpdateDetailLabel;
@property (weak, nonatomic) IBOutlet UITextView *myUpdateDetailTextView;
- (IBAction)update:(id)sender;

- (IBAction)cancel:(id)sender;
- (IBAction)close:(id)sender;
@end
