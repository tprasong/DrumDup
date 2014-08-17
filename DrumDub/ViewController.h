//
//  ViewController.h
//  DrumDub
//
//  Created by Prasong on 16/08/2014.
//  Copyright (c) 2014 Prasong Techapanyo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController : UIViewController<MPMediaPickerControllerDelegate>

-(IBAction)selectTracker:(id)sender;

@end

