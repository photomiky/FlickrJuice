//
//  FlickrMessagesModel.h
//  FlickrJuice
//
//  Created by Michael Rabin on 12/8/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FlickrMessagesModel : TTURLRequestModel {
	
	
	NSArray *_messages;
	
}

@property (nonatomic, retain) NSArray *messages;

@end
