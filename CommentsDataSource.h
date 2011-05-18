//
//  CommentsDataSource.h
//  FlickrJuice
//
//  Created by Michael Rabin on 3/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommentsTableModel.h"
#import "FFComment.h"

@interface CommentsDataSource : TTListDataSource <TTStyledTextDelegate> {
	
	CommentsTableModel *_commentsTableModel;
	
}


-(id) initWithPhotoId:(NSString *) photoId;
- (void)addComment:(FFComment *)comment;
@end
