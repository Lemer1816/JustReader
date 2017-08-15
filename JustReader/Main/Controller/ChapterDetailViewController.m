//
//  ChapterDetailViewController.m
//  JustReader
//
//  Created by Lemonade on 2017/7/24.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "ChapterDetailViewController.h"
#import "PageContentViewController.h"

#import "ChapterDetailModel.h"

#import "NSString+Utils.h"
#import "UIView+Frame.h"
#import "UIControl+Event.h"

static NSInteger const kPageViewTag = 1000;
static NSInteger const kTopInset = 55;
static NSInteger const kLeftInset = 15;
static NSInteger const kBottomInset = 45;
static NSInteger const kRightInset = 15;

#define kChapterBodyWidth (SCREEN_WIDTH - kLeftInset - kRightInset)
#define kChapterBodyHeight (SCREEN_HEIGHT - kTopInset - kBottomInset)

@interface ChapterDetailViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

//Data

/** 当前章节model */
@property (nonatomic, readwrite, strong) ChapterDetailModel *currentChapterDetailModel;
/** 当前章节内容数组 */
@property (nonatomic, readwrite, strong) NSMutableArray *currentChapterContentList;
/** 当前章节内容总高 */
@property (nonatomic, readwrite, assign) CGFloat currentChapterContentHeight;

/** 前一章节model */
@property (nonatomic, readwrite, strong) ChapterDetailModel *preChapterDetailModel;
/** 前一章节内容数组 */
@property (nonatomic, readwrite, strong) NSMutableArray *preChapterContentList;
/** 前一章节内容总高 */
@property (nonatomic, readwrite, assign) CGFloat preChapterContentHeight;

/** 后一章节model */
@property (nonatomic, readwrite, strong) ChapterDetailModel *nextChapterDetailModel;
/** 后一章节内容数组 */
@property (nonatomic, readwrite, strong) NSMutableArray *nextChapterContentList;
/** 后一章节内容总高 */
@property (nonatomic, readwrite, assign) CGFloat nextChapterContentHeight;
/** 是否第一次加载 */
@property (nonatomic, readwrite, assign, getter=isFirstLoad) BOOL firstLoad;
/** 是否首行缩进 */
@property (nonatomic, readwrite, assign, getter=isHasFirstLineHeadIndent) BOOL hasFirstLineHeadIndent;
/** 章节字体大小 */
@property (nonatomic, readwrite, assign) NSInteger fontSize;

//UI

/** 分页/滚动视图切换按钮 */
@property (nonatomic, strong) UIButton *selectBtn;
/** 章节标题 */
@property (nonatomic, readwrite, strong) UILabel *chapterTitleLb;
/** 章节序号 */
@property (nonatomic, readwrite, strong) UILabel *chapterIndexLb;
/** 滚动视图 */
@property (nonatomic, readwrite, strong) UIScrollView *chapterScrollView;
/** 章节内容标签 */
@property (nonatomic, readwrite, strong) UILabel *chapterBodyLb;
/** 翻页控制器 */
@property (nonatomic, readwrite, strong) UIPageViewController *pageVC;
/** 当前视图数组 */
@property (nonatomic, readwrite, strong) NSMutableArray<UIViewController *> *currentChapterContentVCList;
/** 前一视图数组 */
@property (nonatomic, readwrite, strong) NSMutableArray<UIViewController *> *preChapterContentVCList;
/** 后一视图数组 */
@property (nonatomic, readwrite, strong) NSMutableArray<UIViewController *> *nextChapterContentVCList;
@end

@implementation ChapterDetailViewController

