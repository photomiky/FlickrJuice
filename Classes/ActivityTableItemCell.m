//
//  ActivityTableItemCell.m
//  FlickrJuice
//
//  Created by Michael Rabin on 11/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ActivityTableItemCell.h"
#import "ActivityTableItem.h"
#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>
#import "Three20UI/TTView.h"
#import "Three20UI/UIViewAdditions.h"
#import "Three20Style/TTGlobalStyle.h"
#import "Three20Style/TTDefaultStyleSheet.h"
#import "Three20UI/TTImageView.h"
#import "Three20UI/TTTableSubtitleItem.h"
#import "Three20UI/UIViewAdditions.h"
#import "Three20Style/UIFontAdditions.h"

@implementation ActivityTableItemCell

static CGFloat kHPadding = 10;  
static CGFloat kVPadding = 10;  
static CGFloat kImageWidth = 100;  
static CGFloat kImageHeight = 100;  

@synthesize link=_link;



///////////////////////////////////////////////////////////////////////////////////////////////////
+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
	ActivityTableItem* item = object;
	CGFloat width = tableView.width - kTableCellHPadding*2;

	CGFloat height = TTSTYLEVAR(tableFont).ttLineHeight + kTableCellVPadding*2;
	if (item.subtitle) {
		height += TTSTYLEVAR(font).ttLineHeight;
	}
	
	item.styledText.width = 270 - kVPadding*2;
	height = kImageHeight + kVPadding*2 + MAX(kImageWidth, item.styledText.height);// +kVPadding;

	CGRectMake(0, 0, width,height);
	return height;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {  
    if (self = [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier]) {  
        _item = nil;  
		
        _imgView = [[TTImageView alloc] initWithFrame:CGRectZero];
		UIImageView *backView = [[UIImageView alloc] initWithFrame:self.frame];
		backView.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:5.0/255.0 blue:135.0/255.0 alpha:0.5];
		//backView.image = [UIImage imageNamed:@"cellBg2.png"];
		//self.selected
		self.selectedBackgroundView = backView;
		
		[backView release];
        [self.contentView addSubview:_imgView];  
		_styledTextLabel = [[TTStyledTextLabel alloc] initWithFrame:CGRectZero];
		[self.contentView addSubview:_styledTextLabel];
		
    }  
    return self;  
}  


- (UIButton *) makeDetailDisclosureButton:(ActivityTableItem *)object
{
	

	UIButton * button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

	
	//flickrLogo = [UIImage imageNamed:@"flickrCircles.png"];
	
	button.frame = CGRectMake(0, 0, 45, 45);
	button.backgroundColor = [UIColor clearColor];
	//[button setImage:flickrLogo forState:UIControlStateNormal];

	// set the button link instance var
	self.link = object.linkStr;
	
	[button addTarget:self
			   action:@selector(navigateToPicture)
	forControlEvents: UIControlEventTouchUpInside];
//
//	[button addTarget:self 
//	action:@selector(toggleFavorite) 
//	forControlEvents:UIControlEventTouchUpInside];

	return ( button );
}
					

-(void) navigateToPicture{
	
	
	TTNavigator* navigator = [TTNavigator navigator];
	[navigator openURLAction:[[TTURLAction actionWithURLPath:self.link] applyTransition:UIViewAnimationTransitionCurlDown]];
	//PhotoPageViewController *photoPageViewController = [[photoPageViewController alloc] initWithPhotoSource:
														 
}
									 
- (void)dealloc {  
    TT_RELEASE_SAFELY(_imgView); 
	TT_RELEASE_SAFELY(_styledTextLabel); 
    [super dealloc];  
}  
///////////////////////////////////////////////////////////////////////////////////////////////////  
// UIView  

- (void)layoutSubviews {  
    [super layoutSubviews];  
	CGFloat height = self.contentView.height;
	CGFloat width = self.contentView.width - kImageWidth - kVPadding*2;// - (height + kTableCellSmallMargin);
	CGFloat left = 0;
	
	if (_imgView) {
		_imgView.frame = CGRectMake(kHPadding ,kVPadding , kImageHeight, kImageHeight);
		left = _imgView.right + kTableCellSmallMargin;
	} else {
		left = kTableCellHPadding;
	}
	
	if (self.detailTextLabel.text.length) {
		CGFloat textHeight = self.textLabel.font.ttLineHeight;
		CGFloat subtitleHeight = self.detailTextLabel.font.ttLineHeight;
		//CGFloat paddingY = floor((height - (textHeight + subtitleHeight))/2);
		
		self.textLabel.frame = CGRectMake(left, kVPadding, width, textHeight);
		self.detailTextLabel.frame = CGRectMake(left, self.textLabel.bottom, width, subtitleHeight*3);
		//self.accessibilityFrame = CGRectMake(kHPadding, kVPadding, width, textHeight + subtitleHeight*3);
	} else {
		self.textLabel.frame = CGRectMake(_imgView.right + kTableCellSmallMargin, 0, width, height);
		self.detailTextLabel.frame = CGRectZero;
	}
	
	

	if(_styledTextLabel.text){
		[_styledTextLabel sizeToFit];
		//NSLog(@"styled text is %@", _styledTextLabel.html);
		//TTSTYLEVAR(font).ttLineHeight
		_styledTextLabel.frame = CGRectMake(kHPadding, kImageHeight + kHPadding*2, 
										    _styledTextLabel.text.width, _styledTextLabel.text.height); 
		//_styledTextLabel.frame = CGRectMake(kHPadding, kVPadding*2 + kImageHeight, self.contentView.width - kVPadding, _styledTextLabel.height);//_styledTextLabel.text.height);
		
		
	}
}	

- (id)object {  
    return _item;  
}  

- (void)setObject:(id)object {  
	
    if (_item != object) {  
        [super setObject:object];  
	
        ActivityTableItem* item = object;  
        //self.textLabel.textColor = TTSTYLEVAR(myHeadingColor);  
        //self.textLabel.font = TTSTYLEVAR(myHeadingFont);  
        self.textLabel.textAlignment = UITextAlignmentLeft;  		
        self.textLabel.contentMode = UIViewContentModeCenter;  
        self.textLabel.lineBreakMode = UILineBreakModeWordWrap;  
        self.textLabel.numberOfLines = 2;  
		self.textLabel.backgroundColor = [UIColor clearColor];
        //self.subtitleLabel.textColor = TTSTYLEVAR(mySubtextColor);  
        //self.subtitleLabel.font = TTSTYLEVAR(mySubtextFont);  
        self.subtitleLabel.textAlignment = UITextAlignmentLeft;  
        self.subtitleLabel.contentMode = UIViewContentModeTop;  
        self.subtitleLabel.lineBreakMode = UILineBreakModeWordWrap;  
		self.subtitleLabel.backgroundColor= [UIColor clearColor];
		self.subtitleLabel.numberOfLines = 3;
        _imgView.urlPath = item.imgURL;  
        _imgView.style = item.style;  
		[_styledTextLabel setText:item.styledText];
		[_styledTextLabel sizeToFit];
		_styledTextLabel.contentMode = UIViewContentModeTop;
		_styledTextLabel.backgroundColor = [UIColor clearColor];
		self.accessoryView = [self makeDetailDisclosureButton:object];	
    }  
}

@end
