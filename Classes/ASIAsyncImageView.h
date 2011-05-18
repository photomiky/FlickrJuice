//
//  ASIAsyncImageView.h
//  JukeBook
//
//  Created by Michael Rabin on 11/05/11.
//  Copyright 2011 AppHouse. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol IconDownloaderDelegate;

@interface ASIAsyncImageView : UIImageView {
    
    id<IconDownloaderDelegate> _delegate;
    NSNumber *index;
    UIImage *_theImage;
    NSString *_urlStr;
}

@property (nonatomic, retain) NSNumber *index;;
@property (nonatomic, retain) NSString *urlStr;
@property (nonatomic, assign) id<IconDownloaderDelegate> delegate;



- (void)loadImageFromURL:(NSString *)urlStr;
- (UIImage *) image;

@end

@protocol IconDownloaderDelegate 

- (void)appImageDidLoad:(NSNumber *) idx;

@end