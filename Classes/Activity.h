//
//  Activity.h
//  BirthdayChecker
//
//  Created by Michael Rabin on 11/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Activity : NSObject {
	
	
	NSArray *_events;

}

@property (nonatomic, retain) NSArray *events;


@end
