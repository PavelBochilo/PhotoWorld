//
//  LoginViewController.m
//  PhotoWorld
//
//  Created by Paul on 16.06.16.
//  Copyright © 2016 Paul. All rights reserved.
//
#define INSTAGRAM_AUTHURL                               @"https://api.instagram.com/oauth/authorize/"
#define INSTAGRAM_APIURl                                @"https://api.instagram.com/v1/users/"
#define INSTAGRAM_CLIENT_ID                             @"f2350bca52ec4aef9f0019a55119942f"
#define INSTAGRAM_CLIENTSERCRET                         @"00e28302f5bf41ceb5288379c41b74e1"
#define INSTAGRAM_REDIRECT_URI                          @"https://instagram.com/"
#define INSTAGRAM_ACCESS_TOKEN                          @"access_token"
#define INSTAGRAM_SCOPE                                 @"basic+public_content+follower_list+comments+relationships+likes"
#define INSTAGRAM_API_USER                              @"https://api.instagram.com/v1/users/{user-id}/?access_token=ACCESS-TOKEN"
#define INSTAGRAM_MEDIA                                 @"https://api.instagram.com/v1/media/{media-id}?access_token=ACCESS-TOKEN"
#define INSTAGRAM_API_SELF                              @"https://api.instagram.com/v1/users/self/?access_token=ACCESS-TOKEN"

#define INSTAGRAM_USER_FOLLOWES                         @"https://api.instagram.com/v1/users/self/follows?access_token=ACCESS-TOKEN"
#define INSTAGRAM_USER_FOLLOWES_BY                      @"https://api.instagram.com/v1/users/self/followed-by?access_token=ACCESS-TOKEN"

#import "LoginViewController.h"
#import "UserInfoViewController.h"
#import "MainTabBarViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize typeOfAuthentication;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationStartLoadingUserData)
                                                 name:@"userNotification"
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: animated];
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
    NSString* authURL = nil;
    
    if ([typeOfAuthentication isEqualToString:@"UNSIGNED"])
    {
        authURL = [NSString stringWithFormat: @"%@?client_id=%@&redirect_uri=%@&response_type=token&scope=%@&DEBUG=True",
                   INSTAGRAM_AUTHURL,
                   INSTAGRAM_CLIENT_ID,
                   INSTAGRAM_REDIRECT_URI,
                   INSTAGRAM_SCOPE];
        
    }
    else
    {
        authURL = [NSString stringWithFormat: @"%@?client_id=%@&redirect_uri=%@&response_type=code&scope=%@&DEBUG=True",
                   INSTAGRAM_AUTHURL,
                   INSTAGRAM_CLIENT_ID,
                   INSTAGRAM_REDIRECT_URI,
                   INSTAGRAM_SCOPE];
    }
    
    
    [loginWebView loadRequest: [NSURLRequest requestWithURL: [NSURL URLWithString: authURL]]];
    [loginWebView setDelegate:self];
    
}


#pragma mark -
#pragma mark delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    return [self checkRequestForCallbackURL: request];
}

- (void) webViewDidStartLoad:(UIWebView *)webView
{
    
    [loginIndicator startAnimating];
    loadingLabel.hidden = NO;
    [loginWebView.layer removeAllAnimations];
    loginWebView.userInteractionEnabled = NO;
    [UIView animateWithDuration: 0.1 animations:^{
        //  loginWebView.alpha = 0.2;
    }];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    loadingLabel.hidden = YES;
    [loginWebView.layer removeAllAnimations];
    loginWebView.userInteractionEnabled = YES;
    [UIView animateWithDuration: 0.1 animations:^{
        loginWebView.alpha = 1.0;        
    }];
    [loginIndicator stopAnimating];
    loginIndicator.hidden = YES;
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self webViewDidFinishLoad: webView];
}

#pragma mark -
#pragma mark auth logic


- (BOOL) checkRequestForCallbackURL: (NSURLRequest*) request
{
    NSString* urlString = [[request URL] absoluteString];
    
    if ([typeOfAuthentication isEqualToString:@"UNSIGNED"])
    {
        // check, if auth was succesfull (check for redirect URL)
        if([urlString hasPrefix: INSTAGRAM_REDIRECT_URI])
        {
            // extract and handle access token
            NSRange range = [urlString rangeOfString: @"#access_token="];
            [self handleOnlyToken:[urlString substringFromIndex: range.location+range.length]];
            return NO;
        }
    }
    else
    {
        if([urlString hasPrefix: INSTAGRAM_REDIRECT_URI])
        {
            // extract and handle access token
            NSRange range = [urlString rangeOfString: @"code="];
            [[WebServiceManager sharedInstance] sendPOSTRequestWithCode:[urlString substringFromIndex: range.location+range.length]];
            return NO;
            
        }
    }
    
    return YES;
}
- (void) handleOnlyToken: (NSString *) myToken {
//NSLog(@"My token succesfully recivied, here it is - %@", myToken);
     [WebServiceManager sharedInstance].myAccessToken = myToken;
}
- (void)notificationStartLoadingUserData {
     dispatch_async(dispatch_get_main_queue(), ^{
    [self performSelector:@selector(pushToTabBarcontroller) withObject:nil afterDelay:1];
          });
}
- (void)pushToTabBarcontroller {
    dispatch_async(dispatch_get_main_queue(), ^{
        
    [self performSegueWithIdentifier:@"firstSeque" sender:nil];
        });
}


@end
