//
//  UserHeaderCollectionReusableView.m
//  PhotoWorld
//
//  Created by Paul on 27.06.16.
//  Copyright © 2016 Paul. All rights reserved.
//

#import "UserHeaderCollectionReusableView.h"
#import "UserCollectionViewCell.h"
#import "UserInfoViewController.h"
static NSString *CellIdentifier = @"userView";
static NSString *headerIdentifier = @"userHeader";

@implementation UserHeaderCollectionReusableView

- (void) setDataBio: (NSString *)bio setFullName: (NSString *)fullName setMedia:(NSInteger)media setFollows:(NSInteger)follows setFoolowedBy: (NSInteger)followedBy {
    _bio.text = bio;
    _fullName.text = fullName;
    _media.text = [NSString stringWithFormat:@"%ld", (long)media];
    _follows.text = [NSString stringWithFormat:@"%ld", (long)followedBy];
    _followedBy.text = [NSString stringWithFormat:@"%ld",  (long)follows]; // people, user peffear
}

- (void)setButtonCorners {
    _redactionButton.layer.cornerRadius = 7.0f;
    _redactionButton.clipsToBounds = YES;
}

- (void)setFirstButtonTapped {
    [_firstButton setTintColor:[UIColor blueColor]];
    [_secondButton setTintColor:[UIColor lightGrayColor]];
    [_thirdButton setTintColor:[UIColor lightGrayColor]];
    [_fouthButton setTintColor:[UIColor lightGrayColor]];
}

- (void)avatarAppear {
    if ([WebServiceManager sharedInstance].userAvatarImage != nil) {
        _avatar.image = [WebServiceManager sharedInstance].userAvatarImage;
        _avatar.layer.cornerRadius = _avatar.frame.size.width/2;
        _avatar.clipsToBounds = YES;
    }
}

- (IBAction)firstButtonTapped:(id)sender {
    [_firstButton setTintColor:[UIColor blueColor]];
    [_secondButton setTintColor:[UIColor lightGrayColor]];
    [_thirdButton setTintColor:[UIColor lightGrayColor]];
    [_fouthButton setTintColor:[UIColor lightGrayColor]];
     }
- (IBAction)secondButtonTapped:(id)sender {
    [_firstButton setTintColor:[UIColor lightGrayColor]];
    [_secondButton setTintColor:[UIColor blueColor]];
    [_thirdButton setTintColor:[UIColor lightGrayColor]];
    [_fouthButton setTintColor:[UIColor lightGrayColor]];
}

- (IBAction)thirdButtonAction:(id)sender {

}

- (IBAction)fouthButtonTapped:(id)sender {
    [_firstButton setTintColor:[UIColor lightGrayColor]];
    [_secondButton setTintColor:[UIColor lightGrayColor]];
    [_thirdButton setTintColor:[UIColor lightGrayColor]];
    [_fouthButton setTintColor:[UIColor blueColor]];
}
@end
