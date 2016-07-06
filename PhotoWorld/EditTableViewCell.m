//
//  EditTableViewCell.m
//  PhotoWorld
//
//  Created by Paul on 05.07.16.
//  Copyright © 2016 Paul. All rights reserved.
//

#import "EditTableViewCell.h"

@implementation EditTableViewCell

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
                                       _avatarImage.image = image;
                                       _avatarImage.layer.cornerRadius = _avatarImage.frame.size.width/2;
                                       _avatarImage.clipsToBounds = YES;
                                   });
                               }
                           }];
}

- (void)setUseravatar {
    _avatarImage.image = [WebServiceManager sharedInstance].userAvatarImage;
    _avatarImage.layer.cornerRadius = _avatarImage.frame.size.width/2;
    _avatarImage.clipsToBounds = YES;
}

- (void)setUserDataWithName {
    NSDictionary *dict = [WebServiceManager sharedInstance].userDataDictionary;
    _userNick.text = [dict valueForKeyPath:@"data.username"];
    _userFullName.text = [dict valueForKeyPath:@"data.full_name"];
    _userBio.text = [dict valueForKeyPath:@"data.bio"];
}
@end
