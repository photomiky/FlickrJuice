//
//  ContactsDataSource.m
//  FlickrJuice2
//
//  Created by Michael Rabin on 6/04/11.
//  Copyright 2011 AppHouse. All rights reserved.
//

#import "ContactsDataSource.h"
#import "Person.h"

@implementation ContactsDataSource
@synthesize allItems=_allItems,controller=_controller,searchText=_searchText;

-(id) init{
	
	
	if(self = [super init]){
		
		_contactsModel = [[FlickrContactsModel alloc] init];
		
	}
	
	return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
	TT_RELEASE_SAFELY(_contactsModel);
	TT_RELEASE_SAFELY(_allItems);
	//TT_RELEASE_SAFELY(_controller);
	//TT_RELEASE_SAFELY(_searchText);
	[super dealloc];
}

- (void)tableViewDidLoadModel:(UITableView*)tableView {
	
	NSLog(@"Search text is %@", self.searchText);
	self.items = [NSMutableArray array];
	for (Person* p in _contactsModel.contacts) {
		if(self.searchText){

			NSRange range1 = [p.userName rangeOfString:self.searchText options:NSCaseInsensitiveSearch];
			//NSRange range2 = [p.location rangeOfString:self.searchText options:NSCaseInsensitiveSearch];
			if (range1.length > 0) { // || range2.length >0
				[self addPersonToList:p];
			}
			
			
		}else {
			[self addPersonToList:p];
		}

	
	
	}

	NSLog(@"setting %d items", self.items.count);
	if (!self.searchText) {
		self.allItems = self.items;
	}
	
}

-(void) addPersonToList:(Person *)p{
	
	NSString *userNameEscaped = [p.userName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString *path = [NSString stringWithFormat:@"ff://usersPhotosThumbs/%@/%@", p.nsid, userNameEscaped];
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	NSNumber *iconServerVal = [formatter numberFromString:p.iconServer];
	[formatter release];
	NSString *buddyIconUrl = nil;
	if([iconServerVal intValue] > 0){
		buddyIconUrl = [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/buddyicons/%@.jpg", p.iconFarm, p.iconServer, p.nsid];
	}else {
		buddyIconUrl = @"http://www.flickr.com/images/buddyicon.jpg";
	}
	
	TTTableSubtitleItem *tttsi = [TTTableSubtitleItem itemWithText:p.userName subtitle:p.location imageURL:buddyIconUrl URL:path];
	[_items addObject:tttsi];		
	
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<TTModel>)model {
	return _contactsModel;
}


- (NSString*)titleForEmpty {
	return nil;
	//	return NSLocalizedString(@"No Friends Found.", @"Facebook friend no results");
}

- (NSString *)subtitleForEmpty {
	return nil;
}

- (UIImage *)imageForEmpty {
	return nil;
}

- (NSString*)titleForLoading:(BOOL)reloading {
	return @"Loading Contacts";
}

- (NSString*)titleForNoData {
	return @"No contacts found";
}

- (void)filterItems:(NSString *)searchText {
	NSMutableArray* items = [[NSMutableArray alloc] initWithCapacity:self.items.count];
	
	for (TTTableSubtitleItem *item in self.allItems) {
		NSRange range = [item.text rangeOfString:searchText];
		if (range.length > 0 ) {
			[items addObject:item];
		}
	}
	NSLog(@"matching items: %d", items.count);
	self.items = items;
	TT_RELEASE_SAFELY(items);	
}

- (void)search:(NSString*)text {
	NSLog(@"search called. text=%@", text);	
	[self cancel];
	self.searchText = text;
	[self.model performSelector:@selector(fakeLoadedTime)];
}



@end
