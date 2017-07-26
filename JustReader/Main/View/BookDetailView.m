//
//  BookDetailView.m
//  JustReader
//
//  Created by Lemonade on 2017/7/24.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "BookDetailView.h"
#import "NSString+Utils.h"
#import "NSDate+Utils.h"
#import "UIView+Frame.h"
#import "UIControl+Event.h"

@interface BookDetailView ()
/** 书籍数据model */
@property (nonatomic, strong) BookDetailModel *bookDetailModel;
/** 基础信息视图 */
@property (nonatomic, strong) UIView *basicInfoView;
/** 简介 */
@property (nonatomic, strong) UILabel *introductionLb;
/** 标签 */
@property (nonatomic, strong) UILabel *tagsLb;
/** 最新章组合视图(最新章,更新时间) */
@property (nonatomic, strong) UIView *lastChapterView;
/**  */
@property (nonatomic, strong) UIView *readActionView;
@end

@implementation BookDetailView

- (instancetype)initWithModel:(BookDetailModel *)model{
    if (self = [super init]) {
        self.bookDetailModel = model;
        [self loadView];
        [self calculateTotalHeight];
    }
    return self;
}
- (void)loadView{
    
    [self readActionView];
    NSLog(@"%f", self.tagsLb.height);
}
//计算总体高度
- (void)calculateTotalHeight{
    CGFloat introHeight = [NSString heightWithContent:self.introductionLb.text font:self.tagsLb.font width:SCREEN_WIDTH-30];
    CGFloat tagsHeight = [NSString heightWithContent:self.tagsLb.text font:self.tagsLb.font width:SCREEN_WIDTH-30];
    self.totalHeight = 225 + 15 + introHeight + 15 + tagsHeight + 15 + 40 + 15 + 60 + 15;
}
#pragma mark - 懒加载 LazyLoad
- (UIView *)basicInfoView{
    if (_basicInfoView == nil) {
        _basicInfoView = [[UIView alloc] init];
        [self addSubview:_basicInfoView];
        [_basicInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(0);
            make.height.equalTo(225);
        }];
        //封面背景
        UIView *coverBGView = [[UIView alloc] init];
        [_basicInfoView addSubview:coverBGView];
        [coverBGView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(0);
            make.height.equalTo(50);
        }];
        coverBGView.backgroundColor = NAVIGATION_BACKGROUNDCOLOR;
        //封面
        UIImageView *coverIV = [[UIImageView alloc] init];
        [_basicInfoView addSubview:coverIV];
        [coverIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(0);
            make.centerX.equalTo(0);
            make.width.equalTo(100);
            make.height.equalTo(130);
        }];
        [coverIV sd_setImageWithURL:[NSURL URLWithString:[self.bookDetailModel.cover isEqualToString:@""] ? @"" :  [[self.bookDetailModel.cover stringByRemovingPercentEncoding] substringFromIndex:7]] placeholderImage:[UIImage imageNamed:@"NoCover"]];
        //书名
        UILabel *bookNameLb = [[UILabel alloc] init];
        [_basicInfoView addSubview:bookNameLb];
        [bookNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(coverIV.mas_bottom).equalTo(15);
            make.centerX.equalTo(0);
        }];
        bookNameLb.text = self.bookDetailModel.title;
        bookNameLb.font = [UIFont systemFontOfSize:18];
        bookNameLb.textColor = TEXT_DARK_COLOR;
        //作者
        UILabel *authorLb = [[UILabel alloc] init];
        [_basicInfoView addSubview:authorLb];
        [authorLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bookNameLb.mas_bottom).equalTo(10);
            make.centerX.equalTo(0);
        }];
        authorLb.text = self.bookDetailModel.author;
        authorLb.font = [UIFont systemFontOfSize:14];
        authorLb.textColor = TEXT_LIGHT_COLOR;
        //连载状态
        UILabel *currencyLb = [[UILabel alloc] init];
        [_basicInfoView addSubview:currencyLb];
        [currencyLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(authorLb.mas_bottom).equalTo(10);
            make.left.equalTo(30);
            make.right.equalTo(-(5+SCREEN_WIDTH/2));
        }];
        currencyLb.font = [UIFont systemFontOfSize:14];
        currencyLb.textAlignment = NSTextAlignmentRight;
        if (self.bookDetailModel.currency) {    //已完结
            currencyLb.text = @"已完结";
            currencyLb.textColor = NAVIGATION_BACKGROUNDCOLOR;
        } else {    //连载中
            currencyLb.text = @"连载中";
            currencyLb.textColor = TEXT_GREEN_COLOR;
        }
        //字数
        UILabel *wordCountLb = [[UILabel alloc] init];
        [_basicInfoView addSubview:wordCountLb];
        [wordCountLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(authorLb.mas_bottom).equalTo(10);
            make.right.equalTo(-30);
            make.left.equalTo((5+SCREEN_WIDTH/2));
        }];
        wordCountLb.text = [NSString stringWithCount:self.bookDetailModel.wordCount suffix:StringTypeWord];
        wordCountLb.font = [UIFont systemFontOfSize:14];
        wordCountLb.textColor = TEXT_LIGHT_COLOR;
    }
    return _basicInfoView;
}
- (UILabel *)introductionLb{
    if (_introductionLb == nil) {
        _introductionLb = [[UILabel alloc] init];
        [self addSubview:_introductionLb];
        [_introductionLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.basicInfoView.mas_bottom).equalTo(15);
            make.left.equalTo(15);
            make.right.equalTo(-15);
        }];
        _introductionLb.font = [UIFont systemFontOfSize:14];
        _introductionLb.textColor = UIColorFromRGB(0x999999);
