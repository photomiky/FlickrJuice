//
//  SPPhotoSource.h
//  SPFeed
//
//  Created by Ynon Perek on 5/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPAlbumJSONResponse.h"

@interface SPPhotoSource : TTURLRequestModel <TTPhotoSource> {
   
	NSArray *_interestingPics;
	SPAlbumJSONResponse* _responseProcessor;
	NSUInteger page;
}


@property(nonatomic, retain) NSArray *interestingPics;
@property(nonatomic, retain) SPAlbumJSONResponse *responseProcessor;

-(id) initWithTitle:(NSString *) aTitle;
@end
