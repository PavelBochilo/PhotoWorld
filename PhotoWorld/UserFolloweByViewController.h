//
//  UserFolloweByViewController.h
//  PhotoWorld
//
//  Created by Paul on 04.07.16.
//  Copyright © 2016 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoViewController.h"
#import "commonTableCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SearchBarTableViewHeader.h"

@interface UserFolloweByViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSURLSessionDelegate, NSURLSessionDataDelegate>
- (void) sendRequestForUserFollows: (NSString *) myToken andMyID: (NSString *) myID;
@property (strong, nonatomic) IBOutlet UITableView *userFollowedByTableView;
@property (strong, nonatomic) NSMutableArray *followedByIDArray;
@property (strong, nonatomic) NSMutableArray *followedByAvatarUrlArray;
@property (strong, nonatomic) NSMutableArray *followedByUserNameArray;
@property (strong, nonatomic) NSMutableArray *followedByFullName;
@end
