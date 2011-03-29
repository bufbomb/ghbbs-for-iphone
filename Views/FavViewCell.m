//
//  FavViewCell.m
//  ghbbs
//
//  Created by Chenqun Hang on 11/9/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import "FavViewCell.h"
#define BigFontSize 16.0f

#define BoardLeft 10.0f
#define BoardTop 10.0f
#define BoardWidth 300.0f


@implementation FavViewCell
@synthesize title = _title;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        _bigFont = [UIFont systemFontOfSize:BigFontSize];
        _title = nil;
    }
    return self;
}


- (void) resetAll
{
    self.title = nil;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect 
{
    [[UIColor blackColor] set];
    [_title drawAtPoint:CGPointMake(BoardLeft, BoardTop) forWidth:BoardWidth withFont:_bigFont lineBreakMode:UILineBreakModeWordWrap];
}


- (void)dealloc {
    [super dealloc];
}


@end
