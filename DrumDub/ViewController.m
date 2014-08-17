//
//  ViewController.m
//  DrumDub
//
//  Created by Prasong on 16/08/2014.
//  Copyright (c) 2014 Prasong Techapanyo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    MPMusicPlayerController *music;
}
-(void)playbackStateDidChangeNotification:(NSNotification*)notification;
@property(readonly, nonatomic)MPMusicPlayerController *musicPlayer;
@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectTracker:(id)sender{
    MPMediaPickerController *picker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAnyAudio];
    picker.delegate = self;
    picker.allowsPickingMultipleItems = NO;
    picker.prompt = @"Choose a song";
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)play:(id)sender {
    [self.musicPlayer.play];
}

- (IBAction)pause:(id)sender {
    [self.musicPlayer.pause];
}
#pragma mark Notifications
-(void)playbackStateDidChangeNotification:(NSNotification*)notification{
    BOOL playing = (music.playbackState==MPMoviePlaybackStatePlaying);
    _playButton.enabled = !playing;
    _pauseButton.enabled = playing;
}
#pragma mark Properties
-(MPMusicPlayerController*)musicPlayer{
    if (music == nil) {
        music = [MPMusicPlayerController applicationMusicPlayer];
        music.shuffleMode = NO;
        music.repeatMode = NO;
    }
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(playbackStateDidChangeNotification:) name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:music];
    [music beginGeneratingPlaybackNotifications];
    return music;
}
#pragma mark MPMediaPickerControllerDelegate

-(void)mediaPicker:(MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection{
    if (mediaItemCollection.count != 0) {
        [self.musicPlayer setQueueWithItemCollection:mediaItemCollection];
        [self.musicPlayer play];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
