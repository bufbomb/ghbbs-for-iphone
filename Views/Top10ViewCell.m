//
//  Top10ViewCell.m
//  ghbbs
//
//  Created by Chenqun Hang on 9/28/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import "Top10ViewCell.h"


@implementation Top10ViewCell
#define PostTitleLeft 5.0f
#define PostTitleTop 7.0f
#define PostTitleWidth 310.0f
#define PostTitleHeight 25.0f

#define BoardLeft PostTitleLeft
#define BoardTop 35.0f
#define BoardWidth 130.0f
#define BoardHeight 15.0f

#define OwnerLeft 180.0f
#define OwnerTop BoardTop
#define OwnerWidth 90.0f
#define OwnerHeight BoardHeight

#define CountLeft 260.0f
#define CountTop BoardTop
#define CountWidth 50.0f
#define CountHeight BoardHeight

#define BigFontSize 16.0f
#define SmallFontSize 14.0f

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) 
    {
		CGRect titleRect = CGRectMake(PostTitleLeft, PostTitleTop, PostTitleWidth, PostTitleHeight);
		titleLabel = [[UILabel alloc] initWithFrame:titleRect];
		titleLabel.font = [UIFont systemFontOfSize:BigFontSize];
		
		CGRect boardRect = CGRectMake(BoardLeft, BoardTop, BoardWidth, BoardHeight);
		boardLabel = [[UILabel alloc] initWithFrame:boardRect];
		boardLabel.font = [UIFont systemFontOfSize:SmallFontSize];
		boardLabel.textColor = [UIColor grayColor];
		
		CGRect ownerRect = CGRectMake(OwnerLeft, OwnerTop, OwnerWidth, OwnerHeight);
		ownerLabel = [[UILabel alloc] initWithFrame:ownerRect];
		ownerLabel.font = [UIFont systemFontOfSize:SmallFontSize];
		ownerLabel.textColor = [UIColor grayColor];
		
		CGRect countRect = CGRectMake(CountLeft, CountTop, CountWidth, CountHeight);
		countLabel = [[UILabel alloc] initWithFrame:countRect];
		countLabel.font = [UIFont systemFontOfSize:SmallFontSize];
		countLabel.textColor = [UIColor grayColor];
		countLabel.textAlignment = UITextAlignmentRight;
		
		[self addSubview: titleLabel];
		[self addSubview: boardLabel];
		[self addSubview: ownerLabel];
		[self addSubview: countLabel];
		
		[self resetAll];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated 
{
    [super setSelected:selected animated:animated];
}

- (void) resetAll
{
	[self setItem:nil];
}

- (void) setItem:(Top10Item *)item;
{
	if (item != nil) 
	{
		titleLabel.text = item.postTitle;
		boardLabel.text = [NSString stringWithFormat:@"[%@]", item.boardName];
		countLabel.text = [NSString stringWithFormat:@"(%d)", item.count];
		ownerLabel.text = item.owner;
	}
	else 
	{
		titleLabel.text = @"";
		boardLabel.text = @"";
		countLabel.text = @"";
		ownerLabel.text = @"";
	}

}

- (void)dealloc {
	[titleLabel release];
	[boardLabel release];
	[countLabel release];
	[ownerLabel release];
    [super dealloc];
}


@end
