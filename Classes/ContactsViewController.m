//
//  ContactsViewController.m
//  FlickrJuice2
//
//  Created by Michael Rabin on 5/04/11.
//  Copyright 2011 AppHouse. All rights reserved.
//

#import "ContactsViewController.h"
#import "ContactsDataSource.h"
#import <Three20UI/UIViewAdditions.h>
@implementation ContactsViewController


-(void) viewDidLoad{
	
		
	UIImage *image = [UIImage imageNamed: @"nav_bar_bg.png"]; 
	self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:image] autorelease]; 
	
	// add search bar 
	TTTableViewController* searchController = [[[TTTableViewController alloc] init] autorelease];
	ContactsDataSource* ds = [[[ContactsDataSource alloc] init] autorelease];
	searchController.dataSource = ds;
	ds.controller = searchController;
	
	self.searchViewController = searchController;
	self.tableView.tableHeaderView = _searchController.searchBar;
	
	_searchController.searchBar.placeholder = @"type friend's name to search";
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createModel) name:@"UserHasLoggedIn" object:nil];
	
	
	
	[super viewDidLoad];
}

- (void)createModel {
	
	
	self.dataSource = [[[ContactsDataSource alloc]
						init] autorelease];
}

- (id<UITableViewDelegate>)createDelegate {
	return [[[TTTableViewDragRefreshDelegate alloc] initWithController:self] autorelease];
}



@end
