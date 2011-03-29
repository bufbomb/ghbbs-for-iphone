//
//  FavViewCell.h
//  ghbbs
//
//  Created by Chenqun Hang on 11/9/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FavViewCell : UITableViewCell {
    NSString * _title;
    UIFont * _bigFont;
}
- (void) resetAll;

@property (nonatomic, retain) NSString * title;
@end
