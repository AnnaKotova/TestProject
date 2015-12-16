//
//  TravelInfoViewController.m
//  TestProject
//
//  Created by Егор Сидоренко on 12/2/15.
//  Copyright © 2015 Егор Сидоренко. All rights reserved.
//

#import "TravelInfoViewController.h"

@interface TravelInfoViewController () <AVAudioPlayerDelegate>

@property (nonatomic, retain) NSArray * model;
@property (nonatomic) NSInteger index;
@property (nonatomic, retain) UIImageView * backgroundImageView;
@property (nonatomic, retain) UISlider * sliderView;
@property (nonatomic, retain) AVAudioPlayer * audioPlayer;
@property (nonatomic, retain) UIButton * playButton;
@property (nonatomic, retain) NSTimer * playTimer;

@end

@implementation TravelInfoViewController

#pragma mark - UIViewController Lifecycle

- (void)dealloc
{
    [_model release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //
    [self _setupViewValues];
    [self.view addSubview:self.backgroundImageView];
    UISwipeGestureRecognizer * swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(_actionSwipeLeft:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipeLeft];
    [swipeLeft release];
    UISwipeGestureRecognizer * swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(_actionSwipeRight:)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeRight];
    [swipeRight release];
    
    
    UIBarButtonItem* delete = [[UIBarButtonItem alloc] initWithTitle:@"Delete"
                                                               style:UIBarButtonItemStyleDone
                                                              target:self
                                                              action:@selector(_deleteButtonAction:)];
    
    self.navigationItem.rightBarButtonItem = delete;
    [delete release];
    
    [self.view addSubview:self.sliderView];
    [self.view addSubview:self.playButton];
    [self.sliderView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Properties Setters and Getters

- (UIButton *)playButton
{
    if(!_playButton)
    {
        _playButton = [[[UIButton alloc] initWithFrame:CGRectMake(5.0, 420.0, self.view.bounds.size.width - 10, 40.0)] autorelease];
        [_playButton setTitle:@"Play" forState:UIControlStateNormal];
        [_playButton setBackgroundColor:[UIColor grayColor]];
        [_playButton addTarget:self action:@selector(_playButtonAction:) forControlEvents:UIControlEventTouchDown];
    }
    return _playButton;
}

- (instancetype)initWithCurrentIndex:(NSInteger) index
{
    self = [super init];
    if(self)
    {
        self.index = index;
    }
    return self;
}

- (UISlider *)sliderView
{
    if(!_sliderView )
    {
        _sliderView = [[[UISlider alloc] initWithFrame:CGRectMake(5, 360, self.view.bounds.size.width - 5, 60 )] autorelease];
        [_sliderView setMaximumValue:250.0];
        [_sliderView setMinimumValue:0];
        [_sliderView setValue:100];
        _sliderView.continuous = YES;
    }
    return _sliderView;
}


- (NSArray *)model
{
    if(!_model)
    {
        _model = [[DataSource.sharedDataSource getTravelItemCollection] retain];
    }
    return _model;
}

- (UIImageView *)backgroundImageView
{
    if(!_backgroundImageView)
    {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    }
    return  _backgroundImageView;
}

#pragma mark - Private Section

- (void)_deleteButtonAction:(UIBarButtonItem *) button
{
    [DataSource.sharedDataSource removeTravelItem:(TravelItem *)self.model[self.index]];
    [self.navigationController popViewControllerAnimated:YES];
    [DataSource.sharedDataSource saveContexChanges];
    [[NSFileManager defaultManager] removeItemAtPath:((TravelItem *)self.model[self.index]).imageUrl error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:((TravelItem *)self.model[self.index]).soundUrl error:nil];
}

- (void)_setupViewValues
{
    if(self.index < 0 )
        self.index = self.model.count - 1;
    else if (self.index >= self.model.count)
        self.index = 0;
    
    [self.playTimer invalidate];
    if(self.audioPlayer)
    {
        [self.audioPlayer stop];
    }
    TravelItem * displayModel = (TravelItem *)self.model[self.index];
    [self setTitle:displayModel.name];
    
    
    UIImage * img = [[UIImage alloc] initWithContentsOfFile:displayModel.imageUrl];
    self.backgroundImageView.image = img;
    [img release];
    NSData * soundData = [NSData dataWithContentsOfFile:displayModel.soundUrl];
    self.audioPlayer =[[[AVAudioPlayer alloc] initWithData:soundData error:nil] autorelease];
    self.sliderView.maximumValue = self.audioPlayer.duration;
    [self.audioPlayer setDelegate:self];
    self.sliderView.value = 0.0f;
}

- (void)_updateTimeTimerAction:(NSTimer *) sender
{
    self.sliderView.value = self.sliderView.value + 1;
    if(self.sliderView.value >= self.sliderView.maximumValue)
    {
        [self.playTimer invalidate];
    }
}
- (void)_actionSwipeLeft:(UISwipeGestureRecognizer *) gestureRecognizer
{
    self.index--;
    [self _setupViewValues];
}
- (void)_actionSwipeRight:(UISwipeGestureRecognizer *) gestureRecognizer
{
    self.index++;
    [self _setupViewValues];
}



- (void)_playButtonAction:(UIButton *) sender
{
    if (self.audioPlayer)
    {
        
        if(self.sliderView.value == self.sliderView.maximumValue)
            self.sliderView.value = 0.0f;
        self.playTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0
                                                          target: self
                                                        selector:@selector(_updateTimeTimerAction:)
                                                        userInfo: nil
                                                         repeats: YES];
        
        self.audioPlayer.currentTime = self.sliderView.value;
        [self.audioPlayer play];
        
    }
}


@end
