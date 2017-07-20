//
//  AutoCompleteModel.h
//  JustReader
//
//  Created by Lemonade on 2017/7/19.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+MJExtension.h"

@interface AutoCompleteModel : NSObject

@property (nonatomic, strong) NSArray *keywords;

@property (nonatomic, assign) BOOL ok;
@end
