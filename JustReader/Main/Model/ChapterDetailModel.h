//
//  ChapterDetailModel.h
//  JustReader
//
//  Created by Lemonade on 2017/7/19.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"

@interface ChapterDetailModel : NSObject
/** 标题 */
@property (nonatomic, strong) NSString *title;
/** 内容 */
@property (nonatomic, strong) NSString *body;

@end
