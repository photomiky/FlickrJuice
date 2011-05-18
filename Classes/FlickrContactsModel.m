//
//  FlickrContactsModel.m
//  FlickrJuice2
//
//  Created by Michael Rabin on 6/04/11.
//  Copyright 2011 AppHouse. All rights reserved.
//

#import "FlickrContactsModel.h"
#import "LoginViewController.h"
#import <extThree20JSON/extThree20JSON.h>
#import "Person.h"

@implementation FlickrContactsModel

@synthesize contacts=_contacts;
extern const NSString* FlickrAPIKey;
extern const NSString* FlickrSecret;
extern const NSString* FLICKR_API;


-(id) init{
	
	if(self = [super init]){
		// do nothing?
		_contacts = [[NSArray alloc] init];
		
	}
	
	return self;
}

- (void) dealloc {
	TT_RELEASE_SAFELY(_contacts);
	
	[super dealloc];
}

- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
	
	
	if (! self.isLoaded) {
		// nothing is loaded - so we can't delay loading real data. loading from disk
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];		
		NSData *data = [defaults objectForKey:[self contactsKey]];		
		
		if (data) {
			[self didStartLoad];
			NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:data];		
			self.contacts = [NSMutableArray arrayWithArray:arr];
			NSLog(@"found contacts: %@", self.contacts);
			[_loadedTime release];
			_loadedTime = [[NSDate date] retain];
			[self didFinishLoad];	
			
			return;
		}
	}
	
	
	if (!self.isLoading) {
		
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		
		NSString *token = [defaults objectForKey:@"token"];
		NSString *method = @"flickr.contacts.getList";
		
		NSString *api_sig_str = [NSString stringWithFormat:@"%@api_key%@auth_token%@formatjsonmethod%@nojsoncallback1", FlickrSecret, FlickrAPIKey, token, method]; 
		NSLog(@"api_Sig %@", api_sig_str);
		
		NSString *api_sig = [LoginViewController md5:api_sig_str];
		
		NSString *params = [NSString stringWithFormat:@"method=%@&format=json&nojsoncallback=1&api_key=%@&auth_token=%@&api_sig=%@", method, FlickrAPIKey, token, api_sig];
		
		NSString *url = [FLICKR_API stringByAppendingString:params];
		NSLog(@"url sent to flickr is %@", url);
		
		//NSString *url2 = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		TTURLRequest *req = [TTURLRequest
							 requestWithURL: url
							 delegate: self];
		
		req.cachePolicy = cachePolicy;
		req.cacheExpirationAge = TT_DEFAULT_CACHE_EXPIRATION_AGE;
		
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
	
	NSDictionary *contacts = [feed objectForKey:@"contacts"];
	NSArray *contactsArr = [contacts objectForKey:@"contact"];
	
	NSMutableArray *tmpArry = [[NSMutableArray alloc] initWithCapacity:[contactsArr count]];
								 
	
	for(NSDictionary *item in contactsArr){
		Person *p = [[Person alloc] init];
		p.realName = [item objectForKey:@"realname"];
		p.userName = [item objectForKey:@"username"];
		p.iconFarm = [item objectForKey:@"iconfarm"];
		p.iconServer = [item objectForKey:@"iconserver"];
		p.location = [item objectForKey:@"location"];
		p.nsid = [item objectForKey:@"nsid"];
		[tmpArry addObject:p];
	}
	[_contacts release];
	_contacts = tmpArry;
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];	
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_contacts];	
	[defaults setObject:data forKey:[self contactsKey]];	
	
	
	
	 [super requestDidFinishLoad:request];
	
	
	
}

- (BOOL)isOutdated {
	BOOL od = [super isOutdated];
	return od;
}

- (void)fakeLoadedTime {
	[_loadedTime release];
	_loadedTime = [[NSDate date] retain];
	[self didFinishLoad];	
}

-(NSString *) contactsKey{
	
		
	return @"contacts";
}


@end
