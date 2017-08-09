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
+ (NSString *)stringWithCount:(NSInteger)count
                       suffix:(StringType)type;

/** 根据日期得到文本日期字符串 */
+ (NSString *)textStringWithDate:(NSDate *)date;

/** 将全角字符转换为半角字符 */
+ (NSString *)stringCovertedByFullWidthString:(NSString *)fullWidthString;

/*  根据文本内容,字体大小,行宽得到文本高度
 *
 *  @param  content 文本内容
 *  @param  font    字体大小
 *  @param  width   行宽
 *
 *  @return height  文本高度
 *
 */
+ (CGFloat)heightWithContent:(NSString *)content
                        font:(UIFont *)font
                       width:(CGFloat)width
      hasFirstLineHeadIndent:(BOOL)hasFirstLineHeadIndent;

/*  根据文本属性字典得到文本高度
 *
 *  @param  content                 文本内容
 *  @param  attributesDictionary    文本属性字典
 *
 *  @return height  文本高度
 *
 */
+ (CGFloat)heightWithContent:(NSString *)content
                       width:(CGFloat)width
        attributesDictionary:(NSDictionary *)attributesDictionary;

/*  根据文本内容,字体大小,行宽得到文本属性字典
 *
 *  @param  content 文本内容
 *  @param  font    字体大小
 *  @param  width   行宽
 *
 *  @return attributesDictionary    文本属性字典
 *
 */
+ (NSDictionary *)attributesDictionaryWithContent:(NSString *)content
                                             font:(UIFont *)font
                                            width:(CGFloat)width
                           hasFirstLineHeadIndent:(BOOL)hasFirstLineHeadIndent;
@end
