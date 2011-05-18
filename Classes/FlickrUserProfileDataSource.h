//
//  FlickrUserProfileDataSource.h
//  FlickrJuice
//
//  Created by Michael Rabin on 11/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserProfileModel.h"

@interface FlickrUserProfileDataSource : TTListDataSource {

	UserProfileModel *_userProfile;
}

@property (nonatomic, retain) UserProfileModel *userProfile;

-(id) initWithUserId:(NSString *) uid;

@end
