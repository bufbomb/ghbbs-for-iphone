//
//  CategoryDataSource.h
//  ghbbs
//
//  Created by Chenqun Hang on 9/8/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Category.h"

extern NSString * kCategoryUpdated;
@interface CategoryDataSource : NSObject {
    NSMutableArray * data;
    NSMutableArray * favBoards;
}
+ (CategoryDataSource *)sharedInstance;
- (void) addCategories:(NSArray *)categories;
- (void) removeCategories;
- (int) numberOfCategories;
- (Category *) categoryAtIndex:(int) index;
- (void) addFavs:(NSArray *)favs;
- (void) removeFavs;
- (int) numberOfFavs;
- (NSString *) favAtIndex:(int) index;

@end
