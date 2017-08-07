//
//  ChapterDetailViewController.m
//  JustReader
//
//  Created by Lemonade on 2017/7/24.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "ChapterDetailViewController.h"

#import "ChapterDetailModel.h"

#import "NSString+Utils.h"
#import "UIView+Frame.h"
#import "UIControl+Event.h"

static NSInteger const kPageViewTag = 1000;
static NSInteger const kTopInset = 15;
static NSInteger const kLeftInset = 15;
static NSInteger const kBottomInset = 35;
static NSInteger const kRightInset = 15;

#define kChapterBodyWidth (SCREEN_WIDTH - kLeftInset - kRightInset)
#define kChapterBodyHeight (self.view.height - kTopInset - kBottomInset)

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

//UI

/** 分页/滚动视图切换按钮 */
@property (nonatomic, strong) UIButton *selectBtn;
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
    self.navigationItem.title = @"章节详情";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.selectBtn];
    
    [self getCurrentChapterDetail];
//    [[NSOperationQueue new] addOperationWithBlock:^{

//    }];
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
}
#pragma mark - 方法 Methods
//得到当前章的数据
- (void)getCurrentChapterDetail{
    [[Network sharedNetwork] getChapterDetailWithChapterLink:self.selectedChapterInfoModel.link successBlock:^(id responseBody) {
        if ([[responseBody objectForKey:@"ok"] boolValue]) {
            self.currentChapterDetailModel = [ChapterDetailModel parse:[responseBody objectForKey:@"chapter"]];
            self.currentChapterContentHeight = ceil([NSString heightWithContent:[NSString stringWithFormat:@"%@\n%@", self.selectedChapterInfoModel.title, self.currentChapterDetailModel.body] font:self.chapterBodyLb.font width:kChapterBodyWidth hasFirstLineHeadIndent:YES]);
//            [self chapterScrollView];
            [self getPreChapterDetail];
            [self getNextChapterDetail];
            [self pageVC];
        }
    } failureBlock:^(NSError *error) {
        ;
    }];
}
//得到前一章的数据
- (void)getPreChapterDetail{
    NSInteger chapterIndex = [self.chapterList indexOfObject:self.selectedChapterInfoModel];
    NSString *link = [self.chapterList objectAtIndex:chapterIndex-1].link;
    [[Network sharedNetwork] getChapterDetailWithChapterLink:link successBlock:^(id responseBody) {
        if ([[responseBody objectForKey:@"ok"] boolValue]) {
            ChapterListInfoModel *model = [self.chapterList objectAtIndex:chapterIndex-1];
            self.preChapterDetailModel = [ChapterDetailModel parse:[responseBody objectForKey:@"chapter"]];
            self.preChapterContentHeight = ceil([NSString heightWithContent:[NSString stringWithFormat:@"%@\n%@", model.title, self.preChapterDetailModel.body] font:self.chapterBodyLb.font width:kChapterBodyWidth hasFirstLineHeadIndent:YES]);
            [self getPreChapterPageData];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                for (NSString *contentPart in self.preChapterContentList) {
                    UIViewController *vc = [[UIViewController alloc] init];
                    vc.view.backgroundColor = TEXT_WHITE_COLOR;
                    
                    UILabel *contentPartLb = [[UILabel alloc] init];
                    [vc.view addSubview:contentPartLb];
                    [contentPartLb mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.left.equalTo(kLeftInset);
                        make.right.equalTo(-kRightInset);
                        //                make.height.lessThanOrEqualTo(kChapterBodyHeight);
                    }];
                    contentPartLb.font = [UIFont systemFontOfSize:17];
                    contentPartLb.attributedText = [[NSAttributedString alloc] initWithString:contentPart attributes:[NSString attributesDictionaryWithContent:contentPart font:contentPartLb.font width:kChapterBodyWidth hasFirstLineHeadIndent:YES]];
                    contentPartLb.textColor = TEXT_MID_COLOR;
                    //            contentPartLb.backgroundColor = TEXT_LIGHT_COLOR;
                    contentPartLb.numberOfLines = 0;
                    UILabel *pageIndexLb = [[UILabel alloc] init];
                    [vc.view addSubview:pageIndexLb];
                    [pageIndexLb mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.bottom.right.equalTo(-kRightInset);
                    }];
                    NSInteger chapterIndex = [self.chapterList indexOfObject:self.selectedChapterInfoModel];
                    pageIndexLb.text = [NSString stringWithFormat:@"%@  %ld/%ld", [self.chapterList objectAtIndex:chapterIndex-1].title, [self.preChapterContentList indexOfObject:contentPart]+1, self.preChapterContentList.count];
                    pageIndexLb.font = [UIFont systemFontOfSize:14];
                    pageIndexLb.textColor = TEXT_MID_COLOR;
                    
                    [self.preChapterContentVCList addObject:vc];
                }
            }];
        }
    } failureBlock:^(NSError *error) {
        ;
    }];
}
//得到后一章的数据
- (void)getNextChapterDetail{
    NSInteger chapterIndex = [self.chapterList indexOfObject:self.selectedChapterInfoModel];
    NSString *link = [self.chapterList objectAtIndex:chapterIndex+1].link;
    [[Network sharedNetwork] getChapterDetailWithChapterLink:link successBlock:^(id responseBody) {
        if ([[responseBody objectForKey:@"ok"] boolValue]) {
            ChapterListInfoModel *model = [self.chapterList objectAtIndex:chapterIndex+1];
            self.nextChapterDetailModel = [ChapterDetailModel parse:[responseBody objectForKey:@"chapter"]];
            self.nextChapterContentHeight = ceil([NSString heightWithContent:[NSString stringWithFormat:@"%@\n%@", model.title, self.nextChapterDetailModel.body] font:self.chapterBodyLb.font width:kChapterBodyWidth hasFirstLineHeadIndent:YES]);
            [self getNextChapterPageData];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                for (NSString *contentPart in self.nextChapterContentList) {
                    UIViewController *vc = [[UIViewController alloc] init];
                    vc.view.backgroundColor = TEXT_WHITE_COLOR;
                    
                    UILabel *contentPartLb = [[UILabel alloc] init];
                    [vc.view addSubview:contentPartLb];
                    [contentPartLb mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.left.equalTo(kLeftInset);
                        make.right.equalTo(-kRightInset);
                        //                make.height.lessThanOrEqualTo(kChapterBodyHeight);
                    }];
                    contentPartLb.font = [UIFont systemFontOfSize:17];
                    contentPartLb.attributedText = [[NSAttributedString alloc] initWithString:contentPart attributes:[NSString attributesDictionaryWithContent:contentPart font:contentPartLb.font width:kChapterBodyWidth hasFirstLineHeadIndent:YES]];
                    contentPartLb.textColor = TEXT_MID_COLOR;
                    //            contentPartLb.backgroundColor = TEXT_LIGHT_COLOR;
                    contentPartLb.numberOfLines = 0;
                    UILabel *pageIndexLb = [[UILabel alloc] init];
                    [vc.view addSubview:pageIndexLb];
                    [pageIndexLb mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.bottom.right.equalTo(-kRightInset);
                    }];
                    NSInteger chapterIndex = [self.chapterList indexOfObject:self.selectedChapterInfoModel];
                    pageIndexLb.text = [NSString stringWithFormat:@"%@  %ld/%ld", [self.chapterList objectAtIndex:chapterIndex+1].title, [self.nextChapterContentList indexOfObject:contentPart]+1, self.nextChapterContentList.count];
                    pageIndexLb.font = [UIFont systemFontOfSize:14];
                    pageIndexLb.textColor = TEXT_MID_COLOR;
                    
                    [self.nextChapterContentVCList addObject:vc];
                }
            }];
        }
    } failureBlock:^(NSError *error) {
        ;
    }];
}
//得到当前章节分页数据
- (void)getCurrentChapterPageData{
    //所要显示的文本
    NSMutableString *chapterContent = [NSMutableString stringWithString:[NSString stringWithFormat:@"%@\n%@", self.selectedChapterInfoModel.title, self.currentChapterDetailModel.body]];
    //理想页码数(整除)
    NSInteger referPageNum = floor(self.currentChapterContentHeight/kChapterBodyHeight);
    //理想每页字符数
    NSInteger referCharacterNumPerPage = floor(chapterContent.length/referPageNum);
    //游标
    NSInteger location = 0;
    //真实每页字符数
    NSInteger realCharacterNumPerPage = referCharacterNumPerPage;
    
    while ((location + referCharacterNumPerPage) < chapterContent.length) {
        
        CGFloat characterHeightPerPage = 0;
        realCharacterNumPerPage = referCharacterNumPerPage;
        NSRange range = NSMakeRange(location, realCharacterNumPerPage);
        //如果起始字符为换行符,则删去
        if ([[chapterContent substringWithRange:range] hasPrefix:@"\n"]) {
            [chapterContent deleteCharactersInRange:NSMakeRange(location, 1)];
        }
        range = NSMakeRange(location, realCharacterNumPerPage);
        //            NSLog(@"%@", [chapterContent substringWithRange:range]);
        //            NSLog(@"%f", kChapterBodyHeight);
        characterHeightPerPage = [NSString heightWithContent:[chapterContent substringWithRange:range] font:self.chapterBodyLb.font width:kChapterBodyWidth hasFirstLineHeadIndent:YES];
        if (characterHeightPerPage < kChapterBodyHeight) {
            while (characterHeightPerPage < kChapterBodyHeight) {
                realCharacterNumPerPage++;
                range = NSMakeRange(location, realCharacterNumPerPage);
                characterHeightPerPage = [NSString heightWithContent:[chapterContent substringWithRange:range] font:self.chapterBodyLb.font width:kChapterBodyWidth hasFirstLineHeadIndent:YES];
                //                    NSLog(@"%@", [chapterContent substringWithRange:range]);
            }
            realCharacterNumPerPage--;
        } else if (characterHeightPerPage > kChapterBodyHeight) {
            while (characterHeightPerPage > kChapterBodyHeight) {
                realCharacterNumPerPage--;
                range = NSMakeRange(location, realCharacterNumPerPage);
                characterHeightPerPage = [NSString heightWithContent:[chapterContent substringWithRange:range] font:self.chapterBodyLb.font width:kChapterBodyWidth hasFirstLineHeadIndent:YES];
                //                    NSLog(@"%@", [chapterContent substringWithRange:range]);
            }
        } else {
            
        }
        range = NSMakeRange(location, realCharacterNumPerPage);
        [self.currentChapterContentList addObject:[chapterContent substringWithRange:range]];
        location += realCharacterNumPerPage;
    }
    //如果起始字符为换行符,则删去
    if ([[chapterContent substringFromIndex:location] hasPrefix:@"\n"]) {
        [chapterContent deleteCharactersInRange:NSMakeRange(location, 1)];
    }
    [self.currentChapterContentList addObject:[chapterContent substringFromIndex:location]];
}
//得到前一章节分页数据
- (void)getPreChapterPageData{
    //所要显示的文本
    NSInteger chapterIndex = [self.chapterList indexOfObject:self.selectedChapterInfoModel];
    NSMutableString *chapterContent = [NSMutableString stringWithString:[NSString stringWithFormat:@"%@\n%@", [self.chapterList objectAtIndex:chapterIndex-1].title, self.preChapterDetailModel.body]];
    //理想页码数(整除)
    NSInteger referPageNum = floor(self.preChapterContentHeight/kChapterBodyHeight);
    //理想每页字符数
    NSInteger referCharacterNumPerPage = floor(chapterContent.length/referPageNum);
    //游标
    NSInteger location = 0;
    //真实每页字符数
    NSInteger realCharacterNumPerPage = referCharacterNumPerPage;
    
    while ((location + referCharacterNumPerPage) < chapterContent.length) {
        
        CGFloat characterHeightPerPage = 0;
        realCharacterNumPerPage = referCharacterNumPerPage;
        NSRange range = NSMakeRange(location, realCharacterNumPerPage);
        //如果起始字符为换行符,则删去
        if ([[chapterContent substringWithRange:range] hasPrefix:@"\n"]) {
            [chapterContent deleteCharactersInRange:NSMakeRange(location, 1)];
        }
        range = NSMakeRange(location, realCharacterNumPerPage);
        //            NSLog(@"%@", [chapterContent substringWithRange:range]);
        //            NSLog(@"%f", kChapterBodyHeight);
        characterHeightPerPage = [NSString heightWithContent:[chapterContent substringWithRange:range] font:self.chapterBodyLb.font width:kChapterBodyWidth hasFirstLineHeadIndent:YES];
        if (characterHeightPerPage < kChapterBodyHeight) {
            while (characterHeightPerPage < kChapterBodyHeight) {
                realCharacterNumPerPage++;
                range = NSMakeRange(location, realCharacterNumPerPage);
                characterHeightPerPage = [NSString heightWithContent:[chapterContent substringWithRange:range] font:self.chapterBodyLb.font width:kChapterBodyWidth hasFirstLineHeadIndent:YES];
                //                    NSLog(@"%@", [chapterContent substringWithRange:range]);
            }
            realCharacterNumPerPage--;
        } else if (characterHeightPerPage > kChapterBodyHeight) {
            while (characterHeightPerPage > kChapterBodyHeight) {
                realCharacterNumPerPage--;
                range = NSMakeRange(location, realCharacterNumPerPage);
                characterHeightPerPage = [NSString heightWithContent:[chapterContent substringWithRange:range] font:self.chapterBodyLb.font width:kChapterBodyWidth hasFirstLineHeadIndent:YES];
                //                    NSLog(@"%@", [chapterContent substringWithRange:range]);
            }
        } else {
            
        }
        range = NSMakeRange(location, realCharacterNumPerPage);
        [self.preChapterContentList addObject:[chapterContent substringWithRange:range]];
        location += realCharacterNumPerPage;
    }
    //如果起始字符为换行符,则删去
    if ([[chapterContent substringFromIndex:location] hasPrefix:@"\n"]) {
        [chapterContent deleteCharactersInRange:NSMakeRange(location, 1)];
    }
    [self.preChapterContentList addObject:[chapterContent substringFromIndex:location]];
}
//得到后一章节分页数据
- (void)getNextChapterPageData{
    //所要显示的文本
    NSInteger chapterIndex = [self.chapterList indexOfObject:self.selectedChapterInfoModel];
    NSMutableString *chapterContent = [NSMutableString stringWithString:[NSString stringWithFormat:@"%@\n%@", [self.chapterList objectAtIndex:chapterIndex+1].title, self.nextChapterDetailModel.body]];
    //理想页码数(整除)
    NSInteger referPageNum = floor(self.nextChapterContentHeight/kChapterBodyHeight);
    //理想每页字符数
    NSInteger referCharacterNumPerPage = floor(chapterContent.length/referPageNum);
    //游标
    NSInteger location = 0;
    //真实每页字符数
    NSInteger realCharacterNumPerPage = referCharacterNumPerPage;
    
    while ((location + referCharacterNumPerPage) < chapterContent.length) {
        
        CGFloat characterHeightPerPage = 0;
        realCharacterNumPerPage = referCharacterNumPerPage;
        NSRange range = NSMakeRange(location, realCharacterNumPerPage);
        //如果起始字符为换行符,则删去
        if ([[chapterContent substringWithRange:range] hasPrefix:@"\n"]) {
            [chapterContent deleteCharactersInRange:NSMakeRange(location, 1)];
        }
        range = NSMakeRange(location, realCharacterNumPerPage);
        //            NSLog(@"%@", [chapterContent substringWithRange:range]);
        //            NSLog(@"%f", kChapterBodyHeight);
        characterHeightPerPage = [NSString heightWithContent:[chapterContent substringWithRange:range] font:self.chapterBodyLb.font width:kChapterBodyWidth hasFirstLineHeadIndent:YES];
        if (characterHeightPerPage < kChapterBodyHeight) {
            while (characterHeightPerPage < kChapterBodyHeight) {
                realCharacterNumPerPage++;
                range = NSMakeRange(location, realCharacterNumPerPage);
                characterHeightPerPage = [NSString heightWithContent:[chapterContent substringWithRange:range] font:self.chapterBodyLb.font width:kChapterBodyWidth hasFirstLineHeadIndent:YES];
                //                    NSLog(@"%@", [chapterContent substringWithRange:range]);
            }
            realCharacterNumPerPage--;
        } else if (characterHeightPerPage > kChapterBodyHeight) {
            while (characterHeightPerPage > kChapterBodyHeight) {
                realCharacterNumPerPage--;
                range = NSMakeRange(location, realCharacterNumPerPage);
                characterHeightPerPage = [NSString heightWithContent:[chapterContent substringWithRange:range] font:self.chapterBodyLb.font width:kChapterBodyWidth hasFirstLineHeadIndent:YES];
                //                    NSLog(@"%@", [chapterContent substringWithRange:range]);
            }
        } else {
            
        }
        range = NSMakeRange(location, realCharacterNumPerPage);
        [self.nextChapterContentList addObject:[chapterContent substringWithRange:range]];
        location += realCharacterNumPerPage;
    }
    //如果起始字符为换行符,则删去
    if ([[chapterContent substringFromIndex:location] hasPrefix:@"\n"]) {
        [chapterContent deleteCharactersInRange:NSMakeRange(location, 1)];
    }
    [self.nextChapterContentList addObject:[chapterContent substringFromIndex:location]];
}

