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

NSInteger const kPageViewTag = 1000;
NSInteger const kTopInset = 15;
NSInteger const kLeftInset = 15;
NSInteger const kBottomInset = 15;
NSInteger const kRightInset = 15;

#define kChapterBodyWidth (SCREEN_WIDTH - kLeftInset - kRightInset)
#define kChapterBodyHeight (self.view.height - kTopInset - kBottomInset)

@interface ChapterDetailViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>
/** 数据源 */
@property (nonatomic, readwrite, strong) ChapterDetailModel *chapterDetailModel;
/** 章节内容数组 */
@property (nonatomic, readwrite, strong) NSMutableArray *chapterContentList;
/** 章节内容总高 */
@property (nonatomic, readwrite, assign) CGFloat totalHeight;
/** 分页显示基础信息 */
@property (nonatomic, readwrite, strong) NSMutableDictionary *pageDataDictionary;
//
@property (nonatomic, readwrite, strong) NSMutableArray<UIViewController *> *contentVCList;
/** 章节内容 */
@property (nonatomic, readwrite, strong) UILabel *chapterBodyLb;
//
@property (nonatomic, readwrite, strong) UIScrollView *chapterScrollView;
/** 翻页控制器 */
@property (nonatomic, readwrite, strong) UIPageViewController *pageVC;


@end

@implementation ChapterDetailViewController

#pragma mark - 生命周期 LifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackButton];
    self.navigationItem.title = @"章节详情";
    //获取章节详情
    [[Network sharedNetwork] getChapterDetailWithChapterLink:self.selectedChapterModel.link successBlock:^(id responseBody) {
        if ([[responseBody objectForKey:@"ok"] boolValue]) {
            self.chapterDetailModel = [ChapterDetailModel parse:[responseBody objectForKey:@"chapter"]];
//            [self chapterScrollView];
            self.totalHeight = ceil([NSString heightWithContent:[NSString stringWithFormat:@"%@\n%@", self.selectedChapterModel.title, self.chapterDetailModel.body] font:self.chapterBodyLb.font width:kChapterBodyWidth hasFirstLineHeadIndent:YES]);
            [self pageVC];
            
        }
    } failureBlock:^(NSError *error) {
    }];
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    UIView *pageView = [self.view viewWithTag:kPageViewTag];
    pageView.frame = self.view.frame;
}
#pragma mark - 方法 Methods


