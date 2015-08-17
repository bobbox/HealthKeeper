//
//  TPHttpRequest.h
//  HealthKeeper
//
//  Created by wangzhipeng on 15/7/18.
//  Copyright (c) 2015年 山西协康云享科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "appDelegate.h"
@protocol getDataDelegate

-(void)getData:(NSData*)data;

@end

@interface TPHttpRequest : NSObject
@property (nonatomic,strong) NSData *myRequestData;
@property id<getDataDelegate> delegate;

+ ( AppDelegate*)appDelegate;
//监测网络
+(BOOL)netReached;
+(void)showMessage:(NSString *)message;

+(NSData*)getHttpRequestWithUrl:(NSString*)url andRequestData:(NSData*)data;
@end

