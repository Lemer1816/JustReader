//
//  NSObject+MJExtension.m
//  day08_Beauty
//
//  Created by Lemonade on 16/8/3.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import "NSObject+MJExtension.h"

@implementation NSObject (MJExtension)
+ (id)parse:(id)responseObj{
    if ([responseObj isKindOfClass:[NSArray class]]) {
        return [self mj_objectArrayWithKeyValuesArray:responseObj];
    }
    if ([responseObj isKindOfClass:[NSDictionary class]]) {
        return [self mj_objectWithKeyValues:responseObj];
    }
    return responseObj;
}
+ (NSDictionary *)mj_objectClassInArray{
    return [self objectClassInArray];
}
+ (NSDictionary *)objectClassInArray{
    return nil;
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return [self replacedKeyFromPropertyName];
}
+ (NSDictionary *)replacedKeyFromPropertyName{
    return nil;
}

@end
