//
//  ViewController.m
//  PhotoWorld
//
//  Created by Paul on 16.06.16.
//  Copyright © 2016 Paul. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

-(void) viewDidAppear:(BOOL)animated {
// not do this in ViewDidLoad

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *view = [storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
    [self presentViewController:view animated:YES completion:NULL];
    [super viewDidLoad];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
