//
//  SectionViewCell.m
//  ghbbs
//
//  Created by Chenqun Hang on 9/28/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import "SectionViewCell.h"
#import "UserPreference.h"

@interface SectionViewCell ()
- (NSString *) getBMsString:(NSArray *)bms;

@end


@implementation SectionViewCell
#define BoardTitleTop 5
#define BoardTitleWidth 280
#define BoardTitleHeight 30
#define BMsWidth 200
#define BMsHeight 20
#define CountWidth 70
#define CountHeight BMsHeight

#define ImageLeft 5
#define ImageTop 10
#define ImageWidth 20
#define ImageHeight 20

#define BigFontSize 18
#define SmallFontSize 14

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]))
    {
		CGRect rectTitle = CGRectMake(ImageWidth + ImageLeft * 2, BoardTitleTop, BoardTitleWidth, BoardTitleHeight);
		boardTitleLabel = [[UILabel alloc] initWithFrame:rectTitle];
		boardTitleLabel.font = [UIFont systemFontOfSize:BigFontSize];
		
		CGRect rectBMs = CGRectMake(ImageWidth + ImageLeft * 2, BoardTitleHeight, BMsWidth, BMsHeight);
		BMsLabel = [[UILabel alloc] initWithFrame:rectBMs];
		BMsLabel.font = [UIFont systemFontOfSize:SmallFontSize];
		BMsLabel.textColor = [UIColor grayColor];
		
		CGRect rectCount = CGRectMake(ImageWidth + BMsWidth + ImageLeft * 2, BoardTitleHeight, CountWidth, CountHeight);
		countLabel = [[UILabel alloc] initWithFrame:rectCount];
		countLabel.font = [UIFont systemFontOfSize:SmallFontSize];
		countLabel.textAlignment = UITextAlignmentRight;
		countLabel.textColor = [UIColor grayColor];
		
		
		CGRect rectImage = CGRectMake(ImageLeft, ImageTop, ImageWidth, ImageHeight);
		imageView = [[UIImageView alloc] initWithFrame:rectImage];
		imageView.contentMode = UIViewContentModeScaleToFill;
		
		[self.contentView addSubview:boardTitleLabel];
		[self.contentView addSubview:BMsLabel];
		[self.contentView addSubview:countLabel];
		[self.contentView addSubview:imageView];
		[self resetAll];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) resetAll
{
	[self setBoard:nil];
}

- (void) setBoard:(Board *)board
{
	if (board != nil)
	{
		if ([UserPreference isEnglishName]) 
		{
			boardTitleLabel.text = board.name;
		}
		else
		{
			boardTitleLabel.text = board.desc;
		}


		BMsLabel.text = [self getBMsString:[board getBMs]];
		countLabel.text = [NSString stringWithFormat:@"%d", board.total];
		if (board.isZone) 
		{
			imageView.image = [UIImage imageNamed:@"zone.png"];
		}
		else
		{
			imageView.image = [UIImage imageNamed:@"board.png"];
		}
	}
	else
	{
		boardTitleLabel.text = nil;
		BMsLabel.text = nil;
		countLabel.text = nil;
		[imageView setImage:nil];
	}

}

- (NSString *) getBMsString:(NSArray *)bms
{
    NSMutableString * buffer = [[[NSMutableString alloc] initWithString:@"BM:"] autorelease];
    if (bms != nil)
    {
        if ([bms count] > 0)
        {
            for (NSString * bm in bms)
            {
                [buffer appendFormat:@" %@", bm];
            }
        }
        else 
        {
            [buffer appendString:@" -"];
        }
    }
    else 
    {
        [buffer appendString:@" -"];
    }
    return buffer;
}

- (void)dealloc {
	[boardTitleLabel release];
	[BMsLabel release];
	[countLabel release];
	[imageView release];
    [super dealloc];
}


@end
