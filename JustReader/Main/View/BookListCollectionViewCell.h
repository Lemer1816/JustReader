//
//  BookListCollectionViewCell.h
//  JustReader
//
//  Created by Lemonade on 2017/7/24.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookListCollectionViewCell : UICollectionViewCell
/** 封面 */
@property (weak, nonatomic) IBOutlet UIImageView *coverIV;
/** 书名 */
@property (weak, nonatomic) IBOutlet UILabel *bookNameLb;

@end
