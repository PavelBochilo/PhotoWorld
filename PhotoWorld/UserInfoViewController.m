//
//  UserInfoViewController.m
//  PhotoWorld
//
//  Created by Paul on 20.06.16.
//  Copyright © 2016 Paul. All rights reserved.
//

#import "UserInfoViewController.h"
#import "WebServiceManager.h"

@interface UserInfoViewController ()

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self indicatorStartLoading];
    [[WebServiceManager sharedInstance] sendPOSTRequestUserInfo:[WebServiceManager sharedInstance].myAccessToken andMyID:[WebServiceManager sharedInstance].mySessionID];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationStartLoadingUserData)
                                                 name:@"userNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationStartLoadingMedia)
                                                 name:@"userMediaNotification"
                                               object:nil];
    
}
- (void) viewWillAppear:(BOOL)animated {
    
}

-(void)viewDidAppear:(BOOL)animated {

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (void) downloadAndLoadAvatar {
    
    NSDictionary *dict = [[WebServiceManager sharedInstance].userDataDictionary objectForKey:@"data"];
    NSString *urlImage = [dict objectForKey:@"profile_picture"];
    NSURL *url = [NSURL URLWithString:urlImage];
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    UIImage *tmpImage = [[UIImage alloc] initWithData:data];
    _userAvatar.image = tmpImage;
    self.navigationItem.title = [dict objectForKey:@"full_name"];
    
    
    //[self setUserData];
}


- (void) setUserData {

}

- (void) indicatorStartLoading {
[_activityIndicator startAnimating];
}

- (void) indicatorStopLoading {
    [_activityIndicator stopAnimating];
    _activityIndicator.hidden = YES;

}

- (void)notificationStartLoadingUserData {
    [[WebServiceManager sharedInstance] sendRequestForUserMedia:[WebServiceManager sharedInstance].myAccessToken andMyID:[WebServiceManager sharedInstance].mySessionID];
}

- (void) notificationStartLoadingMedia {
    [self downloadAndLoadAvatar];
    [self indicatorStopLoading];
}

- (void) viewWillDisappear:(BOOL)animated {
[[NSNotificationCenter defaultCenter] removeObserver:self];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
