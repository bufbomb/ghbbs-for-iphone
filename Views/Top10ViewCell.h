//
//  Top10ViewCell.h
//  ghbbs
//
//  Created by Chenqun Hang on 9/28/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Top10Item.h"

@interface Top10ViewCell : UITableViewCell {
	UILabel * titleLabel;
	UILabel * ownerLabel;
	UILabel * boardLabel;
	UILabel * countLabel;
}

- (void) resetAll;
- (void) setItem:(Top10Item *)item;
@end
