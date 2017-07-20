//
//  ChapterListModel.m
//  JustReader
//
//  Created by Lemonade on 2017/7/19.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "ChapterListModel.h"

@implementation ChapterListModel

+ (NSDictionary *)objectClassInArray{
    return @{
             @"chapters": [ChapterListInfoModel class]
             };
}

@end
@implementation ChapterListInfoModel


@end
