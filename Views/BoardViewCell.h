//
//  BoardViewCell.h
//  ghbbs
//
//  Created by Chenqun Hang on 9/28/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

@interface BoardViewCell : UITableViewCell {
    UILabel * postMarkLabel;
    UILabel * postTitleLabel;
    UILabel * timeLabel;
    UILabel * ownerLabel;
    UIImageView * imageView;
}

- (void) resetAll;
- (void) setPost:(Post *)post;
- (void) setTitle:(NSString *)title;

@end
