//
//  PostView.m
//  ghbbs
//
//  Created by Chenqun Hang on 10/8/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import "PostView.h"
#import "UserPreference.h"
#import "PictureManager.h"


@implementation PostView
@synthesize delegate = _delegate;
@synthesize font = _font;
- (id)initWithFrame:(CGRect)frame 
{
    if (self = [super initWithFrame:frame])
    {
        _text = nil;
        _font = [UIFont systemFontOfSize:14.0f];
		_document = [[GHDocument alloc] initWithShowPicture:[UserPreference isShownPicture] needAnsiColor:[UserPreference needAnsiColor]];
        self.backgroundColor = [UIColor whiteColor];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:kPictureUpdate object:nil];
    }
    return self;
}

- (void) setText:(NSString *)text
{
    [_document formatWithText:text];
	self.frame = _document.rect;
    [self setNeedsDisplay];
}

- (void) resizeView
{
}

- (void)drawRect:(CGRect)rect 
{
    [_document draw];
}

- (void) refresh
{
	[self setNeedsDisplay];
}



#pragma mark -
#pragma mark UIGestureRecognizer

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    touchPoint = [touch locationInView:self];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    CGPoint touchEndPoint  = [touch locationInView:self];
    CGPoint touchStartPoint = touchPoint;
    double y = ABS(touchEndPoint.y - touchStartPoint.y);
    double x = touchEndPoint.x - touchStartPoint.x;
    if (y < 50.0) 
    {
        double rate = y / x;
        if (ABS(x) > 30) 
        {
            if (rate < 1.0f && rate > 0.0f)
            {
                [_delegate onViewPrevious];
            }
            else if (rate > -1.0f && rate < 0.0f)
            {
                [_delegate onViewNext];
            }
        }
        else if (ABS(x) < 10 && y < 10)
        {
            if (touchEndPoint.x > 220)
            {
                [_delegate onViewNext];
            }
            else if (touchEndPoint.x < 100)
            {
                [_delegate onViewPrevious];
            }
        }        
    }
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    CGPoint touchEndPoint  = [touch locationInView:self];
    CGPoint touchStartPoint = touchPoint;
    double y = ABS(touchEndPoint.y - touchStartPoint.y);
    double x = touchEndPoint.x - touchStartPoint.x;
    if (y < 50.0) 
    {
        double rate = y / x;
        if (rate < 1.0f && rate > 0.0f)
        {
            [_delegate onViewPrevious];
        }
        else if (rate > -1.0f && rate < 0.0f)
        {
            [_delegate onViewNext];
        }
    }
}

- (void)dealloc {
    [_delegate release];
    [_text release];
    [_font release];
	[_document release];
    [super dealloc];
}


@end