//        _introductionLb.text = self.bookDetailModel.longIntro;
        NSString *intro = [NSString stringWithFormat:@"简介:\n%@", self.bookDetailModel.longIntro];
        _introductionLb.attributedText = [[NSAttributedString alloc] initWithString:intro attributes:[NSString attributesDictionaryWithContent:intro font:_introductionLb.font width:SCREEN_WIDTH-30]];
        _introductionLb.numberOfLines = 0;
//        _introductionLb.backgroundColor = [UIColor purpleColor];
    }
    return _introductionLb;
}
- (UILabel *)tagsLb{
    if (_tagsLb == nil) {
        _tagsLb = [[UILabel alloc] init];
        [self addSubview:_tagsLb];
        [_tagsLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.introductionLb.mas_bottom).equalTo(15);
            make.left.equalTo(self.introductionLb);
            make.right.equalTo(self.introductionLb);
        }];
        NSMutableString *tagsStr = [NSMutableString stringWithString:@"类型:  "];
        for (NSString *tag in self.bookDetailModel.tags) {
            [tagsStr appendFormat:@"%@  ", tag];
        }
//        _tagsLb.text = [tagsStr copy];
        _tagsLb.font = [UIFont systemFontOfSize:14];
        _tagsLb.textColor = NAVIGATION_BACKGROUNDCOLOR;
        _tagsLb.attributedText = [[NSAttributedString alloc] initWithString:[tagsStr copy] attributes:[NSString attributesDictionaryWithContent:[tagsStr copy] font:_introductionLb.font width:SCREEN_WIDTH-30]];

        _tagsLb.numberOfLines = 0;
//        _tagsLb.backgroundColor = [UIColor blueColor];
    }
    return _tagsLb;
}
- (UIView *)lastChapterView{
    if (_lastChapterView == nil) {
        _lastChapterView = [[UIView alloc] init];
        [self addSubview:_lastChapterView];
        [_lastChapterView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tagsLb.mas_bottom).equalTo(15);
            make.left.right.equalTo(0);
            make.height.equalTo(40);
        }];
        //最新章
        UILabel *lastChapterLb = [[UILabel alloc] init];
        [_lastChapterView addSubview:lastChapterLb];
        [lastChapterLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.left.equalTo(15);
            make.width.equalTo(SCREEN_WIDTH/3*2);
        }];
        lastChapterLb.text = [NSString stringWithFormat:@"最新章: %@", self.bookDetailModel.lastChapter];
        lastChapterLb.font = [UIFont systemFontOfSize:14];
        lastChapterLb.textColor = TEXT_DARK_COLOR;
        //更新时间
        UILabel *updateTimeLb = [[UILabel alloc] init];
        [_lastChapterView addSubview:updateTimeLb];
        [updateTimeLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.left.equalTo(lastChapterLb.mas_right).equalTo(15);
            make.right.equalTo(-15);
        }];
        updateTimeLb.text = [NSString textStringWithDate:[NSDate dateWithString:self.bookDetailModel.updated dateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"]];
        updateTimeLb.font = [UIFont systemFontOfSize:14];
        updateTimeLb.textColor = TEXT_LIGHT_COLOR;
        updateTimeLb.textAlignment = NSTextAlignmentRight;
        //上分割线
        UIView *topLineView = [[UIView alloc] init];
        [_lastChapterView addSubview:topLineView];
        [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(0);
            make.height.equalTo(1);
        }];
        topLineView.backgroundColor = DEFAULT_BACKGROUND_COLOR;
        //下分割线
        UIView *bottomLineView = [[UIView alloc] init];
        [_lastChapterView addSubview:bottomLineView];
        [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(0);
            make.height.equalTo(1);
        }];
        bottomLineView.backgroundColor = DEFAULT_BACKGROUND_COLOR;
    }
    return _lastChapterView;
}
- (UIView *)readActionView{
    if (_readActionView == nil) {
        _readActionView = [[UIView alloc] init];
        [self addSubview:_readActionView];
        [_readActionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lastChapterView.mas_bottom).equalTo(15);
            make.left.right.equalTo(0);
            make.height.equalTo(60);
        }];
        //开始阅读
        UIButton *readBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_readActionView addSubview:readBtn];
        [readBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(0);
            make.left.equalTo(15);
            make.width.equalTo(SCREEN_WIDTH/2-30);
            make.height.equalTo(40);
        }];
        [readBtn setTitle:@"开始阅读" forState:UIControlStateNormal];
        [readBtn setTitleColor:TEXT_WHITE_COLOR forState:UIControlStateNormal];
        readBtn.backgroundColor = NAVIGATION_BACKGROUNDCOLOR;
        readBtn.layer.masksToBounds = YES;
        readBtn.layer.cornerRadius = 20;
        [readBtn addControlClickBlock:^(UIControl *sender) {
            self.starReadingBlock();
        } forControlEvents:UIControlEventTouchUpInside];
        //加入书单
        UIButton *addMyBookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_readActionView addSubview:addMyBookBtn];
        [addMyBookBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(readBtn);
            make.right.equalTo(-15);
            make.width.equalTo(readBtn);
            make.height.equalTo(readBtn);
        }];
        [addMyBookBtn setTitle:@"加入书单" forState:UIControlStateNormal];
        [addMyBookBtn setTitleColor:TEXT_MID_COLOR forState:UIControlStateNormal];
        addMyBookBtn.backgroundColor = TEXT_WHITE_COLOR;
        addMyBookBtn.layer.masksToBounds = YES;
        addMyBookBtn.layer.cornerRadius = 20;
        [addMyBookBtn addControlClickBlock:^(UIControl *sender) {
            self.addMyBookBlock();
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _readActionView;
}
@end
