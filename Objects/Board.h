//
//  Board.h
//  ghbbs
//
//  Created by Chenqun Hang on 9/9/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Post.h"
#import "ViewMode.h"

@interface Board : NSObject {
    NSString * _name;
    NSString * _desc;
    NSString * _bid;
    NSMutableArray * BMList;

    NSMutableArray * subBoardList;

    int _total;
    BOOL isZone;
    
}

- (id) initWithName:(NSString *) name Desc:(NSString *) desc Dir:(int) dir;


- (void) addBMs: (NSArray *)bms;
- (void) addSubBoards:(NSArray *)subBoardArray;
- (void) removeAllSubBoards;
- (NSArray *) getBMs;


- (int) numberOfSubBoards;
- (Board *) subBoardAtIndex:(int)index;

- (NSComparisonResult) compare:(Board *)anotherBoard;

@property (nonatomic, readonly) NSString * name;
@property (nonatomic, readonly) NSString * desc;
@property (nonatomic, copy) NSString * bid;
@property int total;
@property BOOL isZone;
@end
