//
//  ArtistViewController.m
//  Simple Track Playback
//
//  Created by Ramanjit on 11/26/16.
//  Copyright © 2016 Your Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpotifyAuthentication/SpotifyAuthentication.h>
#import <SpotifyMetadata/SpotifyMetadata.h>
#import <AVFoundation/AVFoundation.h>

#import "Config.h"
#import "TopArtistViewController.h"
#import "RecommendedArtists.h"

@implementation TopArtistViewController

- (void) viewWillAppear:(BOOL)animated {
    
    
    [super viewWillAppear:animated];
}

- (void) viewDidLoad {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    SPTAuth *auth = [SPTAuth defaultInstance];
    
    NSLog(@"API key %@", auth.session.accessToken);
    
    NSString *authorizationString = [NSString stringWithFormat:@"Bearer %@", auth.session.accessToken];
    
    NSMutableURLRequest *requestWithHeaders = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://api.spotify.com/v1/me/top/artists?limit=20"]];
    [requestWithHeaders setValue:authorizationString forHTTPHeaderField:@"Authorization"];
    [requestWithHeaders setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    
    
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:requestWithHeaders completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSError *e;
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&e];
        
        [self setArtistList:[jsonDictionary valueForKey:@"items"]];
        [[self tableView] reloadData];
        
    }]resume];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    RecommendedArtists *nextView = [segue destinationViewController];
    nextView.artist = sender;
    
}


#pragma mark - Table View


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.artistList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSData *object = self.artistList[indexPath.row];
    
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
    [self performSegueWithIdentifier:@"showRecommended" sender:self.artistList[indexPath.row]];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
