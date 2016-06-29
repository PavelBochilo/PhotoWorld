//
//  UserPhotoDetailViewController.h
//  PhotoWorld
//
//  Created by Paul on 28.06.16.
//  Copyright © 2016 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoViewController.h"

@interface UserPhotoDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSString *detailUrl;
@property (strong, nonatomic) UIImage *photo;
@property (weak, nonatomic) IBOutlet UITableView *userDetailPhotoTableView;

@end
