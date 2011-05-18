//
//  ActivityTableItemCell.h
//  FlickrJuice
//
//  Created by Michael Rabin on 11/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActivityTableItem.h"

@interface ActivityTableItemCell : TTTableSubtitleItemCell{

	TTImageView *_imgView;
	TTStyledTextLabel *_styledTextLabel;
	NSString *_link;
}

@property (nonatomic, retain) NSString *link;

- (UIButton *) makeDetailDisclosureButton:(ActivityTableItem *)object;

-(void) navigateToPicture;
@end
