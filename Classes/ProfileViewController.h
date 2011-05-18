//
//  ProfileViewController.h
//  FlickrJuice
//
//  Created by Michael Rabin on 11/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ProfileViewController : TTTableViewController {

	NSString *_uid;
	
}

@property (nonatomic, retain) NSString *uid;

-(id) initWithUserId:(NSString *) uid;

@end
