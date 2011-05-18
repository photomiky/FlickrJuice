//
//  CommentsDataSource.m
//  FlickrJuice
//
//  Created by Michael Rabin on 3/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CommentsDataSource.h"
#import "CommentsTableModel.h"
#import "FFComment.h"

@implementation CommentsDataSource


-(id) initWithPhotoId:(NSString *) photoId{
	
	
	if(self = [super init]){
		
		_commentsTableModel = [[CommentsTableModel alloc] init];
		_commentsTableModel.objectId = photoId;
	}
	
	return self;
}	
	

-(id) init{
	
	
	if(self = [super init]){
		
		_commentsTableModel = [[CommentsTableModel alloc] init];
		
	}
	
	return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
	TT_RELEASE_SAFELY(_commentsTableModel);
	[super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<TTModel>)model {
	return _commentsTableModel;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableViewDidLoadModel:(UITableView*)tableView {
	NSMutableArray* items = [[NSMutableArray alloc] init];
	
	for (FFComment* comment in _commentsTableModel.comments) {
			
		/*NSString *userNameEscaped = [comment.authorName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		NSString *path = [NSString stringWithFormat:@"ff://usersPhotosThumbs/%@/%@", comment.author, userNameEscaped];
		NSString *pathToThumbs = [NSString stringWithFormat:@"<a href=\"%@\">%@</a> wrote: %@<br>", path, comment.authorName, comment.comment];
		TTStyledText *styledText = [TTStyledText textFromXHTML:[NSString stringWithString:pathToThumbs] lineBreaks:YES URLs:YES];	
		NSLog(pathToThumbs);
		TTTableStyledTextItem *textItem = [TTTableStyledTextItem itemWithText:styledText];*/
		
		NSString *buddyIconUrl = nil;
		
		if([comment.iconFarm intValue] > 0){
			
			buddyIconUrl = [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/buddyicons/%@.jpg", comment.iconFarm, comment.iconServer, comment.author];
		}else {
			
			buddyIconUrl = @"http://www.flickr.com/images/buddyicon.jpg";
		
		}

		NSString *userNameEscaped = [comment.authorName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		NSString *path = [NSString stringWithFormat:@"ff://usersPhotosThumbs/%@/%@", comment.author, userNameEscaped];
		TTTableSubtitleItem *item = [TTTableSubtitleItem itemWithText:[NSString stringWithFormat:@"%@ wrote:", comment.authorName] subtitle:comment.comment imageURL:buddyIconUrl URL:path];
		
		
		[items addObject:item];
	}
	NSLog(@"setting items to: %@", items);
	self.items = items;
	TT_RELEASE_SAFELY(items);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)titleForLoading:(BOOL)reloading {
	if (reloading) {
		return NSLocalizedString(@"Updating Comments...", @"Flickr feed updating text");
	} else {
		return NSLocalizedString(@"Loading Comments...", @"Flickr feed loading text");
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)titleForEmpty {
	return NSLocalizedString(@"No Comments Found.", @"Flickr feed no results");
}




///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)subtitleForError:(NSError*)error {
	
	return [error localizedDescription];
	
}

- (void)styledTextNeedsDisplay:(TTStyledText*)text {
	NSLog(@"Styled text needs display: %@", text);
}

- (void)tableView:(UITableView*)tableView prepareCell:(UITableViewCell*)cell
forRowAtIndexPath:(NSIndexPath*)indexPath {
	cell.accessoryType = UITableViewCellAccessoryNone;
}

// add comment to ds
- (void)addComment:(FFComment *)comment {
	//CommentTableItem *item = [self createItemForComment:comment];
	[self.items addObject:comment];
}


@end
