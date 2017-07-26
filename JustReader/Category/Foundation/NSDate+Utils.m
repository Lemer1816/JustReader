//
//  NSDate+Utils.m
//  JustReader
//
//  Created by Lemonade on 2017/7/25.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "NSDate+Utils.h"

@implementation NSDate (Utils)
+ (NSDate *)dateWithString:(NSString *)string dateFormat:(NSString *)dateFormat{
    if ([string containsString:@"T"]) {
        string = [string stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    }
    if ([string containsString:@"Z"]) {
        string = [string stringByReplacingOccurrencesOfString:@"Z" withString:@""];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = dateFormat;
    return [dateFormatter dateFromString:string];
}
@end
