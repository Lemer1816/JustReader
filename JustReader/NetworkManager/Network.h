//
//  Network.h
//  JustReader
//
//  Created by Lemonade on 2017/7/19.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+AFNetworking.h"



@interface Network : NSObject

singleton_interface(Network)

/** 根据关键词获取书籍列表 */
- (id)getBookListWithKeywords:(NSString *)keywords
                  startNumber:(NSInteger)start
                  limitNumber:(NSInteger)limit
                 successBlock:(SuccessBlock)successBlock
                 failureBlock:(FailureBlock)failureBlock;
/** 根据书籍id获取书籍详情 */
- (id)getBookDetailWithBookId:(NSString *)bookId
                 successBlock:(SuccessBlock)successBlock
                 failureBlock:(FailureBlock)failureBlock;
/** 根据关键词自动补全书籍名称 */
- (id)getAutoCompleteWithKeywords:(NSString *)keywords
                     successBlock:(SuccessBlock)successBlock
                     failureBlock:(FailureBlock)failureBlock;
/** 根据书籍id获取章节列表 */
- (id)getChapterListWithBookId:(NSString *)bookId
                  successBlock:(SuccessBlock)successBlock
                  failureBlock:(FailureBlock)failureBlock;
/** 根据书籍link获取章节内容 */
- (id)getChapterDetailWithChapterLink:(NSString *)chapterLink
                         successBlock:(SuccessBlock)successBlock
                         failureBlock:(FailureBlock)failureBlock;
@end
