//
//  PhotoPageModel.m
//  BirthdayChecker
//
//  Created by Michael Rabin on 11/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PhotoPageModel.h"
#import "FlickrCommentsModel.h"
#import <extThree20JSON/extThree20JSON.h>

@implementation PhotoPageModel

extern const NSString* FLICKR_API;

@synthesize photoId=_photoId;

-(id) initWithPhotoId:(NSString *) photoId{
	
	if(self = [super init]){
		_photoId = photoId;

	}
	
	return self;
}

- (void) dealloc {
	TT_RELEASE_SAFELY(_photoId);
	[super dealloc];
}




@end
