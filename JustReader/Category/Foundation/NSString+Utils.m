//
//  NSString+Utils.m
//  JustReader
//
//  Created by Lemonade on 2017/7/24.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "NSString+Utils.h"

@implementation NSString (Utils)
+ (NSString *)stringWithCount:(NSInteger)count suffix:(StringType)type{
    if (type == StringTypeWord) {
        if (count < 10000) {
            return [NSString stringWithFormat:@"%ld字", count];
        } else {
            CGFloat newCount = count*1.0/10000;
            return [NSString stringWithFormat:@"%.1lf万字", newCount];
        }
    } else if (type == StringTypeByte) {
        return @"";
    } else {
        return @"";
    }
}
@end
