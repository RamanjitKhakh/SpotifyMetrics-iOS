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
    
    
}

- (IBAction)logoutClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)topArtistClicked:(id)sender {
    [self performSegueWithIdentifier:@"showTopArtist" sender:nil];
}

@end
