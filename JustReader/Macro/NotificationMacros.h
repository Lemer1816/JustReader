//
//  NotificationMacros.h
//  Base
//
//  Created by Lemonade on 2017/5/17.
//  Copyright © 2017年 Lemonade. All rights reserved.
//  系统通知宏定义

#ifndef NotificationMacros_h
#define NotificationMacros_h

#define ADD_OBSERVER(TITLE, SELECTOR) [[NSNotificationCenter defaultCenter] addObserver:self selector:SELECTOR name:TITLE object:nil]//添加通知

#define REMOVE_OBSERVER(id) [[NSNotificationCenter defaultCenter] removeObserver:id]//销毁通知

#define POST_NOTIFICATION(TITLE,OBJ,PARAM) [[NSNotificationCenter defaultCenter] postNotificationName:TITLE object:OBJ userInfo:PARAM]//发送通知

#define kNotficationDownloadProgressChanged @"kNotficationDownloadProgressChanged"//下载进度变化
#define kNotificationPauseDownload          @"kNotificationPauseDownload"         //暂停下载
#define kNotificationStartDownload          @"kNotificationStartDownload"         //开始下载

#define kNotificationDownloadSuccess        @"kNotificationDownloadSuccess"       //下载成功
#define kNotificationDownloadFailed         @"kNotificationDownloadFailed"        //下载失败
#define kNotificationDownloadNewMagazine    @"kNotificationDownloadNewMagazine"
#define kNotificationDownloadChangeState    @"kNotificationDownloadChangeState" // 下载状态发生变化
#define kNotificationDownloadDelete    @"kNotificationDownloadDelete" // 删除下载

#define kNotificationLoginSucceed      @"kNotificationLoginSucceed" // 用户登录成功

#endif /* NotificationMacros_h */
