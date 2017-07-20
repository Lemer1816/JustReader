//
//  NSObject+MJExtension.h
//  day08_Beauty
//
//  Created by Lemonade on 16/8/3.
//  Copyright © 2016年 Lemonade. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>

@interface NSObject (MJExtension)
+ (id)parse:(id)responseObj;

+ (NSDictionary *)objectClassInArray;
+ (NSDictionary *)replacedKeyFromPropertyName;
@end
