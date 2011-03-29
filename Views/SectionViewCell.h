//
//  SectionViewCell.h
//  ghbbs
//
//  Created by Chenqun Hang on 9/28/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Board.h"

@interface SectionViewCell : UITableViewCell {
    UILabel * boardTitleLabel;
    UILabel * BMsLabel;
    UILabel * countLabel;
    UIImageView * imageView;
}

- (void) resetAll;
- (void) setBoard:(Board *)board;
@end