#pragma mark - 生命周期 LifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackButton];
    self.view.backgroundColor = TEXT_WHITE_COLOR;
    self.navigationItem.title = @"章节详情";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.selectBtn];
    self.fontSize = 17;
    [self getCurrentChapterDetail];
    

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}
#pragma mark - 方法 Methods
//得到当前章的数据
- (void)getCurrentChapterDetail{
    [[Network sharedNetwork] getChapterDetailWithChapterLink:self.selectedChapterInfoModel.link successBlock:^(id responseBody) {
        if ([[responseBody objectForKey:@"ok"] boolValue]) {
            self.currentChapterDetailModel = [ChapterDetailModel parse:[responseBody objectForKey:@"chapter"]];
            
            if (self.selectedChapterIndex == 0) {   //如果是第一章
                [self getNextChapterDetail];
            } else if (self.selectedChapterIndex == self.chapterList.count-1) {     //如果是最后一章
                [self getPreChapterDetail];
            } else {
                [self getPreChapterDetail];
                [self getNextChapterDetail];
            }
            [self pageVC];
        }
    } failureBlock:^(NSError *error) {
        ;
    }];
}
//得到前一章的数据
- (void)getPreChapterDetail{
    NSString *link = [self.chapterList objectAtIndex:self.selectedChapterIndex-1].link;
    [[Network sharedNetwork] getChapterDetailWithChapterLink:link successBlock:^(id responseBody) {
        if ([[responseBody objectForKey:@"ok"] boolValue]) {
            self.preChapterDetailModel = [ChapterDetailModel parse:[responseBody objectForKey:@"chapter"]];
            [self getPreChapterContentData];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self getPreChapterContentVCData];
            }];
        }
    } failureBlock:^(NSError *error) {
        ;
    }];
}
//得到后一章的数据
- (void)getNextChapterDetail{
    NSString *link = [self.chapterList objectAtIndex:self.selectedChapterIndex+1].link;
    [[Network sharedNetwork] getChapterDetailWithChapterLink:link successBlock:^(id responseBody) {
        [[NSOperationQueue new] addOperationWithBlock:^{
        if ([[responseBody objectForKey:@"ok"] boolValue]) {
                self.nextChapterDetailModel = [ChapterDetailModel parse:[responseBody objectForKey:@"chapter"]];
                [self getNextChapterContentData];
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [self getNextChapterContentVCData];
                }];
            }
        }];
    } failureBlock:^(NSError *error) {
        ;
    }];
}
//得到当前章节分页数据
- (void)getCurrentChapterContentData{
    [self.currentChapterContentList removeAllObjects];
    //全角转半角
    self.currentChapterDetailModel.body = [NSString stringCovertedByFullWidthString:self.currentChapterDetailModel.body];
    self.currentChapterContentHeight = ceil([NSString heightWithContent:self.currentChapterDetailModel.body font:[UIFont systemFontOfSize:self.fontSize] width:kChapterBodyWidth hasFirstLineHeadIndent:self.hasFirstLineHeadIndent]);
    //所要显示的文本
    NSMutableString *chapterContent = [NSMutableString stringWithString:self.currentChapterDetailModel.body];
    //根据文本内容和总高得到分页文本数组
    self.currentChapterContentList = [self mutableArrayCreatedByContent:chapterContent height:self.currentChapterContentHeight];
}
//得到前一章节分页数据
- (void)getPreChapterContentData{
    [self.preChapterContentList removeAllObjects];
    //全角转半角
    self.preChapterDetailModel.body = [NSString stringCovertedByFullWidthString:self.preChapterDetailModel.body];
    self.preChapterContentHeight = ceil([NSString heightWithContent:self.preChapterDetailModel.body font:[UIFont systemFontOfSize:self.fontSize] width:kChapterBodyWidth hasFirstLineHeadIndent:self.hasFirstLineHeadIndent]);
    //所要显示的文本
    NSMutableString *chapterContent = [NSMutableString stringWithString:self.preChapterDetailModel.body];
    //根据文本内容和总高得到分页文本数组
    self.preChapterContentList = [self mutableArrayCreatedByContent:chapterContent height:self.preChapterContentHeight];
}
//得到后一章节分页数据
- (void)getNextChapterContentData{
    [self.nextChapterContentList removeAllObjects];
    //全角转半角
    self.nextChapterDetailModel.body = [NSString stringCovertedByFullWidthString:self.nextChapterDetailModel.body];
    self.nextChapterContentHeight = ceil([NSString heightWithContent:self.nextChapterDetailModel.body font:[UIFont systemFontOfSize:self.fontSize] width:kChapterBodyWidth hasFirstLineHeadIndent:self.hasFirstLineHeadIndent]);
    //所要显示的文本
    NSMutableString *chapterContent = [NSMutableString stringWithString:self.nextChapterDetailModel.body];
    //根据文本内容和总高得到分页文本数组
    self.nextChapterContentList = [self mutableArrayCreatedByContent:chapterContent height:self.nextChapterContentHeight];
}

