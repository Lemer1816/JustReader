//
//  BookListCell.h
//  JustReader
//
//  Created by Lemonade on 2017/7/20.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookListCell : UITableViewCell
/** 封面 */
@property (weak, nonatomic) IBOutlet UIImageView *coverIV;
/** 书名 */
@property (weak, nonatomic) IBOutlet UILabel *bookNameLb;
/** 作者名 */
@property (weak, nonatomic) IBOutlet UILabel *authorLb;
/** 字数 */
@property (weak, nonatomic) IBOutlet UILabel *wordCountLb;

@end
