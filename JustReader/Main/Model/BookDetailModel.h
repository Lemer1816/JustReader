//
//  BookDetailModel.h
//  JustReader
//
//  Created by Lemonade on 2017/7/19.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"

@interface BookDetailModel : NSObject
/** 书籍id */
@property (nonatomic, strong) NSString *_id;

@property (nonatomic, assign) NSInteger hasCp;
/** 标题 */
@property (nonatomic, strong) NSString *title;
/** 类型 */
@property (nonatomic, strong) NSString *cat;
/** 作者 */
@property (nonatomic, strong) NSString *author;
/** 封面 */
@property (nonatomic, strong) NSString *cover;
/** 描述 */
@property (nonatomic, strong) NSString *longIntro;
/** 最后一章 */
@property (nonatomic, strong) NSString *lastChapter;

@property (nonatomic, strong) NSString *majorCate;

@property (nonatomic, strong) NSString *minorCate;

@property (nonatomic, strong) NSString *creater;

@property (nonatomic, assign) BOOL _le;

@property (nonatomic, assign) BOOL allowMonthly;

@property (nonatomic, assign) BOOL allowVoucher;

@property (nonatomic, assign) BOOL allowBeanVoucher;

@property (nonatomic, assign) NSInteger postCount;

@property (nonatomic, assign) NSInteger latelyFollower;

@property (nonatomic, assign) NSInteger followerCount;

@property (nonatomic, assign) NSInteger wordCount;

@property (nonatomic, assign) NSInteger serializeWordCount;

@property (nonatomic, strong) NSString *retentionRatio;

@property (nonatomic, strong) NSString *updated;

@property (nonatomic, assign) BOOL isSerial;

@property (nonatomic, assign) NSInteger chaptersCount;

@property (nonatomic, assign) BOOL donate;

@property (nonatomic, strong) NSString *copyright;

@property (nonatomic, strong) NSString *contentType;

@property (nonatomic, assign) NSInteger sizetype;

@property (nonatomic, assign) NSInteger currency;

@property (nonatomic, strong) NSString *superscript;

@property (nonatomic, strong) NSString *discount;

@property (nonatomic, strong) NSArray *tags;

@property (nonatomic, strong) NSArray *gender;

@end
