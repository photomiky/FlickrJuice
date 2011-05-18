//
//  SPAlbumJSONResponse.m
//  SPFeed
//
//  Created by Ynon Perek on 5/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SPAlbumJSONResponse.h"
#import <extThree20JSON/extThree20JSON.h>
#import <extThree20JSON/NSString+SBJSON.h>
#import <extThree20JSON/NSObject+SBJSON.h>
#import "FlickrPhoto.h"

@implementation SPAlbumJSONResponse
@synthesize objects=_objects, totalObjectsAvailableOnServer;

- (id)init {
	_objects = [[NSMutableArray alloc] init];
	return self;
}

-(void) dealloc{

	[_objects dealloc];
	[super dealloc];
	
}

//-(NSInteger) totalObjectsAvailableOnServer{
//	
//
//	return totalObjectsAvailableOnServer;
//}

- (NSError*)request:(TTURLRequest*)request processResponse:(NSHTTPURLResponse*)response data:(id)data
{
    NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	// TODO handle errors
	//NSLog(@"body: %@", responseBody);
    // Parse the JSON data that we retrieved from the server.
    NSDictionary *json = [responseBody JSONValue];
    [responseBody release];
	NSDictionary *main = [json objectForKey:@"photos"];	
//	NSNumber *perpage = [main objectForKey:@"perpage"];
//	int perpageInt = [perpage intValue];
//	NSNumber *pages = [main objectForKey:@"pages"];		
//	int pagesInt = [pages intValue];
	totalObjectsAvailableOnServer = [[main objectForKey:@"total"] intValue];
	NSLog(@"Num of objects %d", totalObjectsAvailableOnServer);	
	NSMutableArray *arrOfFlickrPhotos = [[[NSMutableArray alloc] initWithCapacity:totalObjectsAvailableOnServer] autorelease];
	NSDictionary *arrOfServerPhotos = [main objectForKey:@"photo"];
	//NSLog(@"Photo array is of size %@", [arrOfServerPhotos count]);
	for(NSDictionary *photo in arrOfServerPhotos){
			
		CGSize bigSize = CGSizeMake(500, 333);			
		FlickrPhoto *fphoto = [[FlickrPhoto alloc] initWithURL:[photo objectForKey:@"url_m"] smallURL:[photo objectForKey:@"url_t"] size:bigSize caption:[photo objectForKey:@"title"]];
		fphoto.farm = [photo objectForKey:@"farm"];
		fphoto.owner = [photo objectForKey:@"owner"];
		fphoto.server = [photo objectForKey:@"server"];
		fphoto.secret = [photo objectForKey:@"secret"];
		fphoto.itemId = [photo objectForKey:@"id"];
		fphoto.urlMedium = [photo objectForKey:@"url_m"];
		[arrOfFlickrPhotos addObject:fphoto];
	}
	
	[self.objects addObjectsFromArray:arrOfFlickrPhotos];
    return nil;
}

@end
