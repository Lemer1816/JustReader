//
//  NSObject+AFNetworking.h
//  day08_Beauty
//
//  Created by Lemonade on 16/8/3.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import <Foundation/Foundation.h>

//请求方式
typedef NS_ENUM(NSUInteger, RequestMethod) {
    RequestMethodGet,
    RequestMethodPost,
};
/**
 *  定义请求成功的block
 */
typedef void(^SuccessBlock)(id responseBody);
/**
 *  定义请求失败的block
 */
typedef void(^FailureBlock)(NSError *error);

@interface NSObject (AFNetworking)

+ (id)requestWithPath:(NSString *)path
           parameters:(id)parameters
        requestMethod:(RequestMethod)requestMethod
             progress:(void(^)(NSProgress *downloadProgress))downloadProgress
         successBlock:(SuccessBlock)successBlock
         failureBlock:(FailureBlock)failureBlock;


@end
