//
//  SongDetailViewController.m
//  Spotify Metrics
//
//  Created by Ramanjit on 12/1/16.
//  Copyright © 2016 Your Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpotifyAuthentication/SpotifyAuthentication.h>
#import <SpotifyMetadata/SpotifyMetadata.h>
#import <AVFoundation/AVFoundation.h>

#import "TrackDetailViewController.h"

@implementation TrackDetailViewController

- (void) viewDidLoad {
    NSLog(@"welcome with %@", self.track);
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        NSString *str = [[[self.track valueForKey:@"album"] valueForKey:@"images"][0] valueForKey:@"url"];
        NSURL *albumCover = [NSURL URLWithString:str];
        NSLog(@"album cover is located at %@", albumCover);
        
        NSData *imgData = [NSData dataWithContentsOfURL:albumCover];
        
        [self albumCover].contentMode = UIViewContentModeScaleAspectFit;
        [[self albumCover] setImage: [UIImage imageWithData:imgData]];
        
    });
    [self.nameLabel setText:[self.track valueForKey:@"name"]];
    [self.artistLabel setText:[[self.track valueForKey:@"artists"][0] valueForKey:@"name" ]];
    
    
    
}



@end
