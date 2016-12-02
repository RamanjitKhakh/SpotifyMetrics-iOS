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
@property (weak, nonatomic) IBOutlet UIImageView *albumCover;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;

@end
