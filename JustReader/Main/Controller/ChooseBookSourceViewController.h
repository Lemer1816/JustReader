//
//  ChooseBookSourceViewController.h
//  JustReader
//
//  Created by Lemonade on 2017/8/23.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookSourceModel.h"

typedef void(^ChooseBookSourceBlock)(BookSourceModel *model);

@interface ChooseBookSourceViewController : UIViewController
/** 书源列表 */
@property (nonatomic, readwrite, strong) NSArray<BookSourceModel *> *bookSourceList;
/** 选择书源block */
- (void)chooseSourceBlock:(ChooseBookSourceBlock)chooseBookSourceBlock;

@end
