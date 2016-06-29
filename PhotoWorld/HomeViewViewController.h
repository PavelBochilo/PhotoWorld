//
//  HomeViewViewController.h
//  PhotoWorld
//
//  Created by Paul on 22.06.16.
//  Copyright © 2016 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceManager.h"


@interface HomeViewViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *homeTableView;

@end
