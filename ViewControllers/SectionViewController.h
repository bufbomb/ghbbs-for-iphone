//
//  SectionViewController.h
//  ghbbs
//
//  Created by Chenqun Hang on 9/9/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Category.h"
#import "Board.h"
#import "BBSParserDelegate.h"
#import "PullToRefreshTableViewController.h"

@interface SectionViewController : PullToRefreshTableViewController {
    Category * category;
    Board * board;
    BOOL isCategory;
    
    BOOL isLoading;
}
- (id) initWithCategory:(Category *)_category;
- (id) initWithBoard:(Board *)_board;

@end
