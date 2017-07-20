//
//  BookListModel.h
//  JustReader
//
//  Created by Lemonade on 2017/7/19.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"

@interface BookListModel : NSObject
/** 书籍id */
@property (nonatomic, strong) NSString *_id;

@property (nonatomic, assign) NSInteger hasCp;
/** 标题 */
@property (nonatomic, strong) NSString *title;
/** 类型 */
@property (nonatomic, strong) NSString *cat;
/** 作者 */
@property (nonatomic, strong) NSString *author;
/** 定位 */
@property (nonatomic, strong) NSString *site;
/** 封面 */
@property (nonatomic, strong) NSString *cover;
/** 描述 */
@property (nonatomic, strong) NSString *shortIntro;
/** 最后一章 */
@property (nonatomic, strong) NSString *lastChapter;

@property (nonatomic, strong) NSString *retentionRatio;
/** 支持者数量 */
@property (nonatomic, assign) NSInteger latelyFollower;
/** 总字数 */
@property (nonatomic, assign) NSInteger wordCount;
@end
