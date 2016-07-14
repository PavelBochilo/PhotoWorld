//
//  UserCollectionViewCell.h
//  PhotoWorld
//
//  Created by Paul on 23.06.16.
//  Copyright © 2016 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceManager.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface UserCollectionViewCell : UICollectionViewCell {
    IBOutlet UIImageView *userImage;
    IBOutlet UIImageView *userGeoImage;
}
- (void) setMyImageForKey: (NSUInteger)key;
- (void)dowloadUserStandartResolutionPhotoWithUrl: (NSString *)url;
- (void) setMyGeoImageForKey: (NSUInteger)key;
@end
