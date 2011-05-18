//
//  Event.m
//  BirthdayChecker
//
//  Created by Michael Rabin on 11/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Event.h"


@implementation Event

//NSString *_type;
//NSString *_userId;
//NSString *_userName;
//NSDate *_dateAdded;
//NSString *_content;
//

@synthesize type=_type, userId=_userId, userName=_userName, dateAdded=_dateAdded, content=_content;

-(void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject:_type forKey:@"type"];
	[encoder encodeObject:_userId forKey:@"userId"];
	[encoder encodeObject:_userName forKey:@"userName"];
	[encoder encodeObject:_dateAdded forKey:@"dateAdded"];
	[encoder encodeObject:_content forKey:@"content"];
	
}

-(id)initWithCoder:(NSCoder *)decoder {
	self.type = [decoder decodeObjectForKey:@"type"];
	self.userId = [decoder decodeObjectForKey:@"userId"];
	self.userName = [decoder decodeObjectForKey:@"userName"];
	self.dateAdded = [decoder decodeObjectForKey:@"dateAdded"];
	self.content = [decoder decodeObjectForKey:@"content"];
	return self;
}



@end
