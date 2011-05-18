//
//  Person.m
//  FlickrJuice
//
//  Created by Michael Rabin on 11/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Person.h"


@implementation Person
@synthesize nsid=_nsid, iconServer=_iconServer, iconFarm=_iconFarm, userName=_userName, realName=_realName, location=_location, photoCount=_photoCount;

-(void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject:_nsid forKey:@"nsid"];
	[encoder encodeObject:_iconServer forKey:@"iconserver"];
	[encoder encodeObject:_iconFarm forKey:@"iconfarm"];
	[encoder encodeObject:_userName forKey:@"username"];
	[encoder encodeObject:_realName forKey:@"realname"];
	[encoder encodeObject:_location forKey:@"location"];
	[encoder encodeObject:_photoCount forKey:@"photocount"];
	
}

-(id)initWithCoder:(NSCoder *)decoder {
	self.nsid = [decoder decodeObjectForKey:@"nsid"];
	self.iconServer = [decoder decodeObjectForKey:@"iconserver"];
	self.iconFarm = [decoder decodeObjectForKey:@"iconfarm"];
	self.userName = [decoder decodeObjectForKey:@"username"];
	self.realName = [decoder decodeObjectForKey:@"realname"];
	self.location = [decoder decodeObjectForKey:@"location"];
	self.photoCount = [decoder decodeObjectForKey:@"photocount"];
	
	return self;
}
@end
