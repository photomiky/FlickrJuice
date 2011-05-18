//
//  UserComment.m
//  BirthdayChecker
//
//  Created by Michael Rabin on 11/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UserComment.h"


@implementation UserComment


@synthesize type=_type, itemId=_itemId, owner=_owner, secret=_secret, server=_server, commentsCount=_commentsCount, title=_title, activity=_activity, farm=_farm;

@synthesize viewsCount=_viewsCount, favsCount=_favsCount;

-(void)encodeWithCoder:(NSCoder *)encoder {
	[encoder encodeObject:_type forKey:@"type"];
	[encoder encodeObject:_itemId forKey:@"item_id"];
	[encoder encodeObject:_owner forKey:@"owner"];
	[encoder encodeObject:_secret forKey:@"secret"];
	[encoder encodeObject:_server forKey:@"server"];
	[encoder encodeObject:_commentsCount forKey:@"commentsCount"];
	[encoder encodeObject:_title forKey:@"title"];
	[encoder encodeObject:_activity forKey:@"activity"];
	[encoder encodeObject:_farm forKey:@"farm"];
	[encoder encodeObject:_viewsCount forKey:@"viewsCount"];
	[encoder encodeObject:_favsCount forKey:@"favsCount"];
	
}

-(id)initWithCoder:(NSCoder *)decoder {
	self.type = [decoder decodeObjectForKey:@"type"];
	self.itemId = [decoder decodeObjectForKey:@"item_id"];
	self.owner = [decoder decodeObjectForKey:@"owner"];
	self.secret = [decoder decodeObjectForKey:@"secret"];
	self.server = [decoder decodeObjectForKey:@"server"];
	self.commentsCount = [decoder decodeObjectForKey:@"commentsCount"];
	self.title = [decoder decodeObjectForKey:@"title"];
	self.activity = [decoder decodeObjectForKey:@"activity"];
	self.farm = [decoder decodeObjectForKey:@"farm"];
	self.viewsCount = [decoder decodeObjectForKey:@"viewsCount"];
	self.favsCount = [decoder decodeObjectForKey:@"favsCount"];
	
	return self;
}

- (NSString *)description{
	

	return [NSString stringWithFormat:@"Comments: %@, Faves:%@, Views:%@ ", self.commentsCount, self.favsCount, self.viewsCount];
	
}
@end
