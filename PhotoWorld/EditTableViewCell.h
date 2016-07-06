//
//  EditTableViewCell.h
//  PhotoWorld
//
//  Created by Paul on 05.07.16.
//  Copyright © 2016 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "WebServiceManager.h"

@interface EditTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *avatarImage;
@property (strong, nonatomic) IBOutlet UILabel *userFullName;
@property (strong, nonatomic) IBOutlet UILabel *userNick;
@property (strong, nonatomic) IBOutlet UILabel *userBio;
- (void)dowloadAvatarWithUrl: (NSString *)url;
- (void)setUseravatar;
- (void)setUserDataWithName;
@end
