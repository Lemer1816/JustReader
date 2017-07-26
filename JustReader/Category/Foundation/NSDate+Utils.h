//
//  NSDate+Utils.h
//  JustReader
//
//  Created by Lemonade on 2017/7/25.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Utils)
/** 时间转化, string -> date */
+ (NSDate *)dateWithString:(NSString *)string dateFormat:(NSString *)dateFormat;
@end
