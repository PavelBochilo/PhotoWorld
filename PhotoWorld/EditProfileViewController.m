//
//  EditProfileViewController.m
//  PhotoWorld
//
//  Created by Paul on 01.07.16.
//  Copyright © 2016 Paul. All rights reserved.
//

#import "EditProfileViewController.h"
#import "WebServiceManager.h"

@interface EditProfileViewController ()

@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setNavigationBar {
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName: [UIFont fontWithName:@"BillabongW00-Regular" size:30]}];
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
    [self.navigationItem setTitle:@"Edit"];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@""
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(lastViewController)];
    item.image = [UIImage imageNamed:@"back"];
    item.tintColor = [UIColor blackColor];
    [self.navigationItem setLeftBarButtonItem:item animated:YES];
}
- (void)lastViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
