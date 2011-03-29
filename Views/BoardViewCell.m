//
//  BoardViewCell.m
//  ghbbs
//
//  Created by Chenqun Hang on 9/28/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import "BoardViewCell.h"
@interface BoardViewCell()
- (BOOL) isRead:(NSString *)markStr;
@end

@implementation BoardViewCell

#define PostTitleWidth 280.0f
#define PostTitleHeight 30.0f
#define TimeWidth 160.0f
#define TimeHeight 20.0f
#define OwnerWidth 120.0f
#define OwnerHeight TimeHeight

#define ImageWidth 30
#define ImageHeight 30

#define BigFontSize 16.0f
#define SmallFontSize 14.0f

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) 
    {
        CGRect rectTitle = CGRectMake(ImageWidth, 0.0f, PostTitleWidth, PostTitleHeight);
        postTitleLabel = [[UILabel alloc] initWithFrame:rectTitle];
        postTitleLabel.font = [UIFont systemFontOfSize:BigFontSize];
        
        CGRect rectTime = CGRectMake(ImageWidth, PostTitleHeight, TimeWidth, TimeHeight);
        timeLabel = [[UILabel alloc] initWithFrame:rectTime];
        timeLabel.font = [UIFont systemFontOfSize:SmallFontSize];
        
        CGRect rectOwner = CGRectMake(ImageWidth + TimeWidth, PostTitleHeight, OwnerWidth, OwnerHeight);
        ownerLabel = [[UILabel alloc] initWithFrame:rectOwner];
        ownerLabel.font = [UIFont systemFontOfSize:SmallFontSize];
        ownerLabel.textAlignment = UITextAlignmentRight;
        ownerLabel.textColor = [UIColor lightGrayColor];
        
        CGRect rectMark = CGRectMake(0.0f, 0.0f, ImageWidth, ImageHeight);
        postMarkLabel = [[UILabel alloc] initWithFrame:rectMark];
        postMarkLabel.contentMode = UIViewContentModeCenter;
        postMarkLabel.textAlignment = UITextAlignmentCenter;
        
        CGRect rectImage = CGRectMake(0.0f, 0.0f, ImageWidth, ImageHeight);
        imageView = [[UIImageView alloc] initWithFrame:rectImage];
        imageView.contentMode = UIViewContentModeCenter;
        
        [self.contentView addSubview:postTitleLabel];
        [self.contentView addSubview:timeLabel];
        [self.contentView addSubview:ownerLabel];
        [self.contentView addSubview:postMarkLabel];
        [self.contentView addSubview:imageView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) resetAll
{
    [self setPost:nil];
}

- (void) setPost:(Post *)post
{
    if (post != nil) 
    {
        postTitleLabel.text = post.title;
        timeLabel.text = post.time;
        ownerLabel.text = post.owner;
        timeLabel.textColor = [UIColor lightGrayColor];
        if (post.isStick) 
        {
            UIImage * image = [UIImage imageNamed:@"up.gif"];
            [imageView setImage:image];
            postTitleLabel.textColor = [UIColor redColor];
            postTitleLabel.font = [UIFont boldSystemFontOfSize:BigFontSize];
        }
        else
        {
            if ([self isRead:post.mark]) 
            {
                postTitleLabel.textColor = [UIColor grayColor];
            }
            postMarkLabel.font = [UIFont systemFontOfSize:SmallFontSize];
            postMarkLabel.text = post.mark;
            postTitleLabel.font = [UIFont systemFontOfSize:BigFontSize];
            imageView.image = nil;
        }

    }
    else
    {
        postMarkLabel.text = @"";
        postTitleLabel.text = @"";
        timeLabel.text = @"";
        ownerLabel.text = @"";
        postTitleLabel.textColor = [UIColor blackColor];
        [imageView setImage:nil];
    }

}

- (void) setTitle:(NSString *)title
{
    assert(title);
    [self resetAll];
    postTitleLabel.text = title;
}

- (BOOL) isRead:(NSString *)markStr
{
    assert(markStr);
    char mark = [markStr characterAtIndex:0];
    if ((mark <= 'z' && mark >='a') || mark == ' ')
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)dealloc {
    [postMarkLabel release];
    [imageView release];
    [postTitleLabel release];
    [ownerLabel release];
    [timeLabel release];
    [super dealloc];
}


@end
