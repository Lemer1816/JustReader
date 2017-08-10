//
//  ColorMacros.h
//  Base
//
//  Created by Lemonade on 2017/5/17.
//  Copyright © 2017年 Lemonade. All rights reserved.
//  色值宏定义

#ifndef ColorMacros_h
#define ColorMacros_h
//普通RGB颜色
#define RGBA(r,g,b,a)                   [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
//普通RGB颜色,默认不透明
#define RGB(r,g,b)                      RGBA(r,g,b,1.0f)
//使用十六进制颜色
#define UIColorFromRGB(rgbValue)        [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define DEFAULT_NAVBAR_COLOR            [UIColor colorWithRed:20.0/255.0 green:20.0/255.0 blue:20.0/255.0 alpha:0.9]
#define DEFAULT_NAVBARTITLE_COLOR       UIColorFromRGB(0x494949)
#define DEFAULT_BACKGROUND_COLOR        UIColorFromRGB(0xeaedf2)
#define DEFAULT_SEARCHBAR_COLOR         [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0                                                                          alpha:1.0]
#define DEFAULT_GREEN_COLOR             [UIColor colorWithRed:31.0/255 green:185.0/255  blue:34.0/255                                                                                 alpha:1.0f]
#define DEFAULT_TEXT_GRAY_COLOR         [UIColor grayColor]
#define DEFAULT_LINE_GRAY_COLOR         [UIColor colorWithRed:188.0/255 green:188.0/255  blue:188.0/255                                                                               alpha:0.6f]

// 灰色分割线颜色
#define SEPARATORLINE_COLOR             UIColorFromRGB(0xdcdcdc)
//导航背景色(配色方案)
#define NAVIGATION_BACKGROUNDCOLOR      UIColorFromRGB(0xec304c)

/*----------   文字颜色(配色方案)  ----------*/

//深黑色
#define TEXT_DARK_COLOR                 UIColorFromRGB(0x11212e)
//暗黑色
#define TEXT_MID_COLOR                  UIColorFromRGB(0x666666)
//浅黑色
#define TEXT_LIGHT_COLOR                UIColorFromRGB(0x999999)
//灰白色
#define TEXT_WHITE_COLOR                UIColorFromRGB(0xf2f2f2)
//普通绿
#define TEXT_GREEN_COLOR                RGBA(140, 196, 142, 1.0)
//深红色
#define DARK_RED_COLOR                  UIColorFromRGB(0xcb1c36)
//鲜红色
#define FRESH_RED_COLOR                 UIColorFromRGB(0xec304c)
//橘红色
#define ORANGE_RED_COLOR                UIColorFromRGB(0xfe7040)

/*----------   文字颜色(配色方案)  ----------*/



#endif /* ColorMacros_h */
