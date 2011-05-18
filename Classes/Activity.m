//
//  Activity.m
//  BirthdayChecker
//
//  Created by Michael Rabin on 11/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Activity.h"


@implementation Activity

@synthesize events=_events;

-(void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject:_events forKey:@"events"];
}

-(id)initWithCoder:(NSCoder *)decoder {
	self.events = [decoder decodeObjectForKey:@"events"];
	return self;
}



@end
