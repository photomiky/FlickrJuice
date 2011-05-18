//
//  FlickrContactsModel.h
//  FlickrJuice2
//
//  Created by Michael Rabin on 6/04/11.
//  Copyright 2011 AppHouse. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FlickrContactsModel : TTURLRequestModel {

	NSArray *_contacts;
}
@property (nonatomic, retain) NSArray *contacts;

- (void)fakeLoadedTime;
-(NSString *) contactsKey;
@end
