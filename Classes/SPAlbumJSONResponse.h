//
//  SPAlbumJSONResponse.h
//  SPFeed
//
//  Created by Ynon Perek on 5/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SPAlbumJSONResponse : NSObject <TTURLResponse> {
	NSMutableArray* _objects;
	NSUInteger totalObjectsAvailableOnServer;
}

@property (nonatomic, retain) NSMutableArray *objects;
@property (nonatomic, readonly) NSUInteger totalObjectsAvailableOnServer;
//-(NSInteger) totalObjectsAvailableOnServer;

@end
