//
//  ChapterListModel.h
//  JustReader
//
//  Created by Lemonade on 2017/7/19.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"

@class ChapterListInfoModel;

@interface ChapterListModel : NSObject

@property (nonatomic, strong) NSString *host;

@property (nonatomic, strong) NSString *_id;

@property (nonatomic, strong) NSString *updated;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSArray<ChapterListInfoModel *> *chapters;
@property (nonatomic, strong) NSString *link;

@end

@interface ChapterListInfoModel : NSObject

@property (nonatomic, assign) NSInteger totalpage;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, assign) NSInteger partsize;

@property (nonatomic, strong) NSString *link;

@property (nonatomic, assign) BOOL isVip;

@property (nonatomic, assign) NSInteger currency;

@property (nonatomic, assign) BOOL unreadble;

@end
