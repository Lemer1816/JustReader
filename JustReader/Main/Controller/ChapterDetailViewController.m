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
/** 分页/滚动视图切换按钮 */
@property (nonatomic, strong) UIButton *selectBtn;
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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.selectBtn];
    //获取章节详情
    [[Network sharedNetwork] getChapterDetailWithChapterLink:self.selectedChapterModel.link successBlock:^(id responseBody) {
        if ([[responseBody objectForKey:@"ok"] boolValue]) {
            self.chapterDetailModel = [ChapterDetailModel parse:[responseBody objectForKey:@"chapter"]];
            self.totalHeight = ceil([NSString heightWithContent:[NSString stringWithFormat:@"%@\n%@", self.selectedChapterModel.title, self.chapterDetailModel.body] font:self.chapterBodyLb.font width:kChapterBodyWidth hasFirstLineHeadIndent:YES]);
            [self chapterScrollView];
            [self pageVC];
        }
    } failureBlock:^(NSError *error) {
    }];
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
}
#pragma mark - 方法 Methods


#pragma mark - 协议方法 UIPageViewControllerDataSource/Delegate
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    NSInteger index = [self.contentVCList indexOfObject:viewController];
    index--;
    if (index < 0) {
        UIViewController *vc = [[UIViewController alloc] init];
        vc.view.backgroundColor = [UIColor greenColor];
        return nil;
    }
    return [self.contentVCList objectAtIndex:index];
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSInteger index = [self.contentVCList indexOfObject:viewController];
    index++;
    if (index >= self.contentVCList.count) {
        return nil;
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
        NSInteger referCharacterNumPerPage = floor(chapterContent.length/referPageNum);
        //游标
        NSInteger location = 0;
        //真实每页字符数
        NSInteger realCharacterNumPerPage = referCharacterNumPerPage;
        
        while ((location + referCharacterNumPerPage) < chapterContent.length) {

            CGFloat characterHeightPerPage = 0;
            realCharacterNumPerPage = referCharacterNumPerPage;
            NSRange range = NSMakeRange(location, realCharacterNumPerPage);
//            NSLog(@"%@", [chapterContent substringWithRange:range]);
            //如果起始字符为换行符,则删去
            if ([[chapterContent substringWithRange:range] hasPrefix:@"\n"]) {
//                [chapterContent replaceCharactersInRange:NSMakeRange(location, 1) withString:@""];
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
- (UIPageViewController *)pageVC{
    if (_pageVC == nil) {
        _pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
//        [self.view addSubview:_pageVC.view];
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
            pageIndexLb.text = [NSString stringWithFormat:@"%@  %ld/%ld", self.selectedChapterModel.title, [self.chapterContentList indexOfObject:contentPart]+1, self.chapterContentList.count];
            pageIndexLb.font = [UIFont systemFontOfSize:14];
            pageIndexLb.textColor = TEXT_MID_COLOR;
            
            
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
        _chapterScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT)];
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
