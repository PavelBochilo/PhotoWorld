//
//  WebServiceManager.m
//  PhotoWorld
//
//  Created by Paul on 20.06.16.
//  Copyright © 2016 Paul. All rights reserved.
//

#import "WebServiceManager.h"

@implementation WebServiceManager



#pragma mark Singleton
+ (WebServiceManager *)sharedInstance {
    static WebServiceManager *serviceManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serviceManager = [[WebServiceManager alloc] init];
    });
    return serviceManager;
}

- (void) handleMyTokenAndID:(NSString *)myToken andMyName:(NSString *)myFullName  {
    _myAccessToken = myToken;
    _mySessionID = myFullName;
    NSLog(@"My token succesfully saved, here it is - %@", _myAccessToken);
    NSLog(@"My ID was saved -- %@", _mySessionID);
}

- (void) sendPOSTRequestWithCode: (NSString *) code {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate: nil delegateQueue:nil];
    NSString *post = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&grant_type=authorization_code&redirect_uri=%@&code=%@",INSTAGRAM_CLIENT_ID,INSTAGRAM_CLIENTSERCRET,INSTAGRAM_REDIRECT_URI,code];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *requestData = [NSMutableURLRequest requestWithURL:
                                        [NSURL URLWithString:@"https://api.instagram.com/oauth/access_token"]];
    [requestData setHTTPMethod:@"POST"];
    [requestData setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [requestData setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [requestData setHTTPBody:postData];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:requestData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//        NSLog(@"This is me Dictionary, JSONSerialization from data === %@", dict);
        NSMutableDictionary * userDict = [[NSMutableDictionary alloc] init];
        userDict = [dict valueForKey:@"user"];
        [self handleMyTokenAndID:[dict valueForKey:@"access_token"] andMyName:[userDict valueForKey:@"id"]];
    }];
    
    [postDataTask resume];
}

- (void) sendPOSTRequestUserInfo: (NSString *) myToken andMyID: (NSString *) myID {

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate: self delegateQueue:nil];
    NSMutableURLRequest *requestData = [NSMutableURLRequest requestWithURL:
                                        [NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/users/%@/?access_token=%@",myID, myToken]]];
    [requestData setHTTPMethod:@"GET"];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:requestData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *userDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//        NSLog(@"This IS USER DATA === %@", userDict);
        [self saveUserData:userDict];
    }];
    
    [postDataTask resume];

}
- (void) sendRequestForUserMedia: (NSString *) myToken andMyID: (NSString *) myID {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate: self delegateQueue:nil];
    NSMutableURLRequest *requestData = [NSMutableURLRequest requestWithURL:
                                        [NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/users/%@/media/recent/?access_token=%@",myID, myToken]]];
    [requestData setHTTPMethod:@"GET"];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:requestData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *userDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        [self saveMediaDictionary:userDict];
        
    }];
    
    [postDataTask resume];


}

- (void) saveMediaDictionary: (NSDictionary *) mediaDict {
dispatch_async(dispatch_get_main_queue(), ^{
    _userMediaDictionaty = mediaDict;
//    NSArray *dict = [_userMediaDictionaty objectForKey:@"data"];
//    NSDictionary *dict2 = [dict objectAtIndex:0];
//    NSDictionary *dict3 = [dict2 objectForKey:@"images"];
        NSLog(@"Dict saved === %@", _userMediaDictionaty);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"userMediaNotification" object:nil];
});
}

- (void) saveUserData: (NSDictionary *) userDict {
    dispatch_async(dispatch_get_main_queue(), ^{
    _userDataDictionary = userDict;
//    NSLog(@"Dict saved === %@", _userDataDictionary);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"userNotification" object:nil];
   });
}



@end
