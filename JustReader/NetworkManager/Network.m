//
//  Network.m
//  JustReader
//
//  Created by Lemonade on 2017/7/19.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "Network.h"

@implementation Network

singleton_implementation(Network)

#pragma mark 根据关键词获取书籍列表
- (id)getBookListWithKeywords:(NSString *)keywords startNumber:(NSInteger)start limitNumber:(NSInteger)limit successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    //传参
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:keywords forKey:@"query"];
    [params setValue:@(start) forKey:@"start"];
    [params setValue:@(limit) forKey:@"limit"];
    //请求
    return [Network requestWithPath:GET_BOOK_LIST parameters:params requestMethod:RequestMethodGet progress:nil successBlock:^(id responseBody) {
        successBlock(responseBody);
    } failureBlock:^(NSError *error) {
        failureBlock(error);
    }];
}
#pragma mark 根据书籍id获取书籍详情
- (id)getBookDetailWithBookId:(NSString *)bookId successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    //拼接接口
    NSString *path = [GET_BOOK_DETAIL stringByAppendingPathComponent:bookId];
    //请求
    return [Network requestWithPath:path parameters:nil requestMethod:RequestMethodGet progress:nil successBlock:^(id responseBody) {
        successBlock(responseBody);
    } failureBlock:^(NSError *error) {
        failureBlock(error);
    }];
}
#pragma mark 根据关键词自动补全书籍名称
- (id)getAutoCompleteWithKeywords:(NSString *)keywords successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    //传参
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:keywords forKey:@"query"];
    //请求
    return [Network requestWithPath:GET_AUTO_COMPLETE parameters:params requestMethod:RequestMethodGet progress:nil successBlock:^(id responseBody) {
        successBlock(responseBody);
    } failureBlock:^(NSError *error) {
        failureBlock(error);
    }];
}
#pragma mark 根据书籍id获取书源信息
- (id)getBookSourceListWithBookId:(NSString *)bookId successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    //传参
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"summary" forKey:@"view"];
    [params setValue:bookId forKey:@"book"];
    //请求
    return [Network requestWithPath:GET_BOOK_SOURCE_LIST parameters:params requestMethod:RequestMethodGet progress:nil successBlock:^(id responseBody) {
        successBlock(responseBody);
    } failureBlock:^(NSError *error) {
        failureBlock(error);
    }];
}
#pragma mark 根据书源id获取章节列表
- (id)getChapterListWithBookSourceId:(NSString *)bookSourceId successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    //拼接接口
    NSString *path = [GET_CHAPTER_LIST stringByAppendingPathComponent:bookSourceId];
    //传参
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"chapters" forKey:@"view"];
    //请求
    return [Network requestWithPath:path parameters:params requestMethod:RequestMethodGet progress:nil successBlock:^(id responseBody) {
        successBlock(responseBody);
    } failureBlock:^(NSError *error) {
        failureBlock(error);
    }];
}
#pragma mark 根据书籍link获取章节内容
- (id)getChapterDetailWithChapterLink:(NSString *)chapterLink successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    //url转码
    NSCharacterSet *allowCharacters = [[NSCharacterSet characterSetWithCharactersInString:chapterLink] invertedSet];
    NSString *lastLink = [chapterLink stringByAddingPercentEncodingWithAllowedCharacters:allowCharacters];
    //拼接接口
    NSString *path = [GET_CHAPTER_DETAIL stringByAppendingPathComponent:lastLink];
    //传参
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"2124b73d7e2e1945" forKey:@"k"];
    [params setValue:@"1468223717" forKey:@"t"];
    //请求
    return [Network requestWithPath:path parameters:params requestMethod:RequestMethodGet progress:nil successBlock:^(id responseBody) {
        successBlock(responseBody);
    } failureBlock:^(NSError *error) {
        failureBlock(error);
    }];
}
@end
