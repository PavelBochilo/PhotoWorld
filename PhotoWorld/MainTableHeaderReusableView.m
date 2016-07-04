//
//  MainTableHeaderReusableView.m
//  PhotoWorld
//
//  Created by Paul on 29.06.16.
//  Copyright © 2016 Paul. All rights reserved.
//

#import "MainTableHeaderReusableView.h"
#import "UserInfoViewController.h"

@implementation MainTableHeaderReusableView

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

- (void)avatarAppear {
    _avatarImage.image = [WebServiceManager sharedInstance].userAvatarImage;
    _avatarImage.layer.cornerRadius = _avatarImage.frame.size.width/2;
    _avatarImage.clipsToBounds = YES;
}

-(void)setUserNameLabelWithName: (NSString *)name {
    _userNameLabel.text = name;
}
@end
