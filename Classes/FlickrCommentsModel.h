//
//  FlickrCommentsModel.h
//  BirthdayChecker
//
//  Created by Michael Rabin on 11/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"

@interface FlickrCommentsModel : TTURLRequestModel{

	NSMutableArray* _mutableComments;
	NSArray*  _comments;
	NSString *_currElement;
	Event *_currEvent;
	TTURLRequest *_ttReq;
}

@property (nonatomic, retain) NSArray* comments;
@property (nonatomic, retain) NSMutableArray *mutableComments;
@property (nonatomic, retain) Event *currEvent;
@property (nonatomic, retain) NSString *currElement;
@property (nonatomic, retain) TTURLRequest *ttReq;


-(NSString *) commentsKey;


@end
