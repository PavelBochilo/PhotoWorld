//
//  EditProfileViewController.h
//  PhotoWorld
//
//  Created by Paul on 01.07.16.
//  Copyright © 2016 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoViewController.h"
#import "EditTableViewCell.h"

@interface EditProfileViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *editTableView;

@end
