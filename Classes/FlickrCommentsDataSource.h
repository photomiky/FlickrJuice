//
//  FlickrCommentsDataSource.h
//  BirthdayChecker
//
//  Created by Michael Rabin on 11/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlickrCommentsModel.h"
#import <Three20/Three20.h>

@interface FlickrCommentsDataSource : TTListDataSource {

	FlickrCommentsModel *_commentsModel;
	
}



@end
