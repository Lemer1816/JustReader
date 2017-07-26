//
//  BookDetailView.h
//  JustReader
//
//  Created by Lemonade on 2017/7/24.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookDetailModel.h"

typedef void(^StarReadingBlock)();

typedef void(^AddMyBookBlock)();

@interface BookDetailView : UIView

@property (nonatomic, assign) CGFloat totalHeight;

- (instancetype)initWithModel:(BookDetailModel *)model;
/** 开始阅读block */
@property (nonatomic, copy) StarReadingBlock starReadingBlock;
/** 加入书单block */
@property (nonatomic, copy) AddMyBookBlock addMyBookBlock;
@end
