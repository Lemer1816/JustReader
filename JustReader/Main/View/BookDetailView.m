//
//  BookDetailView.m
//  JustReader
//
//  Created by Lemonade on 2017/7/24.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "BookDetailView.h"
#import "NSString+Utils.h"

@interface BookDetailView ()

@property (nonatomic, strong) BookDetailModel *bookDetailModel;

@end

@implementation BookDetailView

- (instancetype)initWithModel:(BookDetailModel *)model{
    if (self = [super init]) {
        self.bookDetailModel = model;
        [self loadView];
    }
    return self;
}
- (void)loadView{
    //封面背景
    UIView *coverBGView = [[UIView alloc] init];
    [self addSubview:coverBGView];
    [coverBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(0);
        make.height.equalTo(50);
    }];
    coverBGView.backgroundColor = NAVIGATION_BACKGROUNDCOLOR;
    //封面
    UIImageView *coverIV = [[UIImageView alloc] init];
    [self addSubview:coverIV];
    [coverIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(0);
        make.centerX.equalTo(0);
        make.width.equalTo(100);
        make.height.equalTo(130);
    }];
    [coverIV sd_setImageWithURL:[NSURL URLWithString:[[self.bookDetailModel.cover stringByRemovingPercentEncoding] substringFromIndex:7]] placeholderImage:[UIImage imageNamed:@"NoCover"]];
    //书名
    UILabel *bookNameLb = [[UILabel alloc] init];
    [self addSubview:bookNameLb];
    [bookNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(coverIV.mas_bottom).equalTo(15);
        make.centerX.equalTo(0);
    }];
    bookNameLb.text = self.bookDetailModel.title;
    bookNameLb.font = [UIFont systemFontOfSize:18];
    bookNameLb.textColor = UIColorFromRGB(0x333333);
    //作者
    UILabel *authorLb = [[UILabel alloc] init];
    [self addSubview:authorLb];
    [authorLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bookNameLb.mas_bottom).equalTo(10);
        make.centerX.equalTo(0);
    }];
    authorLb.text = self.bookDetailModel.author;
    authorLb.font = [UIFont systemFontOfSize:14];
    authorLb.textColor = UIColorFromRGB(0x999999);
    //连载状态
    UILabel *currencyLb = [[UILabel alloc] init];
    [self addSubview:currencyLb];
    [currencyLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(authorLb.mas_bottom).equalTo(10);
        make.right.equalTo(-(5+SCREEN_WIDTH/2));
    }];
    currencyLb.font = [UIFont systemFontOfSize:14];
    if (self.bookDetailModel.currency) {    //已完结
        currencyLb.text = @"已完结";
        currencyLb.textColor = NAVIGATION_BACKGROUNDCOLOR;
    } else {    //连载中
        currencyLb.text = @"连载中";
        currencyLb.textColor = [UIColor greenColor];
    }
    //字数
    UILabel *wordCountLb = [[UILabel alloc] init];
    [self addSubview:wordCountLb];
    [wordCountLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(authorLb.mas_bottom).equalTo(10);
        make.left.equalTo((5+SCREEN_WIDTH/2));
    }];
    wordCountLb.text = [NSString stringWithCount:self.bookDetailModel.wordCount suffix:StringTypeWord];
    wordCountLb.font = [UIFont systemFontOfSize:14];
    wordCountLb.textColor = UIColorFromRGB(0x999999);
}

@end
