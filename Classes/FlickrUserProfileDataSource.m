//
//  FlickrUserProfileDataSource.m
//  FlickrJuice
//
//  Created by Michael Rabin on 11/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FlickrUserProfileDataSource.h"


@implementation FlickrUserProfileDataSource

extern NSString* const AVATAR_URL;

@synthesize userProfile=_userProfile;

-(id) initWithUserId:(NSString *) uid{

	if(self = [super init]){
		
		_userProfile = [[UserProfileModel alloc] initWithUserId:uid];
	}
	
	return self;
	
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
	TT_RELEASE_SAFELY(_userProfile);
	
	[super dealloc];
}

- (id<TTModel>)model {
	return _userProfile;
}

- (void)tableViewDidLoadModel:(UITableView*)tableView {
	NSMutableArray* items = [[NSMutableArray alloc] init];
	NSLog(@"UserName %@", _userProfile.person.userName);
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	NSNumber *iconServer = [formatter numberFromString:_userProfile.person.iconServer];
	NSString *imgUrl = nil;
	if(iconServer > 0){ 
		imgUrl = [NSString stringWithFormat:AVATAR_URL, _userProfile.person.iconFarm, _userProfile.person.iconServer, _userProfile.person.nsid];
	}else {
		imgUrl = @"http://www.flickr.com/images/buddyicon.jpg";
	}
//
	TTTableSubtitleItem *pic = [TTTableSubtitleItem itemWithText:_userProfile.person.userName subtitle:[NSString
																										stringWithFormat:@"Has %d photos on Flickr!", [_userProfile.person.photoCount intValue]]
														imageURL:imgUrl URL:nil];
	//TTDASSERT(nil != pic);
	[items addObject:pic];
	TTTableTextItem *item = [TTTableTextItem itemWithText:_userProfile.person.userName];

	//TTDASSERT(nil != item);
	[items addObject:item];
//	[items addObject:item];
	self.items = items;
	//TT_RELEASE_SAFELY(items);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)titleForLoading:(BOOL)reloading {
	if (reloading) {
		return NSLocalizedString(@"Updating Flickr feed...", @"Flickr feed updating text");
	} else {
		return NSLocalizedString(@"Loading User Profile...", @"Flickr feed loading text");
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)titleForEmpty {
	return NSLocalizedString(@"No posts found.", @"Flickr feed no results");
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)subtitleForError:(NSError*)error {
	return NSLocalizedString(@"Sorry, there was an error loading the Flickr stream.", @"");
}

- (UIImage*)imageForEmpty {
	return TTIMAGE(@"bundle://Three20.bundle/images/empty.png");
}

- (NSString*)subtitleForEmpty {
	return NSLocalizedString(@"No Comments/Favs.", @"");
}

@end
