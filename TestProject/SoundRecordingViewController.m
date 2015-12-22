//
//  SoundRecordingController.m
//  TestProject
//
//  Created by Егор Сидоренко on 11/30/15.
//  Copyright © 2015 Егор Сидоренко. All rights reserved.
//

#import "SoundRecordingViewController.h"

@interface SoundRecordingViewController () <AVAudioRecorderDelegate>

@property (nonatomic, retain) AVAudioRecorder * audioRecorder;
@property (nonatomic, retain) UIButton * recordButton;
@property (nonatomic, retain) UIProgressView * progressBar;
@property (nonatomic, retain) NSTimer * recordTimer;

@property (nonatomic) int ticks;
@property (nonatomic) int maxTime;

@end

@implementation SoundRecordingViewController

#pragma mark - UIViewController Life cycle

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.progressBar = nil;
    self.recordButton = nil;
    [self.audioRecorder release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem* doneButton = [[[UIBarButtonItem alloc] initWithTitle: NSLocalizedString(@"Done",nil)
                                                                    style: UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action: @selector(_doneButtonAction:)] autorelease];
    [doneButton setEnabled:NO];
    self.navigationItem.rightBarButtonItem = doneButton;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.progressBar];
    [self.view addSubview:self.recordButton];
}

#pragma mark - Properties Setter and Getters

- (AVAudioRecorder *)audioRecorder
{
    if(!_audioRecorder)
    {
        NSArray * dirPaths;
        NSString * docsDir;
        
        dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        docsDir = dirPaths[0];
        NSString * fileName = [NSString stringWithFormat: @"sound_%@.caf", [Utils.sharedUtils getCurrentTime]];
        NSString * soundFilePath = [docsDir stringByAppendingPathComponent:fileName];
        self.travelItemModel.soundPath = fileName;
        
        NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
        
        NSDictionary *recordSettings = [NSDictionary
                                        dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInt: AVAudioQualityMin],
                                        AVEncoderAudioQualityKey,
                                        [NSNumber numberWithInt: 16],
                                        AVEncoderBitRateKey,
                                        [NSNumber numberWithInt: 2],
                                        AVNumberOfChannelsKey,
                                        [NSNumber numberWithFloat: 44100.0],
                                        AVSampleRateKey,
                                        nil];
        
        NSError * error = nil;
        
        AVAudioSession * audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord 
                            error:nil];
        
        _audioRecorder = [[AVAudioRecorder alloc]initWithURL:soundFileURL
                                                    settings:recordSettings
                                                       error:&error];
        _audioRecorder.delegate = self;
    }
    
    return _audioRecorder;
}

- (UIButton *)recordButton
{
    if(!_recordButton)
    {
        _recordButton = [[[UIButton alloc] initWithFrame:CGRectMake(5, 210, self.view.bounds.size.width - 10, 60)] autorelease];
        [_recordButton setTitle:NSLocalizedString(@"Record",nil) forState:UIControlStateNormal];
        _recordButton.layer.borderWidth = 0.5f;
        _recordButton.layer.cornerRadius = 5;
        _recordButton.layer.borderColor = [[UIColor grayColor]CGColor];
        [_recordButton setBackgroundColor:[UIColor darkGrayColor]];
        [_recordButton addTarget:self action:@selector(_startRecording:) forControlEvents:UIControlEventTouchDown];
    }
    return  _recordButton;
}

- (UIProgressView *)progressBar
{
    if(!_progressBar)
    {
        _progressBar = [[UIProgressView alloc] initWithFrame:CGRectMake(5, 180, self.view.bounds.size.width - 10, 30)];
    }
    return _progressBar;
}

- (int)maxTime
{
    return 3;
}

#pragma mark - AVAudioRecorder delegate

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    NSData* data = [NSData dataWithContentsOfFile: self.travelItemModel.soundPath];
    [data writeToFile:self.travelItemModel.soundPath atomically: YES];
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
}

#pragma mark - Private Section

- (void)_startRecording:(UIButton *) sender
{
    self.ticks = 0;
    self.progressBar.progress = 0.0;
    self.recordTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                        target:self
                                                      selector:@selector(_timerTick)
                                                      userInfo:nil
                                                       repeats:YES];
    if (!self.audioRecorder.recording)
    {
        [self.audioRecorder record];
    }
}

- (void)_timerTick
{
    self.progressBar.progress+=(1.f/self.maxTime);
    [self.recordButton setTitle: [NSString stringWithFormat:@"Record  Time 00:00:%d",++self.ticks] forState:UIControlStateNormal];
    if (self.progressBar.progress >= 1.0) {
        [self.recordTimer invalidate];
        [self.audioRecorder stop];
    }
}

- (void)_doneButtonAction:(UIBarButtonItem*) sender
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Saved",nil)
                                                                    message:@""
                                                             preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK",nil)
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action)
                                {
                                    [DataSource.sharedDataSource saveContexChanges];
                                    NSArray * array = [self.navigationController viewControllers];
                                    [self.navigationController popToViewController:[array objectAtIndex:1] animated:YES];
                                }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}
@end
