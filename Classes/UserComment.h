//
//  UserComment.h
//  BirthdayChecker
//
//  Created by Michael Rabin on 11/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Activity.h"


@interface UserComment : NSObject {

	NSString *_type; 
	NSString *_itemId;
	NSString *_owner;
	NSString *_secret;
	NSString *_server;
	NSNumber *_commentsCount;
	NSString *_title;
	NSString *_farm;
	Activity *_activity;
	NSString *_favsCount;
	NSString *_viewsCount;
	
	
	
}

@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *itemId;
@property (nonatomic, retain) NSString *owner;
@property (nonatomic, retain) NSString *secret;
@property (nonatomic, retain) NSString *server;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *favsCount;
@property (nonatomic, retain) NSString *viewsCount;

@property (nonatomic, retain) NSString *farm;

@property (nonatomic, retain) Activity *activity;
@property (nonatomic, retain) NSNumber *commentsCount;

@end
