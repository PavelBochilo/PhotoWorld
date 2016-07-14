//
//  UserGeoCollectionReusableView.m
//  PhotoWorld
//
//  Created by Paul on 14.07.16.
//  Copyright © 2016 Paul. All rights reserved.
//

#import "UserGeoCollectionReusableView.h"

@implementation UserGeoCollectionReusableView

- (void)setNumberOfPublications {
    _publicationOutlet.text = [NSString stringWithFormat:@"%lu publications", [WebServiceManager sharedInstance].userStandartPhotoUrlArray.count];
}
@end