//得到当前章节分页数据(UI)
- (void)getCurrentChapterContentVCData{
    [self.currentChapterContentVCList removeAllObjects];
    for (NSString *contentPart in self.currentChapterContentList) {
        PageContentViewController *pageContentVC = [[PageContentViewController alloc] init];
        pageContentVC.contentPartLb.font = [UIFont systemFontOfSize:self.fontSize];
        pageContentVC.contentPartLb.attributedText = [[NSAttributedString alloc] initWithString:contentPart attributes:[NSString attributesDictionaryWithContent:contentPart font:pageContentVC.contentPartLb.font width:kChapterBodyWidth hasFirstLineHeadIndent:self.hasFirstLineHeadIndent]];
        pageContentVC.clickScreenBlock = ^{
            [self.navigationController popViewControllerAnimated:YES];
        };
        [self.currentChapterContentVCList addObject:pageContentVC];
    }
}
//得到前一章节分页数据(UI)
- (void)getPreChapterContentVCData{
    [self.preChapterContentVCList removeAllObjects];
    for (NSString *contentPart in self.preChapterContentList) {
        PageContentViewController *pageContentVC = [[PageContentViewController alloc] init];
        pageContentVC.contentPartLb.font = [UIFont systemFontOfSize:self.fontSize];
        pageContentVC.contentPartLb.attributedText = [[NSAttributedString alloc] initWithString:contentPart attributes:[NSString attributesDictionaryWithContent:contentPart font:pageContentVC.contentPartLb.font width:kChapterBodyWidth hasFirstLineHeadIndent:self.hasFirstLineHeadIndent]];
        pageContentVC.clickScreenBlock = ^{
            [self.navigationController popViewControllerAnimated:YES];
        };
        [self.preChapterContentVCList addObject:pageContentVC];
    }
}
//得到后一章节分页数据(UI)
- (void)getNextChapterContentVCData{
    [self.nextChapterContentVCList removeAllObjects];
    for (NSString *contentPart in self.nextChapterContentList) {
        PageContentViewController *pageContentVC = [[PageContentViewController alloc] init];
        pageContentVC.contentPartLb.font = [UIFont systemFontOfSize:self.fontSize];
        pageContentVC.contentPartLb.attributedText = [[NSAttributedString alloc] initWithString:contentPart attributes:[NSString attributesDictionaryWithContent:contentPart font:pageContentVC.contentPartLb.font width:kChapterBodyWidth hasFirstLineHeadIndent:self.hasFirstLineHeadIndent]];
        pageContentVC.clickScreenBlock = ^{
            [self.navigationController popViewControllerAnimated:YES];
        };
        [self.nextChapterContentVCList addObject:pageContentVC];
    }
}

