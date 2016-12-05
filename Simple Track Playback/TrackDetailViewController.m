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
    
    //api request
    SPTAuth *auth = [SPTAuth defaultInstance];
    NSString *authorizationString = [NSString stringWithFormat:@"Bearer %@", auth.session.accessToken];
    
    NSString *preparedURL = [NSString stringWithFormat:@"https://api.spotify.com/v1/audio-features/%@", [self.track valueForKey:@"id"]];
    
    NSURL *uriString = [NSURL URLWithString:preparedURL];
    
    NSLog(@"contacting %@", uriString);
    
    NSMutableURLRequest *requestWithHeaders = [NSMutableURLRequest requestWithURL:uriString];
    [requestWithHeaders setValue:authorizationString forHTTPHeaderField:@"Authorization"];
    [requestWithHeaders setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:requestWithHeaders completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSError *e;
        __block NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&e];
        
        //sync with main
        dispatch_async(dispatch_get_main_queue(), ^(){
            
            // set danceablility
            NSString *danceString = [NSString stringWithFormat:@"%@", [jsonDictionary valueForKey:@"danceability"] ];
            self.danceabilityProgress.progress = [[jsonDictionary valueForKey:@"danceability"] floatValue];
            [self.danceabilityLabel setText:danceString];
            
            //set energy
            NSString *energyString = [NSString stringWithFormat:@"%@",[jsonDictionary valueForKey:@"energy"]];
            [self.energyLabel setText:energyString];
            self.energyProgress.progress = [[jsonDictionary valueForKey:@"energy"] floatValue];
            
            //set tempo
            NSString *tempoString = [NSString stringWithFormat:@"%@", [jsonDictionary valueForKey:@"tempo"]];
            [self.tempoLabel setText:tempoString];
            
            NSString *valenceString = [NSString stringWithFormat:@"%@", [jsonDictionary valueForKey:@"valence"] ];
            
            [self.valenceLabel setText:valenceString];
            //NSLog(@" type is %@",NSStringFromClass([[jsonDictionary valueForKey:@"danceability"] class]) );
        });
        
        
    }]resume];
    
}



@end
