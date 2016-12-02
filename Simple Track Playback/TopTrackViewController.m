//
//  TopTrackViewController.m
//  Simple Track Playback
//
//  Created by Ramanjit on 11/30/16.
//  Copyright © 2016 Your Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpotifyAuthentication/SpotifyAuthentication.h>
#import <SpotifyMetadata/SpotifyMetadata.h>
#import "TopTrackViewController.h"
#import "TrackDetailViewController.h"

@implementation TopTrackViewController

- (void) viewWillAppear:(BOOL) animated {
    //runs even when upper views are popped off
    [super viewWillAppear:animated];
    
}

- (void) viewDidLoad{
    // runs once for view pop
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    SPTAuth *auth = [SPTAuth defaultInstance];
    
    NSString *authorizationString = [NSString stringWithFormat:@"Bearer %@", auth.session.accessToken];
    
    NSMutableURLRequest *requestWithHeaders = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://api.spotify.com/v1/me/top/tracks?limit=20"]];
    [requestWithHeaders setValue:authorizationString forHTTPHeaderField:@"Authorization"];
    [requestWithHeaders setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:requestWithHeaders completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSError *e;
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&e];
        
        [self setTrackList:[jsonDictionary valueForKey:@"items"]];
        [[self tableView] reloadData];
        
        
    }]resume];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    TrackDetailViewController *nextView = [segue destinationViewController];
    //deselect the cell on return
    [nextView setTrack: self.trackList[((NSIndexPath *)sender).row]];
    
    
}

#pragma mark - Table View


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.trackList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSData *object = self.trackList[indexPath.row];
    
    cell.textLabel.text = [object valueForKey:@"name"];
    cell.detailTextLabel.text = [[object valueForKey:@"artists"][0] valueForKey:@"name"];
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
    
    
    [self performSegueWithIdentifier:@"showDetails" sender:indexPath];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}




@end