#pragma mark - 协议方法 UIPageViewControllerDataSource/Delegate
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    if ([self.currentChapterContentVCList containsObject:viewController]) {
        NSInteger index = [self.currentChapterContentVCList indexOfObject:viewController];
        index--;
        if (index < 0) {
            return self.preChapterContentVCList.lastObject;
            
        }
        return [self.currentChapterContentVCList objectAtIndex:index];
    } else if ([self.preChapterContentVCList containsObject:viewController]) {
        NSInteger index = [self.preChapterContentVCList indexOfObject:viewController];
        index--;
        if (index < 0) {
            return [UIViewController new];
        }
        return [self.preChapterContentVCList objectAtIndex:index];
    } else {
        NSInteger index = [self.nextChapterContentVCList indexOfObject:viewController];
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
        index++;
        if (index >= self.currentChapterContentVCList.count) {
            return self.nextChapterContentVCList.firstObject;
        }
        return [self.currentChapterContentVCList objectAtIndex:index];
    } else if ([self.preChapterContentVCList containsObject:viewController]) {
        NSInteger index = [self.preChapterContentVCList indexOfObject:viewController];
        index++;
        if (index >= self.preChapterContentVCList.count) {
            return self.currentChapterContentVCList.firstObject;
        }
        return [self.preChapterContentVCList objectAtIndex:index];
    } else {
        NSInteger index = [self.nextChapterContentVCList indexOfObject:viewController];
        index++;
        if (index >= self.nextChapterContentVCList.count) {
            return [UIViewController new];
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
                weakSelf.chapterScrollView.hidden = YES;
                [weakSelf.view addSubview:weakSelf.pageVC.view];
                weakSelf.pageVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT);

            } else {
                [weakSelf.pageVC.view removeFromSuperview];
                weakSelf.pageVC.view.frame = CGRectZero;
                weakSelf.chapterScrollView.hidden = NO;
                
            }
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
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
        _chapterBodyLb.font = [UIFont systemFontOfSize:17];
        _chapterBodyLb.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@", self.selectedChapterInfoModel.title, self.currentChapterDetailModel.body] attributes:[NSString attributesDictionaryWithContent:[NSString stringWithFormat:@"%@\n%@", self.selectedChapterInfoModel.title, self.currentChapterDetailModel.body] font:_chapterBodyLb.font width:kChapterBodyWidth hasFirstLineHeadIndent:YES]];
        _chapterBodyLb.textColor = [UIColor blackColor];
        
        _chapterBodyLb.numberOfLines = 0;
        
    }
    return _chapterBodyLb;
}
- (UIPageViewController *)pageVC{
    if (_pageVC == nil) {
        
        //遵从先数据后UI原则
        [self getCurrentChapterPageData];
        _pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
//        [self.view addSubview:_pageVC.view];
        _pageVC.view.tag = kPageViewTag;

        for (NSString *contentPart in self.currentChapterContentList) {
            UIViewController *vc = [[UIViewController alloc] init];
            vc.view.backgroundColor = TEXT_WHITE_COLOR;
            
            UILabel *contentPartLb = [[UILabel alloc] init];
            [vc.view addSubview:contentPartLb];
            [contentPartLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.equalTo(kLeftInset);
                make.right.equalTo(-kRightInset);
//                make.height.lessThanOrEqualTo(kChapterBodyHeight);
            }];
            contentPartLb.font = [UIFont systemFontOfSize:17];
            contentPartLb.attributedText = [[NSAttributedString alloc] initWithString:contentPart attributes:[NSString attributesDictionaryWithContent:contentPart font:contentPartLb.font width:kChapterBodyWidth hasFirstLineHeadIndent:YES]];
            contentPartLb.textColor = TEXT_MID_COLOR;
//            contentPartLb.backgroundColor = TEXT_LIGHT_COLOR;
            contentPartLb.numberOfLines = 0;
            
            
            UILabel *pageIndexLb = [[UILabel alloc] init];
            [vc.view addSubview:pageIndexLb];
            [pageIndexLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.right.equalTo(-kRightInset);
            }];
            pageIndexLb.text = [NSString stringWithFormat:@"%@  %ld/%ld", self.selectedChapterInfoModel.title, [self.currentChapterContentList indexOfObject:contentPart]+1, self.currentChapterContentList.count];
            pageIndexLb.font = [UIFont systemFontOfSize:14];
            pageIndexLb.textColor = TEXT_MID_COLOR;

            [self.currentChapterContentVCList addObject:vc];
        }
        [_pageVC setViewControllers:@[self.currentChapterContentVCList.firstObject] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
        _pageVC.dataSource = self;
        _pageVC.delegate = self;
        
    }
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
