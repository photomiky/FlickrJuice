//
//  UserProfileModel.m
//  FlickrJuice
//
//  Created by Michael Rabin on 11/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UserProfileModel.h"
#import "Consts.h"
#import <extThree20JSON/extThree20JSON.h>

@implementation UserProfileModel

extern const NSString* FlickrAPIKey;
extern const NSString* FlickrSecret;
extern const NSString* FLICKR_API;


@synthesize person=_person;

-(id) initWithUserId:(NSString *) uid{
	
	if(self = [super init]){
	
		self.person = [[Person alloc] init];
		self.person.nsid = uid;
		
	}
	
	return self;
}


- (void) dealloc {
	TT_RELEASE_SAFELY(_person);
	[super dealloc];
}


- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
	
	if(!self.isLoading){
			
		NSString *method = @"flickr.people.getInfo";
		
		NSString *params = [NSString stringWithFormat:@"method=%@&format=json&nojsoncallback=1&api_key=%@&user_id=%@", method, FlickrAPIKey, self.person.nsid];
		
		NSString *url = [FLICKR_API stringByAppendingString:params];
		NSLog(@"url sent to flickr is %@", url);
	
		TTURLRequest *req = [TTURLRequest
							 requestWithURL: url
							 delegate: self];
		
		req.cachePolicy = TTURLRequestCachePolicyNoCache;
		
		
		TTURLJSONResponse* response = [[TTURLJSONResponse alloc] init];
		
		req.response = response;
		
		TT_RELEASE_SAFELY(response);
		
		[req send];
		
		
		
	}
}

- (void)requestDidFinishLoad:(TTURLRequest*)request {
	TTURLJSONResponse* response = request.response;
	NSDictionary* feed = response.rootObject;
	NSDictionary* aPerson = [feed objectForKey:@"person"];
	self.person.iconFarm = [aPerson objectForKey:@"iconfarm"];
	self.person.iconServer = [aPerson objectForKey:@"iconserver"];
	self.person.userName = [[aPerson objectForKey:@"username"] objectForKey:@"_content"];
	self.person.photoCount = [[[aPerson objectForKey:@"photos"] objectForKey:@"count"] objectForKey:@"_content"];
	//self.person.isPro = [[aPerson objectForKey:@"ispro"] isEqualToString:@"1"];
	//self.person.realName = [[aPerson objectForKey:@"username"] objectForKey:@"_content"];
	NSLog(@"User Profile response for uid=%@ is %@", self.person.nsid, feed);
	
	[super requestDidFinishLoad:request];	  
	
}

@end
