//
//  UserCollectionViewCell.m
//  PhotoWorld
//
//  Created by Paul on 23.06.16.
//  Copyright © 2016 Paul. All rights reserved.
//

#import "UserCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation UserCollectionViewCell
//
//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        self.backgroundColor = [UIColor whiteColor];
//    }
//    return self;
//}

- (void) setMyImageForKey: (NSUInteger)key {
    UIImage *image = [[UIImage alloc] init];
    image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:[NSString stringWithFormat:@"Item-%lu", (unsigned long)key]];
    if (image == NULL) {
        image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:[NSString stringWithFormat:@"Item-%lu", (unsigned long)key]];
    }
//    NSLog(@"%@", image);
    userImage.image = image;
}
@end
