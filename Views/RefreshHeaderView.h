//
//  BoardRefreshHeaderView.h
//  ghbbs
//
//  Created by Chenqun Hang on 10/9/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kReleaseToReloadStatus	0
#define kPullToReloadStatus		1
#define kLoadingStatus			2

@interface RefreshHeaderView : UIView 
{
    UILabel * lastUpdatedLabel;
    UILabel * statusLabel;
    UIImageView * arrowImage;
    UIActivityIndicatorView * activityView;
    
    BOOL isFliped;
    
    NSDate * lastUpdatedDate;
}

- (void) flipImageAnimated:(BOOL)animated;
- (void) toggleActivityView:(BOOL)isOn;
- (void) setStatus:(int)status;

@property BOOL isFlipped;
@property (nonatomic, retain) NSDate * lastUpdatedDate;

@end
