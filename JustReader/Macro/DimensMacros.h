//
//  DimensMacros.h
//  Base
//
//  Created by Lemonade on 2017/5/17.
//  Copyright © 2017年 Lemonade. All rights reserved.
//  尺寸宏定义

#ifndef DimensMacros_h
#define DimensMacros_h

// 系统控件默认高度
#define kStatusBarHeight        (20.f)
#define kTopBarHeight           (44.f)
#define kBottomBarHeight        (49.f)
#define kCellDefaultHeight      (44.f)
#define kEnglishKeyboardHeight  (216.f)
#define kChineseKeyboardHeight  (252.f)

//状态栏 ＋ 导航栏 高度
#define STATUS_AND_NAVIGATION_HEIGHT ((kStatusBarHeight) + (kTopBarHeight))

//屏幕 rect
#define SCREEN_RECT ([UIScreen mainScreen].bounds)

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)      //屏幕宽度

#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)    //屏幕高度

// App Frame
#define Application_Frame       [[UIScreen mainScreen] applicationFrame]

// App Frame Height&Width
#define App_Frame_Height        [[UIScreen mainScreen] applicationFrame].size.height
#define App_Frame_Width         [[UIScreen mainScreen] applicationFrame].size.width

// MainScreen Height&Width
#define Main_Screen_Height      [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width       [[UIScreen mainScreen] bounds].size.width

#define CONTENT_HEIGHT ( Main_Screen_Height - kStatusBarHeight - kTopBarHeight)


// View 坐标(x,y)和宽高(width,height)
#define ViewxPos(v)                 (v).frame.origin.x
#define ViewyPos(v)                 (v).frame.origin.y
#define ViewWidth(v)                (v).frame.size.width
#define ViewHeight(v)               (v).frame.size.height

#define MinFrameX(v)                 CGRectGetMinX((v).frame)
#define MinFrameY(v)                 CGRectGetMinY((v).frame)

#define MidFrameX(v)                 CGRectGetMidX((v).frame)
#define MidFrameY(v)                 CGRectGetMidY((v).frame)

#define MaxFrameX(v)                 CGRectGetMaxX((v).frame)
#define MaxFrameY(v)                 CGRectGetMaxY((v).frame)

//屏幕分辨率
#define SCREEN_RESOLUTION (Main_Screen_Width * Main_Screen_Height * ([UIScreen mainScreen].scale))

#endif /* DimensMacros_h */
