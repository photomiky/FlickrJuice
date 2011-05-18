//
//  MockDatasource.h
//  FlickrJuice2
//
//  Created by Michael Rabin on 17/05/11.
//  Copyright 2011 AppHouse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Three20/Three20.h"
#import "MockModel.h"

@interface MockDatasource : TTListDataSource {
    
    MockModel *_mockModel;
}

@end
