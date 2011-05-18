//
//  UserPhotosThumbsViewController.m
//  FlickrJuice2
//
//  Created by Michael Rabin on 17/05/11.
//  Copyright 2011 AppHouse. All rights reserved.
//

#import "UserPhotosThumbsViewController.h"
#import "MockDatasource.h"

@implementation UserPhotosThumbsViewController

-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        
        
       // _viewController = [[UserPhotosViewController alloc] initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
        
        
    }
    
    return self;
}

-(void) createModel{
    
    NSLog(@"Create model called");
    
    self.dataSource = [[MockDatasource alloc] init];
}


- (id<UITableViewDelegate>)createDelegate {
	return [[[TTTableViewDragRefreshDelegate alloc] initWithController:self] autorelease];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 416;
}

@end
