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

NSInteger const kPageViewTag = 1000;
NSInteger const kLeftInset = 8;
NSInteger const kRightInset = 4;

#define kChapterBodyWidth (SCREEN_WIDTH - kLeftInset - kRightInset)

@interface ChapterDetailViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>
/** 数据源 */
@property (nonatomic, readwrite, strong) ChapterDetailModel *chapterDetailModel;
/** 书籍内容数组 */
@property (nonatomic, readwrite, strong) NSMutableArray<UIViewController *> *dataList;
/** 章节内容 */
@property (nonatomic, readwrite, strong) UILabel *chapterBodyLb;
//
@property (nonatomic, readwrite, strong) UIScrollView *chapterScrollView;
/** 翻页控制器 */
@property (nonatomic, readwrite, strong) UIPageViewController *pageVC;


@end

@implementation ChapterDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addBackButton];
    self.navigationItem.title = @"章节详情";
    //获取章节详情
    [[Network sharedNetwork] getChapterDetailWithChapterLink:self.chapterLink successBlock:^(id responseBody) {
        if ([[responseBody objectForKey:@"ok"] boolValue]) {
            self.chapterDetailModel = [ChapterDetailModel parse:[responseBody objectForKey:@"chapter"]];
            [self chapterScrollView];
        }
    } failureBlock:^(NSError *error) {
    }];
}

#pragma mark - 协议方法 UIPageViewControllerDataSource/Delegate
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    NSInteger index = [self.dataList indexOfObject:viewController];
    index--;
    if (index < 0) {
        return nil;
    }
    return [self.dataList objectAtIndex:index];
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSInteger index = [self.dataList indexOfObject:viewController];
    index++;
    if (index == self.dataList.count) {
        return nil;
    }
    return [self.dataList objectAtIndex:index];
    
}
#pragma mark - 懒加载 LazyLoad
- (ChapterDetailModel *)chapterDetailModel{
    if (_chapterDetailModel == nil) {
        _chapterDetailModel = [[ChapterDetailModel alloc] init];
    }
    return _chapterDetailModel;
}
- (NSMutableArray<UIViewController *> *)dataList{
    if (_dataList == nil) {
        _dataList = [NSMutableArray array];
        
    }
    return _dataList;
}
- (UIPageViewController *)pageVC{
    if (_pageVC == nil) {
        _pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        [self.view addSubview:_pageVC.view];
        _pageVC.view.tag = kPageViewTag;
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
        
        CGFloat height = [NSString heightWithContent:self.chapterDetailModel.body font:self.chapterBodyLb.font width:kChapterBodyWidth hasFirstLineHeadIndent:YES];
        _chapterScrollView.bounces = NO;
        _chapterScrollView.contentSize = CGSizeMake(kChapterBodyWidth, height);
        [_chapterScrollView addSubview:self.chapterBodyLb];
        [self.chapterBodyLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(kLeftInset);
            make.width.equalTo(kChapterBodyWidth);
            make.height.equalTo(height);
        }];
    }
    return _chapterScrollView;
}
- (UILabel *)chapterBodyLb{
    if (_chapterBodyLb == nil) {
        _chapterBodyLb = [[UILabel alloc] init];
        _chapterBodyLb.attributedText = [[NSAttributedString alloc] initWithString:self.chapterDetailModel.body attributes:[NSString attributesDictionaryWithContent:self.chapterDetailModel.body font:[UIFont systemFontOfSize:14] width:kChapterBodyWidth hasFirstLineHeadIndent:YES]];
        _chapterBodyLb.textColor = [UIColor blackColor];
        _chapterBodyLb.font = [UIFont systemFontOfSize:14];
        _chapterBodyLb.numberOfLines = 0;
    }
    return _chapterBodyLb;
}
@end