//得到指定样式的文本数组
- (NSMutableArray *)mutableArrayCreatedByContent:(NSMutableString *)content height:(CGFloat)height{
    NSMutableArray *contentList = [NSMutableArray array];
    //理想页码数(整除)
    NSInteger referPageNum = floor(height/kChapterBodyHeight);
    //理想每页字符数
    NSInteger referCharacterNumPerPage = floor(content.length/referPageNum);
    //游标
    NSInteger location = 0;

    while (location < content.length) {
        
        CGFloat characterHeightPerPage = 0;
        //真实每页字符数
        NSInteger realCharacterNumPerPage = referCharacterNumPerPage;
        //文本范围
        NSRange range;
        //如果起始字符为换行符,则删去
        if ([[content substringFromIndex:location] hasPrefix:@"\n"]) {
            [content deleteCharactersInRange:NSMakeRange(location, 1)];
        }
        if ((location + realCharacterNumPerPage) < content.length) {
            //文本范围
            range = NSMakeRange(location, realCharacterNumPerPage);
            //            NSLog(@"%@", [chapterContent substringWithRange:range]);
//            NSLog(@"%f", kChapterBodyHeight);
            characterHeightPerPage = [NSString heightWithContent:[content substringWithRange:range] font:[UIFont systemFontOfSize:self.fontSize] width:kChapterBodyWidth hasFirstLineHeadIndent:self.hasFirstLineHeadIndent];
            if (characterHeightPerPage < kChapterBodyHeight) {
                while (characterHeightPerPage < kChapterBodyHeight) {
                    realCharacterNumPerPage++;
                    if (location + realCharacterNumPerPage > content.length) {
                        break;
                    }
                    range = NSMakeRange(location, realCharacterNumPerPage);
                    characterHeightPerPage = [NSString heightWithContent:[content substringWithRange:range] font:[UIFont systemFontOfSize:self.fontSize] width:kChapterBodyWidth hasFirstLineHeadIndent:self.hasFirstLineHeadIndent];
                    //                    NSLog(@"%@", [chapterContent substringWithRange:range]);
                }
                realCharacterNumPerPage--;
            } else if (characterHeightPerPage > kChapterBodyHeight) {
                while (characterHeightPerPage > kChapterBodyHeight) {
                    realCharacterNumPerPage--;
                    range = NSMakeRange(location, realCharacterNumPerPage);
                    characterHeightPerPage = [NSString heightWithContent:[content substringWithRange:range] font:[UIFont systemFontOfSize:self.fontSize] width:kChapterBodyWidth hasFirstLineHeadIndent:self.hasFirstLineHeadIndent];
                    //                    NSLog(@"%@", [chapterContent substringWithRange:range]);
                }
            } else {
                
            }
            range = NSMakeRange(location, realCharacterNumPerPage);
            [contentList addObject:[content substringWithRange:range]];
            location += realCharacterNumPerPage;
        } else {
            //对于最后一段文字做特殊处理
            characterHeightPerPage = [NSString heightWithContent:[content  substringFromIndex:location] font:[UIFont systemFontOfSize:self.fontSize] width:kChapterBodyWidth hasFirstLineHeadIndent:self.hasFirstLineHeadIndent];
            if (characterHeightPerPage <= kChapterBodyHeight) {
                //如果最后一段文字的高度小于等于给定高度,皆大欢喜,加到数组里就行
                [contentList addObject:[content substringFromIndex:location]];
                location = content.length;
            } else {
                realCharacterNumPerPage = content.length - location;
                while (characterHeightPerPage > kChapterBodyHeight) {
                    realCharacterNumPerPage--;
                    range = NSMakeRange(location, realCharacterNumPerPage);
                    characterHeightPerPage = [NSString heightWithContent:[content substringWithRange:range] font:[UIFont systemFontOfSize:self.fontSize] width:kChapterBodyWidth hasFirstLineHeadIndent:self.hasFirstLineHeadIndent];
                    //                    NSLog(@"%@", [chapterContent substringWithRange:range]);
                }
                range = NSMakeRange(location, realCharacterNumPerPage);
                [contentList addObject:[content substringWithRange:range]];
                location += realCharacterNumPerPage;
            }
        }
    
    }
    
    return contentList;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
//- (BOOL)prefersStatusBarHidden{
//    return YES;
//}
//- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation{
//    return UIStatusBarAnimationFade;
//}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.fontSize = 20;
    self.pageVC = nil;
    [self reloadChapterData];
    
}
- (void)reloadChapterData{
    
    NSLog(@"开始刷新");
    if (self.selectedChapterIndex == 0) {   //如果是第一章
        [self getNextChapterContentData];
        [self getNextChapterContentVCData];
    } else if (self.selectedChapterIndex == self.chapterList.count-1) {     //如果是最后一章
        [self getPreChapterContentData];
        [self getPreChapterContentVCData];
    } else {
        [self getPreChapterContentData];
        [self getPreChapterContentVCData];
        [self getNextChapterContentData];
        [self getNextChapterContentVCData];
    }
//    [self getCurrentChapterContentData];
//    [self getCurrentChapterContentVCData];
    [self pageVC];
//    [self.view setNeedsDisplay];
    NSLog(@"结束刷新");
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
#pragma mark - 协议方法 UIPageViewControllerDataSource/Delegate
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    if ([self.currentChapterContentVCList containsObject:viewController]) {
        NSInteger index = [self.currentChapterContentVCList indexOfObject:viewController];
        self.chapterIndexLb.text = [NSString stringWithFormat:@"%ld / %ld", index+1, self.currentChapterContentList.count];
        //当从后一数组跳转过来,selectedChapterIndex减一
        if (index == self.currentChapterContentVCList.count-1) {
            self.selectedChapterIndex--;
            NSLog(@"当前页码: %ld", self.selectedChapterIndex+1);
            self.chapterTitleLb.text = [self.chapterList objectAtIndex:self.selectedChapterIndex].title;
        }
        //当用户翻到章节一半的时候,开启子线程加载上一章数据
        if (index == floor(self.currentChapterContentVCList.count/2)) {
            //如果当前不为第一章的时候,加载数据
            if (self.selectedChapterIndex > 0) {
                [[Network sharedNetwork] getChapterDetailWithChapterLink:[self.chapterList objectAtIndex:self.selectedChapterIndex-1].link successBlock:^(id responseBody) {
                    [[NSOperationQueue new] addOperationWithBlock:^{
                        if ([[responseBody objectForKey:@"ok"] boolValue]) {
                            self.preChapterDetailModel = [ChapterDetailModel parse:[responseBody objectForKey:@"chapter"]];
                            [self getPreChapterContentData];
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                [self getPreChapterContentVCData];
                            }];
                        }
                    }];                    
                } failureBlock:^(NSError *error) {
                    ;
                }];
            } else {
                //如果当前为第一章的时候,清空即将显示的数组
                [self.preChapterContentVCList removeAllObjects];
            }
        }
        index--;
        if (index < 0) {
            return self.preChapterContentVCList.lastObject;
        }
        return [self.currentChapterContentVCList objectAtIndex:index];
    } else if ([self.preChapterContentVCList containsObject:viewController]) {
        NSInteger index = [self.preChapterContentVCList indexOfObject:viewController];
        self.chapterIndexLb.text = [NSString stringWithFormat:@"%ld / %ld", index+1, self.preChapterContentList.count];
        //当从后一数组跳转过来,selectedChapterIndex减一
        if (index == self.preChapterContentVCList.count-1) {
            self.selectedChapterIndex--;
            NSLog(@"当前页码: %ld", self.selectedChapterIndex+1);
            self.chapterTitleLb.text = [self.chapterList objectAtIndex:self.selectedChapterIndex].title;
        }
        //当用户翻到章节一半的时候,开启子线程加载上一章数据
        if (index == floor(self.preChapterContentVCList.count/2)) {
            if (self.selectedChapterIndex != 0) {
                //如果当前不为第一章的时候,加载数据
                [[Network sharedNetwork] getChapterDetailWithChapterLink:[self.chapterList objectAtIndex:self.selectedChapterIndex-1].link successBlock:^(id responseBody) {
                    [[NSOperationQueue new] addOperationWithBlock:^{
                        if ([[responseBody objectForKey:@"ok"] boolValue]) {
                            self.nextChapterDetailModel = [ChapterDetailModel parse:[responseBody objectForKey:@"chapter"]];
                            [self getNextChapterContentData];
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                [self getNextChapterContentVCData];
                            }];
                        }
                    }];
                } failureBlock:^(NSError *error) {
                    ;
                }];
            } else {
                //如果当前为第一章的时候,清空即将显示的数组
                [self.nextChapterContentVCList removeAllObjects];
            }
        }
        index--;
        if (index < 0) {
            return self.nextChapterContentVCList.lastObject;
        }
        return [self.preChapterContentVCList objectAtIndex:index];
    } else {
        NSInteger index = [self.nextChapterContentVCList indexOfObject:viewController];
        self.chapterIndexLb.text = [NSString stringWithFormat:@"%ld / %ld", index+1, self.nextChapterContentList.count];
        //当从后一数组跳转过来,selectedChapterIndex减一
        if (index == self.nextChapterContentVCList.count-1) {
            self.selectedChapterIndex--;
            NSLog(@"当前页码: %ld", self.selectedChapterIndex+1);
            self.chapterTitleLb.text = [self.chapterList objectAtIndex:self.selectedChapterIndex].title;
        }
        //当用户翻到章节一半的时候,开启子线程加载上一章数据
        if (index == floor(self.nextChapterContentVCList.count/2)) {
            if (self.selectedChapterIndex != 0) {
                //如果当前不为第一章的时候,加载数据
                [[Network sharedNetwork] getChapterDetailWithChapterLink:[self.chapterList objectAtIndex:self.selectedChapterIndex-1].link successBlock:^(id responseBody) {
                    [[NSOperationQueue new] addOperationWithBlock:^{
                        if ([[responseBody objectForKey:@"ok"] boolValue]) {
                            self.currentChapterDetailModel = [ChapterDetailModel parse:[responseBody objectForKey:@"chapter"]];
                            [self getCurrentChapterContentData];
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                [self getCurrentChapterContentVCData];
                            }];
                        }
                    }];
                } failureBlock:^(NSError *error) {
                    ;
                }];
            } else {
                //如果当前为第一章的时候,清空即将显示的数组
                [self.currentChapterContentVCList removeAllObjects];
            }
        }
        index--;
        if (index < 0) {
            return self.currentChapterContentVCList.lastObject;
        }
        return [self.nextChapterContentVCList objectAtIndex:index];
    }
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    if ([self.currentChapterContentVCList containsObject:viewController]) {
        NSInteger index = [self.currentChapterContentVCList indexOfObject:viewController];
        self.chapterIndexLb.text = [NSString stringWithFormat:@"%ld / %ld", index+1, self.currentChapterContentList.count];
        //当从前一数组跳转过来,selectedChapterIndex加一
        //对于首次加载需要进行特殊判断
        if (index == 0) {
            if (self.isFirstLoad) {
                self.firstLoad = NO;
            } else {
                self.selectedChapterIndex++;
            }
            NSLog(@"当前页码: %ld", self.selectedChapterIndex+1);
            self.chapterTitleLb.text = [self.chapterList objectAtIndex:self.selectedChapterIndex].title;
        }
        //当用户翻到章节一半的时候,开启子线程加载下一章数据
        if (index == ceil(self.currentChapterContentVCList.count/2)) {
            
            if (self.selectedChapterIndex < self.chapterList.count-1) {
                //如果当前不为最后章的时候,加载数据
                [[Network sharedNetwork] getChapterDetailWithChapterLink:[self.chapterList objectAtIndex:self.selectedChapterIndex+1].link successBlock:^(id responseBody) {
                    [[NSOperationQueue new] addOperationWithBlock:^{
                        if ([[responseBody objectForKey:@"ok"] boolValue]) {
                            self.nextChapterDetailModel = [ChapterDetailModel parse:[responseBody objectForKey:@"chapter"]];
                            [self getNextChapterContentData];
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                [self getNextChapterContentVCData];
                            }];
                        }
                    }];
                } failureBlock:^(NSError *error) {
                    ;
                }];
            } else {
                //如果当前为最后章的时候,清空即将显示的数组
                [self.nextChapterContentVCList removeAllObjects];
            }
        }
        index++;
        if (index >= self.currentChapterContentVCList.count) {
            return self.nextChapterContentVCList.firstObject;
        }
        return [self.currentChapterContentVCList objectAtIndex:index];
    } else if ([self.preChapterContentVCList containsObject:viewController]) {
        NSInteger index = [self.preChapterContentVCList indexOfObject:viewController];
        self.chapterIndexLb.text = [NSString stringWithFormat:@"%ld / %ld", index+1, self.preChapterContentList.count];
        //当从前一数组跳转过来,selectedChapterIndex加一
        if (index == 0) {
            self.selectedChapterIndex++;
            NSLog(@"当前页码: %ld", self.selectedChapterIndex+1);
            self.chapterTitleLb.text = [self.chapterList objectAtIndex:self.selectedChapterIndex].title;
        }
        //当用户翻到章节一半的时候,开启子线程加载下一章数据
        if (index == ceil(self.preChapterContentVCList.count/2)) {
            if (self.selectedChapterIndex < self.chapterList.count-1) {
                //如果当前不为最后章的时候,加载数据
                [[Network sharedNetwork] getChapterDetailWithChapterLink:[self.chapterList objectAtIndex:self.selectedChapterIndex+1].link successBlock:^(id responseBody) {
                    [[NSOperationQueue new] addOperationWithBlock:^{
                        if ([[responseBody objectForKey:@"ok"] boolValue]) {
                            self.currentChapterDetailModel = [ChapterDetailModel parse:[responseBody objectForKey:@"chapter"]];
                            [self getCurrentChapterContentData];
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                [self getCurrentChapterContentVCData];
                            }];
                        }
                    }];
                } failureBlock:^(NSError *error) {
                    ;
                }];
            } else {
                //如果当前为最后章的时候,清空即将显示的数组
                [self.currentChapterContentVCList removeAllObjects];
            }
        }
        index++;
        if (index >= self.preChapterContentVCList.count) {
            return self.currentChapterContentVCList.firstObject;
        }
        return [self.preChapterContentVCList objectAtIndex:index];
    } else {
        NSInteger index = [self.nextChapterContentVCList indexOfObject:viewController];
        self.chapterIndexLb.text = [NSString stringWithFormat:@"%ld / %ld", index+1, self.nextChapterContentList.count];
        //当从前一数组跳转过来,selectedChapterIndex加一
        if (index == 0) {
            self.selectedChapterIndex++;
            NSLog(@"当前页码: %ld", self.selectedChapterIndex+1);
            self.chapterTitleLb.text = [self.chapterList objectAtIndex:self.selectedChapterIndex].title;
            
        }
        //当用户翻到章节一半的时候,开启子线程加载下一章数据
        if (index == ceil(self.nextChapterContentVCList.count/2)) {
            if (self.selectedChapterIndex < self.chapterList.count-1) {
                //如果当前不为最后章的时候,加载数据
                [[Network sharedNetwork] getChapterDetailWithChapterLink:[self.chapterList objectAtIndex:self.selectedChapterIndex+1].link successBlock:^(id responseBody) {
                    [[NSOperationQueue new] addOperationWithBlock:^{
                        if ([[responseBody objectForKey:@"ok"] boolValue]) {
                            self.preChapterDetailModel = [ChapterDetailModel parse:[responseBody objectForKey:@"chapter"]];
                            [self getPreChapterContentData];
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                [self getPreChapterContentVCData];
                            }];
                        }
                    }];
                } failureBlock:^(NSError *error) {
                    ;
                }];
            } else {
                //如果当前为最后章的时候,清空即将显示的数组
                [self.preChapterContentVCList removeAllObjects];
            }
        }
        index++;
        if (index >= self.nextChapterContentVCList.count) {
            return self.preChapterContentVCList.firstObject;
        }
        return [self.nextChapterContentVCList objectAtIndex:index];
    }
}
#pragma mark - 懒加载 LazyLoad

