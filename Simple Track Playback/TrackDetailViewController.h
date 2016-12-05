//
//  SongDetailViewController.h
//  Spotify Metrics
//
//  Created by Ramanjit on 12/1/16.
//  Copyright © 2016 Your Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrackDetailViewController : UIViewController
@property id track;
@property (strong, nonatomic) IBOutlet UIImageView *albumCover;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *artistLabel;
@property (strong, nonatomic) IBOutlet UILabel *danceabilityLabel;
@property (strong, nonatomic) IBOutlet UIProgressView *danceabilityProgress;

@end
