//
//  CommentsTableModel.h
//  FlickrJuice
//
//  Created by Michael Rabin on 3/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CommentsTableModel : TTURLRequestModel {
	
	NSArray *_comments;
	NSString *_objectId;
}

@property (nonatomic, retain) NSArray *comments;
@property (nonatomic, retain) NSString *objectId;

-(id) initWithPhotoId:(NSString *) photoId;


@end
