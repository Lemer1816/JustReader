//
//  APIStringMacros.h
//  Base
//
//  Created by Lemonade on 2017/5/17.
//  Copyright © 2017年 Lemonade. All rights reserved.
//  接口路径宏定义

#ifndef APIStringMacros_h
#define APIStringMacros_h

//基本路径
#define API_BASE_URL_STRING     @"http://api.zhuishushenqi.com"
//章节路径
#define API_CHAPTER_URL_STRING  @"http://chapter2.zhuishushenqi.com"
//接口路径全拼
#define PATH(_path) [NSString stringWithFormat:@"%@%@",API_BASE_URL_STRING,_path]
//书籍搜索
#define GET_BOOK_LIST                PATH(@"/book/fuzzy-search")
//书籍详情
#define GET_BOOK_DETAIL              PATH(@"/book")
//自动补全
#define GET_AUTO_COMPLETE            PATH(@"/book/auto-complete")
//书源信息
#define GET_BOOK_SOURCE_LIST         PATH(@"/toc")
//章节列表
#define GET_CHAPTER_LIST             PATH(@"/toc")
//章节内容
#define GET_CHAPTER_DETAIL           [NSString stringWithFormat:@"%@/chapter",API_CHAPTER_URL_STRING]

#endif /* APIStringMacros_h */
