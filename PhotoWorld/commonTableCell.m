//
//  commonTableCell.m
//  PhotoWorld
//
//  Created by Paul on 04.07.16.
//  Copyright © 2016 Paul. All rights reserved.
//

#import "commonTableCell.h"

@implementation commonTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)dowloadAvatarWithUrl: (NSString *)url {
    SDWebImageDownloader *downloader = [SDWebImageDownloader sharedDownloader];
    NSURL *url1 = [NSURL URLWithString:url];
    [downloader downloadImageWithURL: url1
                             options:0
                            progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                            }
                           completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                               if (image && finished) {
                                   dispatch_async(dispatch_get_main_queue(),  ^{
                                       _userAvatar.image = image;
                                       _userAvatar.layer.cornerRadius = _userAvatar.frame.size.width/2;
                                       _userAvatar.clipsToBounds = YES;
                                   });
                               }
                           }];
}
@end
