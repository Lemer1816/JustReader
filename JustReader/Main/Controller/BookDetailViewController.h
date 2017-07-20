//
//  BookDetailViewController.h
//  JustReader
//
//  Created by Lemonade on 2017/7/20.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicViewController.h"

@interface BookDetailViewController : BasicViewController
/** 书籍id */
@property (nonatomic, strong) NSString *bookId;
@end
