//
//  BoardRefreshHeaderView.m
//  ghbbs
//
//  Created by Chenqun Hang on 10/9/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import "RefreshHeaderView.h"
#import <QuartzCore/QuartzCore.h>

@implementation RefreshHeaderView

@synthesize isFlipped, lastUpdatedDate;
- (id)initWithFrame:(CGRect)frame 
{
    if ((self = [super initWithFrame:frame])) 
    {
        self.backgroundColor = [UIColor whiteColor];
        lastUpdatedLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, frame.size.height - 20.0f, 300.0f, 20.0f)];
        lastUpdatedLabel.font = [UIFont systemFontOfSize:12.0f];
        lastUpdatedLabel.opaque = YES;
        lastUpdatedLabel.textAlignment = UITextAlignmentCenter;
        lastUpdatedLabel.textColor = [UIColor grayColor];
        lastUpdatedLabel.backgroundColor = self.backgroundColor;
        [self addSubview:lastUpdatedLabel];
        
        statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(80.0f, frame.size.height - 38.0f, 240.0f, 20.0f)];
        statusLabel.backgroundColor = self.backgroundColor;
        statusLabel.opaque = YES;
        statusLabel.font = [UIFont systemFontOfSize:16.0f];
        statusLabel.backgroundColor = self.backgroundColor;
        [self setStatus:kPullToReloadStatus];
        [self addSubview:statusLabel];
        
        arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(25.0f, frame.size.height - 55.0f, 30.0f, 45.0f)];
        arrowImage.contentMode = UIViewContentModeScaleAspectFit;
        arrowImage.image = [UIImage imageNamed:@"refresh-arrow.png"];
        [arrowImage layer].transform = CATransform3DMakeRotation(M_PI, 0.0f, 0.0f, 1.0f);
        [self addSubview:arrowImage];
        
        activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityView.frame = CGRectMake(25.0f, frame.size.height - 40.0f, 20.0f, 20.0f);
        activityView.hidesWhenStopped = YES;
        [self addSubview:activityView];
        
        isFliped = NO;
    }
    return self;
}

- (void)flipImageAnimated:(BOOL)animated
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:animated ? 0.3 : 0.0];
	[arrowImage layer].transform = isFlipped ?
    CATransform3DMakeRotation(M_PI, 0.0f, 0.0f, 1.0f) :
    CATransform3DMakeRotation(M_PI * 2, 0.0f, 0.0f, 1.0f);
	[UIView commitAnimations];
    
	isFlipped = !isFlipped;
}

- (void)setLastUpdatedDate:(NSDate *)newDate
{
	if (newDate)
	{
		if (lastUpdatedDate != newDate)
		{
			[lastUpdatedDate release];
		}
        
		lastUpdatedDate = [newDate retain];
        
		NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
		[formatter setDateStyle:NSDateFormatterShortStyle];
		[formatter setTimeStyle:NSDateFormatterShortStyle];
		lastUpdatedLabel.text = [NSString stringWithFormat:
                                 @"Last Updated: %@", [formatter stringFromDate:lastUpdatedDate]];
		[formatter release];
	}
	else
	{
		lastUpdatedDate = nil;
		lastUpdatedLabel.text = @"Last Updated: Never";
	}
}

- (void)setStatus:(int)status
{
	switch (status) {
		case kReleaseToReloadStatus:
			statusLabel.text = @"Release to refresh...";
			break;
		case kPullToReloadStatus:
			statusLabel.text = @"Pull down to refresh...";
			break;
		case kLoadingStatus:
			statusLabel.text = @"Loading...";
			break;
		default:
			break;
	}
}

- (void)toggleActivityView:(BOOL)isON
{
	if (!isON)
	{
		[activityView stopAnimating];
		arrowImage.hidden = NO;
	}
	else
	{
		[activityView startAnimating];
		arrowImage.hidden = YES;
		[self setStatus:kLoadingStatus];
	}
}


- (void)dealloc {
    [lastUpdatedLabel release];
    [statusLabel release];
    [arrowImage release];
    [activityView release];
    [super dealloc];
}


@end
