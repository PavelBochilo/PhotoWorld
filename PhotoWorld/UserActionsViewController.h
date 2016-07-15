//
//  UserActionsViewController.h
//  PhotoWorld
//
//  Created by Paul on 15.07.16.
//  Copyright © 2016 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceManager.h"
#import "ActionHeaderTableViewCell.h"

@interface UserActionsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *actionTableView;

@end
