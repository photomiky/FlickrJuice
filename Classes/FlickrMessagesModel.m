//
//  FlickrMessagesModel.m
//  FlickrJuice
//
//  Created by Michael Rabin on 12/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FlickrMessagesModel.h"


@implementation FlickrMessagesModel

@synthesize messages=_messages;

-(id) init{
	
	if(self = [super init]){
		// do nothing?
		_messages = [[NSArray alloc] init];
	}
	
	return self;
}

- (void) dealloc {
	TT_RELEASE_SAFELY(_messages);
	[super dealloc];
}




@end
