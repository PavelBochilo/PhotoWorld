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
- (void)avatarAppear {
    if ([WebServiceManager sharedInstance].userAvatarImage != nil) {
        _avatarImage.image = [WebServiceManager sharedInstance].userAvatarImage;
        _avatarImage.layer.cornerRadius = _avatarImage.frame.size.width/2;
        _avatarImage.clipsToBounds = YES;
    }
}

//- (IBAction)profileButton:(id)sender {
//    //userProfile
//    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main"
//                                                         bundle:nil];
//    UserInfoViewController *add =
//    [storyboard instantiateViewControllerWithIdentifier:@"userProfile"];
//    UINavigationController *navCntrlr = [[UINavigationController alloc] initWithRootViewController:add];
//    
//    [navCntrlr pushViewController:add  animated:YES];
//}


@end
