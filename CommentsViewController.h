//
//  CommentsViewController.h
//  FlickrJuice
//
//  Created by Michael Rabin on 3/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddCommentViewController.h"

@interface CommentsViewController : TTTableViewController{

	NSString *_photoId;
	BOOL newComment;
}

@property (nonatomic, retain) NSString *photoId;

-(id) initWithPhotoId:(NSString *) photoId;
-(void) compose;
-(void)postedFromController:(AddCommentViewController *)controller;

@end