//Data

- (ChapterDetailModel *)currentChapterDetailModel{
    if (_currentChapterDetailModel == nil) {
        _currentChapterDetailModel = [[ChapterDetailModel alloc] init];
    }
    return _currentChapterDetailModel;
}
- (NSMutableArray *)currentChapterContentList{
    if (_currentChapterContentList == nil) {
        _currentChapterContentList = [NSMutableArray array];
    }
    return _currentChapterContentList;
}
- (NSMutableArray *)preChapterContentList{
    if (_preChapterContentList == nil) {
        _preChapterContentList = [NSMutableArray array];
    }
    return _preChapterContentList;
}
- (NSMutableArray *)nextChapterContentList{
    if (_nextChapterContentList == nil) {
        _nextChapterContentList = [NSMutableArray array];
    }
    return _nextChapterContentList;
}
//UI

- (UIButton *)selectBtn{
    if (_selectBtn == nil) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectBtn.frame = CGRectMake(0, 0, 100, 30);
        [_selectBtn setTitle:@"普通显示" forState:UIControlStateNormal];
        [_selectBtn setTitle:@"分页显示" forState:UIControlStateSelected];
        _selectBtn.backgroundColor = [UIColor redColor];
        _selectBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        __block __weak __typeof(&*self)weakSelf = self;
        [_selectBtn addControlClickBlock:^(UIControl *sender) {
            sender.selected = !sender.selected;
            if (sender.selected) {
//                weakSelf.chapterScrollView.hidden = YES;
//                [weakSelf.view addSubview:weakSelf.pageVC.view];
//                weakSelf.pageVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT);

            } else {
//                [weakSelf.pageVC.view removeFromSuperview];
//                weakSelf.pageVC.view.frame = CGRectZero;
//                weakSelf.chapterScrollView.hidden = NO;
                
            }
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}
- (UILabel *)chapterTitleLb{
    if (_chapterTitleLb == nil) {
        _chapterTitleLb = [[UILabel alloc] init];
        [self.view addSubview:_chapterTitleLb];
        [_chapterTitleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(kLeftInset);
            make.left.equalTo(kLeftInset);
            make.right.equalTo(-kRightInset);
        }];
        _chapterTitleLb.text = @"标题";
        _chapterTitleLb.textColor = TEXT_MID_COLOR;
        _chapterTitleLb.font = [UIFont systemFontOfSize:14];
        _chapterTitleLb.textAlignment = NSTextAlignmentLeft;
    }
    return _chapterTitleLb;
}
- (UILabel *)chapterIndexLb{
    if (_chapterIndexLb == nil) {
        _chapterIndexLb = [[UILabel alloc] init];
        [self.view addSubview:_chapterIndexLb];
        [_chapterIndexLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(-kRightInset);
            make.left.equalTo(kLeftInset);
            make.right.equalTo(-kRightInset);
        }];
        _chapterIndexLb.text = @"序号";
        _chapterIndexLb.textColor = TEXT_MID_COLOR;
        _chapterIndexLb.font = [UIFont systemFontOfSize:14];
        _chapterIndexLb.textAlignment = NSTextAlignmentRight;
    }
    return _chapterIndexLb;
}


