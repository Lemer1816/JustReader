//
//  ChapterDetailViewController.h
//  JustReader
//
//  Created by Lemonade on 2017/7/24.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "BasicViewController.h"
#import "ChapterListModel.h"

@interface ChapterDetailViewController : BasicViewController
/** 章节数组(顺序) */
@property (nonatomic, readwrite, strong) NSArray<ChapterListInfoModel *> *chapterList;
/** 所选章节model */
@property (nonatomic, readwrite, strong) ChapterListInfoModel *selectedChapterInfoModel;
@end
