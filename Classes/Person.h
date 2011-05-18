//
//  Person.h
//  FlickrJuice
//
//  Created by Michael Rabin on 11/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Person : NSObject {

	NSString *_nsid;
	BOOL isPro;
	NSString *_iconServer;
	NSString *_iconFarm;
	NSString *_userName;
	NSString *_realName;
	NSString *_location;
	NSNumber *_photoCount;
	
	
}

@property (nonatomic, retain) NSString *nsid;
@property (nonatomic, retain) NSString *iconServer;
@property (nonatomic, retain) NSString *iconFarm;
@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSString *realName;
@property (nonatomic, retain) NSString *location;
@property (nonatomic, retain) NSNumber *photoCount;




@end
