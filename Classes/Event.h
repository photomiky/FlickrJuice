//
//  Event.h
//  BirthdayChecker
//
//  Created by Michael Rabin on 11/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Event : NSObject {
	
	NSString *_type;
	NSString *_userId;
	NSString *_userName;
	NSString *_dateAdded;
	NSString *_content;
	

}

@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *userId;
@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) NSString *dateAdded;


@end
