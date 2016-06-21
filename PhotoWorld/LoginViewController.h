//
//  LoginViewController.h
//  PhotoWorld
//
//  Created by Paul on 16.06.16.
//  Copyright © 2016 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "WebServiceManager.h"

@interface LoginViewController : UIViewController <UIWebViewDelegate, NSURLSessionDataDelegate>  {

    IBOutlet UIWebView *loginWebView;
    IBOutlet UIActivityIndicatorView *loginIndicator;
    IBOutlet UILabel *loadingLabel;
    
}
@property (strong,nonatomic) NSString *typeOfAuthentication;
- (void) pushToTabBarcontroller;

@end
