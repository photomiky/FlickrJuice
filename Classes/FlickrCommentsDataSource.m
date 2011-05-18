//
//  FlickrCommentsDataSource.m
//  BirthdayChecker
//
//  Created by Michael Rabin on 11/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FlickrCommentsDataSource.h"
#import "UserComment.h"
#import "ActivityTableItem.h"
#import "ActivityTableItemCell.h"
@implementation FlickrCommentsDataSource


-(id) init{
	

	if(self = [super init]){
	
		_commentsModel = [[FlickrCommentsModel alloc] init];
		
	}
	
	return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
	TT_RELEASE_SAFELY(_commentsModel);
	
	[super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<TTModel>)model {
	return _commentsModel;
}

- (void)tableViewDidLoadModel:(UITableView*)tableView {
	NSMutableArray* items = [[NSMutableArray alloc] init];
	[tableView setSeparatorColor:[UIColor whiteColor]];
	UIImageView *bgImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
	//tableView.backgroundView = bgImgView;
	[bgImgView release];
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	//NSString* star = @"bundle://star.png";
	for (UserComment* comment in _commentsModel.comments) {
		// http://farm{id}.static.flickr.com/{server-id}/{id}_{secret}_[mstb].jpg
		// http://www.flickr.com/photos/{user-id}/{photo-id}
		Activity *activity = comment.activity;
		NSArray *events = activity.events;
		NSString *imgUrl_S = [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_t.jpg", comment.farm, comment.server, comment.itemId, comment.secret];
		
		BOOL isFav = NO;
		BOOL firstEvent = YES;
		NSMutableString *aggrComments = [[NSMutableString alloc] init];
		NSNumber *millisSince1970 = nil;
		NSString *lineBreak = @"\n\n";
		for(Event *event in events){
			
			if (firstEvent) {
				firstEvent = NO;
				millisSince1970 = [formatter numberFromString:event.dateAdded];
			}
			
			NSString *userNameEscaped = [event.userName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			if([event.type isEqualToString:@"fave"]){
				
				NSString *path = [NSString stringWithFormat:@"ff://usersPhotosThumbs/%@/%@", event.userId, userNameEscaped];
				NSString *favedStr = [NSString stringWithFormat:@"%@<a href=\"%@\">%@</a> faved your image.<br>", firstEvent ? @"" : lineBreak, path, event.userName];
				//NSString *escapedStr = [favedStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
				//NSLog(@"path to user photos %@", pathToThumbs);
				[aggrComments appendString:favedStr];
				isFav = YES;

			}else {
				if(![event.type isEqualToString:@"comment"]){ 
					event.content = @"other";
				}
				NSString *path = [NSString stringWithFormat:@"ff://usersPhotosThumbs/%@/%@", event.userId, userNameEscaped];
				NSString *commentStr = [NSString stringWithFormat:@"%@<a href=\"%@\">%@:</a> %@ ",firstEvent ? @"" : lineBreak,  path, event.userName, event.content];
				[aggrComments appendString:commentStr];

				
			}
			
			
			
		}
		//TTStyledText *styledText = [TTStyledText textFromXHTML:[NSString stringWithString:aggrComments] lineBreaks:YES URLs:YES];			   
		
		//ActivityTableItem *activityItem = [ActivityTableItem itemWithText:comment.title caption:[NSString stringWithFormat:@"This image has %@ comments, %@ faves and %@ views",comment.commentsCount, comment.favsCount, comment.viewsCount] image:imgUrl_S styledText:styledText];
		// (1) ------------------------
		
		
		NSString *title = comment.title;
		if([title isEqualToString:@""]){
			
			title = @"Untitled";
		}

		NSString *titleEscaped = [title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		NSString *link = [NSString stringWithFormat:@"ff://photopage/%@/%@/%@/%@/%@/%@", comment.itemId, comment.secret, comment.farm, comment.server,comment.owner, titleEscaped];
		//NSLog(@"link is %@", link);
		NSString *imgInfo = [NSString stringWithFormat:@"This image has %@ comments, %@ faves and %@ views",comment.commentsCount, comment.favsCount, comment.viewsCount];
		TTStyledText *styledText = [TTStyledText textFromXHTML:[NSString stringWithString:aggrComments] lineBreaks:YES URLs:YES];			   
		
		ActivityTableItem *activityItem = [ActivityTableItem itemWithText:title subtitle:imgInfo imageURL:imgUrl_S defaultImage:nil URL:nil accessoryURL:nil styledText:styledText linkString:link];
		//TTDASSERT(nil != activityItem);
		[items addObject:activityItem];
		 
		
		

		
		//TTStyledText *styledText = [TTStyledText textFromXHTML:[NSString stringWithString:aggrComments] lineBreaks:YES URLs:YES];			   
		//[NSString stringWithFormat:@"This image has %@ comments, %@ faves and %@ views",comment.commentsCount, comment.favsCount, comment.viewsCount];
		
		// (2) --------
		/*TTTableSubtitleItem *subItem = [TTTableSubtitleItem itemWithText:comment.title 
																subtitle:[NSString stringWithFormat:@"This image has %@ comments, %@ faves and %@ views",comment.commentsCount, comment.favsCount, comment.viewsCount]
															  imageURL:imgUrl_S
																   URL:[NSString stringWithFormat:@"ff://photopage/%@/%@/%@/%@/%@", comment.itemId, comment.secret, comment.farm, comment.server, comment.title]];
		
		TTTableTextItem *linkedItem = [TTTableTextItem itemWithText:aggrComments]; 
		
		TTStyledTextLabel *styledLabel = [[TTStyledTextLabel alloc] init];
		styledLabel.html = aggrComments;
		
		TTDASSERT(nil != subItem);
		[items addObject:subItem];
		//TTDASSERT(nil != styledLabel);
//		[items addObject:styledLabel];
//		
		 */
	
	}
	//
	if ( ( items.count % 15 == 0 ) && ( items.count > 0 ) ) {
		NSString *moreText = [NSString stringWithFormat:@"Load Next %d Albums", 15];
		TTTableMoreButton *more = [TTTableMoreButton itemWithText:moreText subtitle:@"" URL:nil];
		more.isLoading = _commentsModel.isLoading;
		more.model = _commentsModel;
		[items addObject:more];			
	}
	
	
	self.items = items;
	TT_RELEASE_SAFELY(items);
}



- (Class)tableView:(UITableView*)tableView cellClassForObject:(id) object {   
	
    if ([object isKindOfClass:[ActivityTableItem class]]) {  
        return [ActivityTableItemCell class];  
    } else {  
        return [super tableView:tableView cellClassForObject:object];  
    }  
}  

- (void)tableView:(UITableView*)tableView prepareCell:(UITableViewCell*)cell  
forRowAtIndexPath:(NSIndexPath*)indexPath {  
    cell.accessoryType = UITableViewCellAccessoryNone;  
}  


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)titleForLoading:(BOOL)reloading {
	if (reloading) {
		return NSLocalizedString(@"Updating Flickr feed...", @"Flickr feed updating text");
	} else {
		return NSLocalizedString(@"Loading Flickr feed...", @"Flickr feed loading text");
	}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)titleForEmpty {
	return NSLocalizedString(@"No posts found.", @"Go To Interesting tab and start giving users feedback!");
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)subtitleForError:(NSError*)error {
	return NSLocalizedString(@"Sorry, there was an error loading the Flickr! stream.", @"");
}

- (UIImage*)imageForEmpty {
	return TTIMAGE(@"bundle://Three20.bundle/images/empty.png");
}

- (NSString*)subtitleForEmpty {
	return NSLocalizedString(@"You have no comments/favs. You should start being generous and giving people feedback!", @"");
}

@end
