//
//  ActivityTableItem.m
//  FlickrJuice
//
//  Created by Michael Rabin on 11/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ActivityTableItem.h"


@implementation ActivityTableItem

@synthesize style=_style, styledText=_styledText, imgURL=_imgURL, linkStr=_linkStr;

+ (id)itemWithText:(NSString *)text caption:(NSString *)caption image:(NSString *)image styledText:(TTStyledText *) styledText{
	
	ActivityTableItem *item = [[[self alloc] init] autorelease];
	item.text = text;  
	item.subtitle = caption;  
	item.imageURL = nil;
	item.imgURL = image;
	item.styledText = styledText;
	return item;  

}

+ (id)itemWithText:(NSString*)text subtitle:(NSString*)subtitle imageURL:(NSString*)imageURL
      defaultImage:(UIImage*)defaultImage URL:(NSString*)URL accessoryURL:(NSString*)accessoryURL styledText:(TTStyledText *)styledText linkString:(NSString *)linkStr{

	ActivityTableItem *item = [[[self alloc] init] autorelease];
	item.text = text;
	item.subtitle = subtitle;  
	item.imageURL = nil;
	item.imgURL = imageURL;
	item.styledText = styledText;
	item.defaultImage = defaultImage;
	item.URL = URL;
	item.accessoryURL = accessoryURL;
	item.linkStr = linkStr;
	return item;  
	
}

- (id)init {  
    if (self = [super init]) {  
		_styledText = nil;
		_imgURL = nil;
        _style = nil;
    }  
    return self;  
}  

- (void)dealloc {  

    TT_RELEASE_SAFELY(_style);
	 TT_RELEASE_SAFELY(_styledText);
	 TT_RELEASE_SAFELY(_imgURL);
    [super dealloc];  
}  


///////////////////////////////////////////////////////////////////////////////////////////////////  
// NSCoding  

- (id)initWithCoder:(NSCoder*)decoder {  
    self = [super initWithCoder:decoder];
    if (self) {  
        self.imgURL = [decoder decodeObjectForKey:@"image"];  
		self.styledText = [decoder decodeObjectForKey:@"styledText"];
    }  
    return self;  
}  

- (void)encodeWithCoder:(NSCoder*)encoder {  
    [super encodeWithCoder:encoder];  
    if (self.imgURL) {  
        [encoder encodeObject:self.imgURL forKey:@"image"];  
    }  
	if (self.styledText){
		[encoder encodeObject:self.styledText forKey:@"styledText"];
	}
}  


@end
