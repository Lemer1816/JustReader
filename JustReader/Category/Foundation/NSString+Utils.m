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
+ (NSString *)textStringWithDate:(NSDate *)date{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:date];
    if (timeInterval < 60) { //1分钟内
        return @"刚刚";
    } else if (timeInterval < 3600) {  //1小时内
        return [NSString stringWithFormat:@"%ld分钟前", (NSInteger)(timeInterval/60)];
    } else if (timeInterval < 3600*24) {  //1天内
        return [NSString stringWithFormat:@"%ld小时前", (NSInteger)(timeInterval/3600)];
    }else if (timeInterval < 3600*48) {  //2天内
        return @"昨天";
    } else {  //2天以上
        NSInteger year = [[NSCalendar currentCalendar] component:NSCalendarUnitYear fromDate:date];
        NSInteger month = [[NSCalendar currentCalendar] component:NSCalendarUnitMonth fromDate:date];
        NSInteger day = [[NSCalendar currentCalendar] component:NSCalendarUnitDay fromDate:date];
        return [NSString stringWithFormat:@"%ld.%ld.%ld", year, month, day];
    }
}

+ (NSString *)stringCovertedByFullWidthString:(NSString *)fullWidthString{
    NSMutableString *convertedString = [fullWidthString mutableCopy];
    CFStringTransform((CFMutableStringRef)convertedString, NULL, kCFStringTransformFullwidthHalfwidth, false);
    return [convertedString copy];
}
+ (CGFloat)heightWithContent:(NSString *)content font:(UIFont *)font width:(CGFloat)width hasFirstLineHeadIndent:(BOOL)hasFirstLineHeadIndent{
    
    NSDictionary *dic = [NSString attributesDictionaryWithContent:content font:font width:width hasFirstLineHeadIndent:hasFirstLineHeadIndent];
    CGSize size = [content boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}
+ (CGFloat)heightWithContent:(NSString *)content width:(CGFloat)width  attributesDictionary:(NSDictionary *)attributesDictionary{
    CGSize size = [content boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributesDictionary context:nil].size;
    return size.height;
}
+ (NSDictionary *)attributesDictionaryWithContent:(NSString *)content font:(UIFont *)font width:(CGFloat)width hasFirstLineHeadIndent:(BOOL)hasFirstLineHeadIndent{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //折行方式
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    //对齐方式--左右对齐
    paragraphStyle.alignment = NSTextAlignmentJustified;
    //行间距
    paragraphStyle.lineSpacing = font.lineHeight-12;
    //判断每行最后一个单词是否被截断,数值介于0.0~1.0,越靠近1.0被截断的几率越大
    paragraphStyle.hyphenationFactor = 0.3;
    //首行缩进
    paragraphStyle.firstLineHeadIndent = hasFirstLineHeadIndent ? font.lineHeight*2 : 0.0;
    //整段缩进(左)
    paragraphStyle.headIndent = 0.0;
    //整段缩进(正值--文本所要显示的宽度,负值--右侧缩进)
    paragraphStyle.tailIndent = 0.0;
    //段落前间距(暂时发现\n存在时生效)
    paragraphStyle.paragraphSpacingBefore = 0;
    //段落后间距(暂时发现\n存在时生效)
    paragraphStyle.paragraphSpacing = font.lineHeight-4;
//    //行间距(是默认行间距的多少倍)
//    paragraphStyle.lineHeightMultiple = 0.5;

    NSDictionary *dic = @{NSFontAttributeName: font, NSParagraphStyleAttributeName: paragraphStyle,  NSKernAttributeName: @1.5f, NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleNone]};
    return dic;
}
@end