- (UIScrollView *)chapterScrollView{
    if (_chapterScrollView == nil) {
        _chapterScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT)];
        [self.view addSubview:_chapterScrollView];
        [_chapterScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
        
        _chapterScrollView.bounces = NO;
        _chapterScrollView.contentSize = CGSizeMake(kChapterBodyWidth, self.currentChapterContentHeight + kTopInset + kBottomInset);
        [_chapterScrollView addSubview:self.chapterBodyLb];
        [self.chapterBodyLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(kTopInset);
            make.left.equalTo(kLeftInset);
            make.width.equalTo(kChapterBodyWidth);
            make.height.equalTo(self.currentChapterContentHeight);
        }];
    }
    return _chapterScrollView;
}
- (UILabel *)chapterBodyLb{
    if (_chapterBodyLb == nil) {
        _chapterBodyLb = [[UILabel alloc] init];
        _chapterBodyLb.font = [UIFont systemFontOfSize:self.fontSize];
        _chapterBodyLb.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@", self.selectedChapterInfoModel.title, self.currentChapterDetailModel.body] attributes:[NSString attributesDictionaryWithContent:[NSString stringWithFormat:@"%@\n%@", self.selectedChapterInfoModel.title, self.currentChapterDetailModel.body] font:_chapterBodyLb.font width:kChapterBodyWidth hasFirstLineHeadIndent:self.hasFirstLineHeadIndent]];
        _chapterBodyLb.textColor = [UIColor blackColor];
        
        _chapterBodyLb.numberOfLines = 0;
        
    }
    return _chapterBodyLb;
}
- (UIPageViewController *)pageVC{
    [self getCurrentChapterContentData];
    if (_pageVC == nil) {
        _pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageVC.view.frame = CGRectMake(0, kTopInset, SCREEN_WIDTH, SCREEN_HEIGHT - kTopInset - kBottomInset);
        [self.view addSubview:_pageVC.view];
        _pageVC.view.tag = kPageViewTag;
        _pageVC.dataSource = self;
        _pageVC.delegate = self;
    }
    
    [self getCurrentChapterContentVCData];
    
    [_pageVC setViewControllers:@[self.currentChapterContentVCList.firstObject] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    self.firstLoad = YES;
    self.chapterTitleLb.text = [self.chapterList objectAtIndex:self.selectedChapterIndex].title;
    self.chapterIndexLb.text = [NSString stringWithFormat:@"1 / %ld", self.currentChapterContentList.count];
    
    
    return _pageVC;
}
- (NSMutableArray<UIViewController *> *)currentChapterContentVCList{
    if (_currentChapterContentVCList == nil) {
        _currentChapterContentVCList = [NSMutableArray array];
    }
    return _currentChapterContentVCList;
}
- (NSMutableArray<UIViewController *> *)preChapterContentVCList{
    if (_preChapterContentVCList == nil) {
        _preChapterContentVCList = [NSMutableArray array];
    }
    return _preChapterContentVCList;
}
- (NSMutableArray<UIViewController *> *)nextChapterContentVCList{
    if (_nextChapterContentVCList == nil) {
        _nextChapterContentVCList = [NSMutableArray array];
    }
    return _nextChapterContentVCList;
}
@end
