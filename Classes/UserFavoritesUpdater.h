//
//  UserFavoritesUpdater.h
//  FlickrJuice2
//
//  Created by Michael Rabin on 10/04/11.
//  Copyright 2011 AppHouse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjectiveFlickr.h"

@interface UserFavoritesUpdater : NSObject <OFFlickrAPIRequestDelegate>{
	
	NSMutableDictionary *_favedImageIds;
	OFFlickrAPIRequest *_flickr;
}

@property (nonatomic, retain) NSMutableDictionary *favedImageIds;
@property (nonatomic, retain) OFFlickrAPIRequest *flickr;	

-(void) downloadUserFaves;
-(BOOL) isFavedImage:(NSString *) key;
-(void) addFavedImageWithKey:(NSString *) key;
@end
