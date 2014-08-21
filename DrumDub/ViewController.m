//
//  ViewController.m
//  DrumDub
//
//  Created by Prasong on 16/08/2014.
//  Copyright (c) 2014 Prasong Techapanyo. All rights reserved.
//

#import "ViewController.h"

#define kNumberOfPlayers 4
static NSString *SoundName[kNumberOfPlayers] = {@"snare",@"bass",@"tambourine",@"maraca"};
@interface ViewController ()
{
    MPMusicPlayerController *music;
    AVAudioPlayer *players[kNumberOfPlayers];
}
-(void)playbackStateDidChangeNotification:(NSNotification*)notification;
-(void)playingItemDidChangeNotification:(NSNotification*)notification;
-(void)createAudioPlayers;
-(void)destroyAudioPlayers;
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
    [self.musicPlayer play];
}

- (IBAction)pause:(id)sender {
    [self.musicPlayer pause];
}

- (IBAction)bang:(id)sender {
    NSInteger playerIndex = [sender tag] -1;
    if(playerIndex >=0 && playerIndex<kNumberOfPlayers){
        AVAudioPlayer *player = [players[playerIndex]];
        [player pause];
        player.currentTime = 0;
        [player play];
    }
}
#pragma mark Notifications
-(void)playbackStateDidChangeNotification:(NSNotification*)notification{
    BOOL playing = (music.playbackState==MPMoviePlaybackStatePlaying);
    _playButton.enabled = !playing;
    _pauseButton.enabled = playing;
}
-(void)playingItemDidChangeNotification:(NSNotification*)notification{
    MPMediaItem *nowPlaying = music.nowPlayingItem;
    MPMediaItemArtwork *artWork = [nowPlaying valueForProperty:MPMediaItemPropertyArtwork];
    UIImage *albumImage = [artWork imageWithSize:_albumView.bounds.size];
    if (albumImage == nil) {
        albumImage = [UIImage imageNamed:@"noartwork"];
    }
    _albumView.image = albumImage;
    _songLabel.text = [nowPlaying valueForProperty:MPMediaItemPropertyTitle];
    _albumLabel.text = [nowPlaying valueForProperty:MPMediaItemPropertyAlbumTitle];
    _artistLabel.text = [nowPlaying valueForProperty:MPMediaItemPropertyArtist];
    
}
#pragma mark Methods
-(void)createAudioPlayers{
    for (NSUInteger i=0; i<kNumberOfPlayers; i++) {
        NSURL *soundURL = [[NSBundle mainBundle] URLForResource:SoundName[i]withExtension:@"m4a"];
        players[i] = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:NULL];
        players[i].delegate = self;
        [players[i] prepareToPlay];
    }
}
-(void)destroyAudioPlayers{
    for (NSUInteger i=0; i<kNumberOfPlayers; i++) {
        players[i] = nil;
    }
}
#pragma mark Properties
-(MPMusicPlayerController*)musicPlayer{
    if (music == nil) {
        music = [MPMusicPlayerController applicationMusicPlayer];
        music.shuffleMode = NO;
        music.repeatMode = NO;
        
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter addObserver:self selector:@selector(playbackStateDidChangeNotification:) name:MPMusicPlayerControllerPlaybackStateDidChangeNotification object:music];
        [music beginGeneratingPlaybackNotifications];
        [notificationCenter addObserver:self selector:@selector(playingItemDidChangeNotification:) name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification object:music];

    }
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
