//
//  UploadImage.h
//  FlickrJuice2
//
//  Created by Michael Rabin on 20/04/11.
//  Copyright 2011 AppHouse. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UploadImage : NSObject {
	
	NSData *_imageData;
	NSDictionary *_dict;
	
}

@property (nonatomic, retain) NSData *imageData;
@property (nonatomic, retain) NSDictionary *dict;


@end
