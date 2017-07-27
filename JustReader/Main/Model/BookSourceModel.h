//
//  BookSourceModel.h
//  JustReader
//
//  Created by Lemonade on 2017/7/27.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"

@interface BookSourceModel : NSObject
/** 书源id */
@property (nonatomic, strong) NSString *_id;
/** 书源拼音 */
@property (nonatomic, strong) NSString *source;
/** 最新章节 */
@property (nonatomic, strong) NSString *lastChapter;

@property (nonatomic, assign) BOOL isCharge;
/** 更新时间 */
@property (nonatomic, strong) NSString *updated;

@property (nonatomic, assign) BOOL starting;
/** 最新章链接 */
@property (nonatomic, strong) NSString *link;
/** 章节总数 */
@property (nonatomic, assign) NSInteger chaptersCount;
/** 书源网站 */
@property (nonatomic, strong) NSString *host;
/** 书源名称 */
@property (nonatomic, strong) NSString *name;

@end
