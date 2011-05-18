//
//  ContactsDataSource.h
//  FlickrJuice2
//
//  Created by Michael Rabin on 6/04/11.
//  Copyright 2011 AppHouse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlickrContactsModel.h"
#import "Person.h"

@interface ContactsDataSource : TTListDataSource {
	
	FlickrContactsModel *_contactsModel;
	TTModelViewController *_controller;
	NSString *_searchText;
	NSArray *_allItems;
}

@property (nonatomic, retain) NSArray *allItems;
@property (nonatomic, retain) TTModelViewController *controller;
@property (nonatomic, retain) NSString *searchText;


- (void)addPersonToList:(Person *) p;
- (void)filterItems:(NSString *)searchText;


@end
