//
//  UserProfileModel.h
//  FlickrJuice
//
//  Created by Michael Rabin on 11/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"

@interface UserProfileModel : TTURLRequestModel {

	Person *_person;
	
}

@property (nonatomic, retain) Person *person;

-(id) initWithUserId:(NSString *) uid;

@end
