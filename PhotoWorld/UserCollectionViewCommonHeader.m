//
//  UserCollectionViewCommonHeader.m
//  PhotoWorld
//
//  Created by Paul on 06.07.16.
//  Copyright © 2016 Paul. All rights reserved.
//

#import "UserCollectionViewCommonHeader.h"

@implementation UserCollectionViewCommonHeader

- (void)avatarAppear {
    _userAvatar.image = [WebServiceManager sharedInstance].userAvatarImage;
    _userAvatar.layer.cornerRadius = _userAvatar.frame.size.width/2;
    _userAvatar.clipsToBounds = YES;
}

-(void)setUserNameLabelWithName: (NSString *)name {
    _userName.text = name;
}

@end