#pragma mark - 协议方法 UIPageViewControllerDataSource/Delegate
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    NSInteger index = [self.contentVCList indexOfObject:viewController];
    index--;
    if (index < 0) {
        return self.contentVCList.lastObject;
    }
    return [self.contentVCList objectAtIndex:index];
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSInteger index = [self.contentVCList indexOfObject:viewController];
    index++;
    if (index >= self.contentVCList.count) {
        return self.contentVCList.firstObject;
    }
    return [self.contentVCList objectAtIndex:index];
    
}
#pragma mark - 懒加载 LazyLoad
- (ChapterDetailModel *)chapterDetailModel{
    if (_chapterDetailModel == nil) {
        _chapterDetailModel = [[ChapterDetailModel alloc] init];
    }
    return _chapterDetailModel;
}
- (NSMutableArray *)chapterContentList{
    if (_chapterContentList == nil) {
        _chapterContentList = [NSMutableArray array];
    }
    return _chapterContentList;
}
- (NSMutableDictionary *)pageDataDictionary{
    if (_pageDataDictionary == nil) {
        _pageDataDictionary = [NSMutableDictionary dictionary];
        //所要显示的文本
        NSMutableString *chapterContent = [NSMutableString stringWithString:[NSString stringWithFormat:@"%@\n%@", self.selectedChapterModel.title, self.chapterDetailModel.body]];
        //理想页码数(整除)
        NSInteger referPageNum = floor(self.totalHeight/kChapterBodyHeight);
        //理想每页字符数
        NSInteger referCharacterNumPerPage = floor(chapterContent.length/referPageNum) + 50;
        //游标
        NSInteger location = 0;
        //真实每页字符数
        NSInteger realCharacterNumPerPage = referCharacterNumPerPage;
        
        while ((location + referCharacterNumPerPage) < chapterContent.length) {
            
            CGFloat characterHeightPerPage = 0;
            realCharacterNumPerPage = referCharacterNumPerPage;
            NSRange range = NSMakeRange(location, referCharacterNumPerPage);
            //通过循环计算实际高度,不断缩小与理想高度的差值,知道达到临界值,刚好小于理想高度值
            do {
                range = NSMakeRange(location, realCharacterNumPerPage);
                //如果起始字符为换行符,则删去
                if ([[chapterContent substringWithRange:range] hasPrefix:@"\n"]) {
                    [chapterContent deleteCharactersInRange:NSMakeRange(location, 1)];
                }
                characterHeightPerPage = [NSString heightWithContent:[chapterContent substringWithRange:range] font:self.chapterBodyLb.font width:kChapterBodyWidth hasFirstLineHeadIndent:YES];
                realCharacterNumPerPage--;
            } while (characterHeightPerPage > kChapterBodyHeight);
            realCharacterNumPerPage++;
            
            range = NSMakeRange(location, realCharacterNumPerPage);
            [self.chapterContentList addObject:[chapterContent substringWithRange:range]];
            location += realCharacterNumPerPage;
            
        }
        //如果起始字符为换行符,则删去
        if ([[chapterContent substringFromIndex:location] hasPrefix:@"\n"]) {
            [chapterContent deleteCharactersInRange:NSMakeRange(location, 1)];
        }
        [self.chapterContentList addObject:[chapterContent substringFromIndex:location]];
    }
    return _pageDataDictionary;
}
- (NSMutableArray<UIViewController *> *)contentVCList{
    if (_contentVCList == nil) {
        _contentVCList = [NSMutableArray array];
    }
    return _contentVCList;
}
- (UIPageViewController *)pageVC{
    if (_pageVC == nil) {
        _pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        [self.view addSubview:_pageVC.view];
        _pageVC.view.tag = kPageViewTag;
        [self pageDataDictionary];
        
        for (NSString *contentPart in self.chapterContentList) {
            UIViewController *vc = [[UIViewController alloc] init];
            vc.view.backgroundColor = TEXT_WHITE_COLOR;
            
            UILabel *contentPartLb = [[UILabel alloc] init];
            [vc.view addSubview:contentPartLb];
            [contentPartLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.equalTo(kLeftInset);
                make.right.equalTo(-kRightInset);
            }];
            contentPartLb.font = [UIFont systemFontOfSize:17];
            contentPartLb.attributedText = [[NSAttributedString alloc] initWithString:contentPart attributes:[NSString attributesDictionaryWithContent:contentPart font:contentPartLb.font width:kChapterBodyWidth hasFirstLineHeadIndent:YES]];
            contentPartLb.textColor = TEXT_MID_COLOR;
//            contentPartLb.backgroundColor = TEXT_LIGHT_COLOR;
            contentPartLb.numberOfLines = 0;
            
            [self.contentVCList addObject:vc];
        }
        [_pageVC setViewControllers:@[[self.contentVCList objectAtIndex:0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
        
        _pageVC.dataSource = self;
        _pageVC.delegate = self;
        
    }
    return _pageVC;
}
- (UIScrollView *)chapterScrollView{
    if (_chapterScrollView == nil) {
        _chapterScrollView = [[UIScrollView alloc] init];
        [self.view addSubview:_chapterScrollView];
        [_chapterScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
        
        _chapterScrollView.bounces = NO;
        _chapterScrollView.contentSize = CGSizeMake(kChapterBodyWidth, self.totalHeight + kTopInset + kBottomInset);
        [_chapterScrollView addSubview:self.chapterBodyLb];
        [self.chapterBodyLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(kTopInset);
            make.left.equalTo(kLeftInset);
            make.width.equalTo(kChapterBodyWidth);
            make.height.equalTo(self.totalHeight);
        }];
    }
    return _chapterScrollView;
}
- (UILabel *)chapterBodyLb{
    if (_chapterBodyLb == nil) {
        _chapterBodyLb = [[UILabel alloc] init];
        _chapterBodyLb.font = [UIFont systemFontOfSize:17];
        _chapterBodyLb.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@", self.selectedChapterModel.title, self.chapterDetailModel.body] attributes:[NSString attributesDictionaryWithContent:[NSString stringWithFormat:@"%@\n%@", self.selectedChapterModel.title, self.chapterDetailModel.body] font:_chapterBodyLb.font width:kChapterBodyWidth hasFirstLineHeadIndent:YES]];
        _chapterBodyLb.textColor = [UIColor blackColor];
        
        _chapterBodyLb.numberOfLines = 0;
        
    }
    return _chapterBodyLb;
}
@end
