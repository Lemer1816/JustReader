//
//  NSString+Utils.h
//  JustReader
//
//  Created by Lemonade on 2017/7/24.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, StringType) {
    StringTypeWord,
    StringTypeByte,
};

@interface NSString (Utils)
/** 根据数字和转换类型得到字符串 */
+ (NSString *)stringWithCount:(NSInteger)count suffix:(StringType)type;
@end
