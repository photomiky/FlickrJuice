//
//  ActivityTableItem.h
//  FlickrJuice
//
//  Created by Michael Rabin on 11/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ActivityTableItem : TTTableSubtitleItem {
	
	
	TTStyle *_style;
	NSString *_imgURL;
	TTStyledText *_styledText; 
	NSString *_linkStr;
}


@property (nonatomic, retain) TTStyle *style;
@property (nonatomic, retain) NSString *imgURL;
@property (nonatomic, retain) TTStyledText *styledText;
@property (nonatomic, retain) NSString *linkStr;

+ (id)itemWithText:(NSString *)text caption:(NSString *)caption image:(NSString *)image styledText:(NSString *) styledText;
+ (id)itemWithText:(NSString*)text subtitle:(NSString*)subtitle imageURL:(NSString*)imageURL
      defaultImage:(UIImage*)defaultImage URL:(NSString*)URL accessoryURL:(NSString*)accessoryURL styledText:(TTStyledText *)styledText linkString:(NSString *)linkStr;


@end
