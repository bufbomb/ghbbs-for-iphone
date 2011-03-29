//
//  CategoryViewCell.h
//  ghbbs
//
//  Created by Chenqun Hang on 9/28/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CategoryViewCell : UITableViewCell {
    UILabel * categoryNameLabel;
}

- (void) setCategoryName:(NSString *)name;

@end
