//
//  ProfileViewController.m
//  FlickrJuice
//
//  Created by Michael Rabin on 11/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ProfileViewController.h"
#import "FlickrUserProfileDataSource.h"

@implementation ProfileViewController

@synthesize uid=_uid;

-(id) initWithUserId:(NSString *) uid{
	
		
	if(self = [super init]){
		
		self.uid = uid;
		
	}
			    
	return self;
	
	
}

- (id<UITableViewDelegate>)createDelegate {
	return [[[TTTableViewDragRefreshDelegate alloc] initWithController:self] autorelease];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)createModel {
	
	
	self.dataSource = [[[FlickrUserProfileDataSource alloc]
						initWithUserId:self.uid] autorelease];
}








@end
