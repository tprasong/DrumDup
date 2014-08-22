//
//  ViewController.h
//  DrumDub
//
//  Created by Prasong on 16/08/2014.
//  Copyright (c) 2014 Prasong Techapanyo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController<MPMediaPickerControllerDelegate, AVAudioPlayerDelegate, AVAudioSessionDelegate>

-(IBAction)selectTracker:(id)sender;
- (IBAction)play:(id)sender;
- (IBAction)pause:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *playButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *pauseButton;
@property (weak, nonatomic) IBOutlet UIImageView *albumView;
@property (weak, nonatomic) IBOutlet UILabel *songLabel;
@property (weak, nonatomic) IBOutlet UILabel *albumLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
- (IBAction)bang:(id)sender;

@end

