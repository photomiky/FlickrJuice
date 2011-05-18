//
//  PhotoSource.h
//  BirthdayChecker
//
//  Created by Michael Rabin on 11/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


#import <Three20/Three20+Additions.h>

typedef enum {  
	PhotoSourceNormal = 0,  
	PhotoSourceDelayed = 1,  
	PhotoSourceVariableCount = 2,  
	PhotoSourceLoadError = 4,  
} PhotoSourceType;  

@interface PhotoSource : TTURLRequestModel <TTPhotoSource> {  
	PhotoSourceType _type;  
	NSString* _title;  
	NSMutableArray* _photos;  
	NSArray* _tempPhotos;  
	NSTimer* _fakeLoadTimer;  
}  

- (id)initWithType:(PhotoSourceType)type title:(NSString*)title  
			photos:(NSArray*)photos photos2:(NSArray*)photos2;  

@end  