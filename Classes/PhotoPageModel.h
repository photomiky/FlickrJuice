//
//  PhotoPageModel.h
//  BirthdayChecker
//
//  Created by Michael Rabin on 11/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface PhotoPageModel : TTURLRequestModel {
	
	NSString *_photoId; 
	
	
}

@property (nonatomic, retain) NSString *photoId;


@end
