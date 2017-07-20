//
//  PathMacros.h
//  Base
//
//  Created by Lemonade on 2017/5/17.
//  Copyright © 2017年 Lemonade. All rights reserved.
//  沙盒路径宏定义

#ifndef PathMacros_h
#define PathMacros_h

#define kPathTemp                   NSTemporaryDirectory()
#define kPathDocument               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]

#define kPathCache                  [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
//  用户信息plist
#define kPathUserData [kPathDocument stringByAppendingPathComponent:@"UserData.plist"]

// 缓存主目录
#define kFileCachesDirectory [kPathCache stringByAppendingPathComponent:@"/file/Download/"]

// plist文件存储目录
#define kPathMagazine [kPathCache stringByAppendingPathComponent:@"/file/"]

// 小视频存储位置
#define kPathVideo [kPathCache stringByAppendingPathComponent:@"/file/video/"]

// 保存文件名
//#define SaveFileName(url)  url.md5String
#define kSaveFileName(url) [[url componentsSeparatedByString:@"/"] lastObject]

// 文件的存放路径（caches）
#define kSaveFileFullpath(url) [kFileCachesDirectory stringByAppendingPathComponent:kSaveFileName(url)]

// 文件的已下载长度
#define kDownloadLength(url) [[[NSFileManager defaultManager] attributesOfItemAtPath:kSaveFileFullpath(url) error:nil][NSFileSize] integerValue]

// 存储文件的全路径（caches）
#define kTotalLengthFullpath [kPathMagazine stringByAppendingPathComponent:@"DownloadedTotalLength.plist"]


#define kPathSearch                 [kPathDocument stringByAppendingPathComponent:@"Search.plist"]

#define kPathDownloadedMgzs         [kPathMagazine stringByAppendingPathComponent:@"DownloadedMgz.plist"]

#define kPathDownloadURLs           [kPathMagazine stringByAppendingPathComponent:@"DownloadURLs.plist"]

#define kPathOperation              [kPathMagazine stringByAppendingPathComponent:@"Operation.plist"]

#define kPathSplashScreen           [kPathCache stringByAppendingPathComponent:@"splashScreen"]


#endif /* PathMacros_h */
