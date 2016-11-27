//
//  metricsViewController.m
//  Simple Track Playback
//
//  Created by Ramanjit on 11/26/16.
//  Copyright © 2016 Your Company. All rights reserved.
//

#import "Config.h"
#import "metricsViewController.h"
#import <SpotifyAuthentication/SpotifyAuthentication.h>
#import <SpotifyMetadata/SpotifyMetadata.h>
#import <AVFoundation/AVFoundation.h>

@implementation metricsViewController


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    SPTAuth *auth = [SPTAuth defaultInstance];
    NSLog(@"the type is %@",auth.session.tokenType);
    NSLog(@"auth token is %@",auth.session.accessToken);
    NSLog(@"its happening");
    NSString *authorizationString = [NSString stringWithFormat:@"Bearer %@", auth.session.accessToken];
    
    NSMutableURLRequest *requestWithHeaders = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://api.spotify.com/v1/me/top/artists?limit=15"]];
    [requestWithHeaders setValue:authorizationString forHTTPHeaderField:@"Authorization"];
    [requestWithHeaders setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:requestWithHeaders completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"response: %@",response);
        NSLog(@"data: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
    }]resume];
    
}

- (IBAction)logoutClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)topArtistClicked:(id)sender {
    [self performSegueWithIdentifier:@"showTopArtist" sender:nil];
}

@end
