//
//  FlickrCommentsModel.m
//  BirthdayChecker
//
//  Created by Michael Rabin on 11/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FlickrCommentsModel.h"
#import <extThree20JSON/extThree20JSON.h>
#import "LoginViewController.h"
#import "UserComment.h"
#import "Activity.h"
#import "Event.h"
#import "Consts.h"
#import "FlickrPhoto.h"

@implementation FlickrCommentsModel

@synthesize comments=_comments, currEvent=_currEvent, currElement=_currElement, mutableComments=_mutableComments, ttReq=_ttReq;


extern const NSString* FlickrAPIKey;
extern const NSString* FlickrSecret;
extern const NSString* FLICKR_API;


-(id) init{
    self = [super init];
	if(self){
		// do nothing?
		_comments = [[NSArray alloc] init];

	}
	
	return self;
}

- (void) dealloc {
	TT_RELEASE_SAFELY(_comments);

	[super dealloc];
}



- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
	
	
	if (! self.isLoaded) {
		// nothing is loaded - so we can't delay loading real data. loading from disk
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];		
		NSData *data = [defaults objectForKey:[self commentsKey]];		
		
		if (data) {
			[self didStartLoad];
			NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];		
			self.comments = [NSMutableArray arrayWithArray:arr];
			NSLog(@"found comments: %@", self.comments);
			[_loadedTime release];
			_loadedTime = [[NSDate date] retain];
			[self didFinishLoad];	
			
			return;
		}
	}
	
	
	if (!self.isLoading) {
		
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		
		NSString *token = [defaults objectForKey:@"token"];
		NSString *method = @"flickr.activity.userPhotos";
		
		NSString *api_sig_str = [NSString stringWithFormat:@"%@api_key%@auth_token%@formatjsonmethod%@nojsoncallback1page10perpage15timeframe365d", FlickrSecret, FlickrAPIKey, token, method]; 
		NSLog(@"api_Sig %@", api_sig_str);
			  
		NSString *api_sig = [LoginViewController md5:api_sig_str];
							 
		NSString *params = [NSString stringWithFormat:@"method=%@&format=json&page=10&perpage=15&timeframe=365d&nojsoncallback=1&api_key=%@&auth_token=%@&api_sig=%@", method, FlickrAPIKey, token, api_sig];
		
		NSString *url = [FLICKR_API stringByAppendingString:params];
		NSLog(@"url sent to flickr is %@", url);
		
		//NSString *url2 = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		TTURLRequest *req = [TTURLRequest
								 requestWithURL: url
								 delegate: self];
		
		req.cachePolicy = TTURLRequestCachePolicyNoCache;
//		self.ttReq.cacheExpirationAge = 0;
		
		TTURLJSONResponse* response = [[TTURLJSONResponse alloc] init];
		
		//response.isRssFeed = YES;
		//response.isRssFeed = YES;
		req.response = response;
		
		TT_RELEASE_SAFELY(response);
		
		[req send];
	
	}
}




 - (void)requestDidFinishLoad:(TTURLRequest*)request {
	 TTURLJSONResponse* response = request.response;
	 //TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);
//	// 
//	 
	 
	 NSDictionary* feed = response.rootObject;
	 
	 //NSLog(@"response %@", feed);	 

	 NSDictionary* itemsWrap = [feed objectForKey:@"items"];
	 NSArray* items = [itemsWrap objectForKey:@"item"];
	 NSMutableArray *userComments = [[NSMutableArray alloc] init];

	 for(NSDictionary *item in items){
		// create comment object and photo object
		 
		FlickrPhoto *comment = [[FlickrPhoto alloc] init];
		comment.type = [item objectForKey:@"type"];
		comment.commentsCount = [item objectForKey:@"comments"];
		
		comment.title = [[item objectForKey:@"title"] objectForKey:@"_content"];
		
		
		comment.itemId = [item objectForKey:@"id"];
		comment.owner = [item objectForKey:@"owner"];
		 
		comment.server = [item objectForKey:@"server"];
		
		 
		 comment.secret = [item objectForKey:@"secret"];
		 
		 
		 if([comment.type isEqualToString:@"photo"]){
			 comment.commentsCount = [item objectForKey:@"comments"];
			 comment.viewsCount = [item objectForKey:@"views"];
		 }
		 comment.favsCount = [item objectForKey:@"faves"];
		 
		 comment.farm = [item objectForKey:@"farm"];
		 
		 
		 comment.urlMedium = [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_m.jpg", comment.farm, comment.server, comment.itemId, comment.secret];
		 comment.urlThumb =  [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_t.jpg", comment.farm, comment.server,  comment.itemId,  comment.secret];
		 //comment.URL = [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_l.jpg", comment.farm, comment.server,  comment.itemId,  comment.secret];
		 
		 comment.itemId = [item objectForKey:@"id"]; 
		 Activity *activity = [[Activity alloc] init];
		 NSArray *events = [[item objectForKey:@"activity"] objectForKey:@"event"];
		 NSMutableArray *eventsAgg = [[NSMutableArray alloc] init];
		 BOOL skip = NO;
		 for(NSDictionary *event in events){
			 Event *e1 = [[Event alloc] init];
			 e1.type = [event objectForKey:@"type"];
			 if([e1.type isEqualToString:@"group_invite"]){
				 skip = YES;
				 NSLog(@"Event skipped %@", e1);
			 }
			if(!skip){
				 e1.content = [event objectForKey:@"_content"];
				 e1.dateAdded = [event objectForKey:@"dateadded"];
				 e1.userName = [event objectForKey:@"username"];
				 e1.userId = [event objectForKey:@"user"];

		//		 NSLog(@"is null ? %d", [e1 isEqual:[NSNull null]]);
//				 NSLog(@"is nil ? %d", (e1 == nil));
				[eventsAgg addObject:e1];
				[e1 release];
			}
		 }
		 if([eventsAgg count] == 0){
			 continue;
		 }
		activity.events = eventsAgg;
		comment.activity = activity;
		[userComments addObject:comment];
		
		//[comment release];
	 }
		 //	 TTDASSERT([[feed objectForKey:@"data"] isKindOfClass:[NSArray class]]);
	 _comments = userComments;
	 
	 // save to cache
	 
	 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	 NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_comments];	
	 [defaults setObject:data forKey:[self commentsKey]];	
	 
	 
	 
	 [super requestDidFinishLoad:request];
	
 }



-(NSString *) commentsKey{
	
		return @"commentsKey";
}

@end
