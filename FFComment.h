//
//  FFComment.h
//  FlickrJuice
//
//  Created by Michael Rabin on 3/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FFComment : NSObject {
	
	
	NSString *_uid;
	NSString *_author;
	NSString *_authorName;
	NSDate *_dateCreate;
	NSString *_permaLink;
	NSString *_comment;
	NSString *_iconFarm;
	NSString *_iconServer;
	
}


@property (nonatomic, retain) NSString *uid;
@property (nonatomic, retain) NSString *author;
@property (nonatomic, retain) NSString *authorName;
@property (nonatomic, retain) NSDate   *dateCreate;
@property (nonatomic, retain) NSString *comment;
@property (nonatomic, retain) NSString *permaLink;
@property (nonatomic, retain) NSString *iconFarm;
@property (nonatomic, retain) NSString *iconServer;


@end
