//
//  MockDatasource.m
//  FlickrJuice2
//
//  Created by Michael Rabin on 17/05/11.
//  Copyright 2011 AppHouse. All rights reserved.
//

#import "MockDatasource.h"
#import "UserPhotosViewController.h"

@implementation MockDatasource


-(id) init{
	
    
	if(self = [super init]){
      
        _mockModel = [[MockModel alloc] init];
        
				
	}
	
	return self;
}

- (id<TTModel>)model {
	return _mockModel;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {

	TT_RELEASE_SAFELY(_mockModel);
	[super dealloc];
}

- (void)tableViewDidLoadModel:(UITableView*)tableView{

    NSLog(@"tableViewDidLoadModel called");
//    NSMutableArray *tmpItems = [[NSMutableArray alloc] init];
//    TTTableSubtextItem *item = [TTTableSubtextItem itemWithText:@"stam"];
//    [tmpItems addObject:item];
//    self.items = tmpItems;
    


    UserPhotosViewController *userPhotosViewController = [[UserPhotosViewController alloc] init];
    TTTableViewItem *viewItem = [TTTableViewItem itemWithCaption:@"dd" view:userPhotosViewController.view];
    //[tableViewCell addSubview:userPhotosViewController.view];
    //[tableViewCell setFrame:CGRectMake(0, 0, 320, 416)];
    TTDASSERT(viewItem != nil);
    
    [self.items addObject:viewItem];
     //[tableViewCell release];
    
}

- (Class)tableView:(UITableView*)tableView cellClassForObject:(id) object {   
	
   
        return [super tableView:tableView cellClassForObject:object];  

}  

- (void)tableView:(UITableView*)tableView prepareCell:(UITableViewCell*)cell  
forRowAtIndexPath:(NSIndexPath*)indexPath {  
    cell.accessoryType = UITableViewCellAccessoryNone;  
}

@end
