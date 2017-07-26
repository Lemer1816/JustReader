//
//  BookDetailView.h
//  JustReader
//
//  Created by Lemonade on 2017/7/24.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookDetailModel.h"

@interface BookDetailView : UIView

@property (nonatomic, assign) CGFloat totalHeight;

- (instancetype)initWithModel:(BookDetailModel *)model;

@end
