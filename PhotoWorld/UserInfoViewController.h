//
//  UserInfoViewController.h
//  PhotoWorld
//
//  Created by Paul on 20.06.16.
//  Copyright © 2016 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "AppDelegate.h"

@interface UserInfoViewController : UIViewController <NSURLSessionDelegate, NSURLSessionDataDelegate>

@property (strong, nonatomic) NSDictionary *userDataDictionary;
@property (weak, nonatomic) IBOutlet UIImageView *userAvatar;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
- (void) downloadAndLoadAvatar;
@property (nonatomic, assign) BOOL wasLoaded;

@end
