//
//  UserPhotosModel.h
//  FlickrJuice
//
//  Created by Michael Rabin on 11/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPAlbumJSONResponse.h"

@interface UserPhotosModel : TTURLRequestModel <TTPhotoSource> {

	NSString *_userId;
	NSString *_userName;
	NSArray *_usersPhotos;
	SPAlbumJSONResponse *_responseProcessor;
	int page;
}
@property (nonatomic, retain) NSString *userId;
@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSArray *usersPhotos;
@property (nonatomic, retain) SPAlbumJSONResponse *responseProcessor;


-(id) initWithUserId:(NSString *)userId andUserName:(NSString *)userName;
@end
