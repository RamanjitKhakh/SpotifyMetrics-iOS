//
//  RecommendedArtists.m
//  Spotify Metrics
//
//  Created by Ramanjit on 12/5/16.
//  Copyright © 2016 Your Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpotifyAuthentication/SpotifyAuthentication.h>
#import <SpotifyMetadata/SpotifyMetadata.h>
#import <AVFoundation/AVFoundation.h>

#import "Config.h"
#import "RecommendedArtists.h"
#import "ViewController.h"

@implementation RecommendedArtists

- (void)viewDidLoad{
    
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    SPTAuth *auth = [SPTAuth defaultInstance];
    NSString *authorizationString = [NSString stringWithFormat:@"Bearer %@", auth.session.accessToken];
    NSString *urlString = [NSString stringWithFormat:@"https://api.spotify.com/v1/artists/%@/related-artists?limit=20", [self.artist valueForKey:@"id"] ];
    
    NSMutableURLRequest *requestWithHeaders = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [requestWithHeaders setValue:authorizationString forHTTPHeaderField:@"Authorization"];
    [requestWithHeaders setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:requestWithHeaders completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSError *e;
        __block NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&e];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.recommendedArtist = [jsonDictionary valueForKey:@"artists"];
            [[self tableView] reloadData];
        });
    }] resume];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    ViewController *nextView = [segue destinationViewController];
    nextView.track = sender;
    
}

#pragma mark - Table View


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.recommendedArtist.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSData *object = self.recommendedArtist[indexPath.row];
    
    cell.textLabel.text = [object valueForKey:@"name"];
    cell.detailTextLabel.text = [[object valueForKey:@"genres"] componentsJoinedByString:@", "];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //empty for now...
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SPTAuth *auth = [SPTAuth defaultInstance];
    NSString *authorizationString = [NSString stringWithFormat:@"Bearer %@", auth.session.accessToken];
    NSString *urlString = [NSString stringWithFormat:@"https://api.spotify.com/v1/artists/%@/top-tracks?country=US&limit=10", [self.recommendedArtist[indexPath.row] valueForKey:@"id"] ];
    
    NSMutableURLRequest *requestWithHeaders = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [requestWithHeaders setValue:authorizationString forHTTPHeaderField:@"Authorization"];
    [requestWithHeaders setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:requestWithHeaders completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSError *e;
        __block NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&e];
        dispatch_async(dispatch_get_main_queue(), ^{
            //prepare segue
            NSArray *topTrackForRecommended = [jsonDictionary valueForKey:@"tracks"];
            
            //NSLog(@"preparing for segue %@", topTrackForRecommended[arc4random_uniform(topTrackForRecommended.count)] );
            
            [self performSegueWithIdentifier:@"showPlayerForRecommended" sender:topTrackForRecommended[arc4random_uniform(topTrackForRecommended.count)]];
            
            
        });
    }] resume];
}
@end
