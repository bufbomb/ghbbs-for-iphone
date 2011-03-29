//
//  CategoryViewCell.m
//  ghbbs
//
//  Created by Chenqun Hang on 9/28/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import "CategoryViewCell.h"


@implementation CategoryViewCell

#define CategoryNameWidth 270
#define CategoryNameHeight 40

#define BigFontSize 20

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        CGRect rectTitle = CGRectMake(25.0f, 5.0f, CategoryNameWidth, CategoryNameHeight);
        categoryNameLabel = [[UILabel alloc] initWithFrame:rectTitle];
        categoryNameLabel.textColor = [UIColor blackColor];
        categoryNameLabel.font = [UIFont systemFontOfSize:BigFontSize];
        categoryNameLabel.textAlignment = UITextAlignmentCenter;
        
        [self.contentView addSubview:categoryNameLabel];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setCategoryName:(NSString *)name
{
    //_name = [name retain];
    categoryNameLabel.text = name;
}

- (void)dealloc {
//    [_name release];
    [super dealloc];
}


@end
