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
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    
}

- (IBAction)logoutClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)topArtistClicked:(id)sender {
    NSLog(@"saegue!!");
    [self performSegueWithIdentifier:@"showTopArtist" sender:nil];
}

@end
