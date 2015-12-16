//
//  TravelInfoViewController.m
//  TestProject
//
//  Created by Егор Сидоренко on 12/2/15.
//  Copyright © 2015 Егор Сидоренко. All rights reserved.
//

#import "TravelInfoViewController.h"
@import AssetsLibrary;
@interface TravelInfoViewController ()

@property (nonatomic, retain) NSArray* model;
@property (nonatomic) int index;
@property (nonatomic, retain) UIImageView* backgroundView;
@property (nonatomic, retain) UISlider * sliderView;
@property (nonatomic, retain) AVAudioPlayer* audioPlayer;
@property (nonatomic, retain) UIButton* playButton;
@property (nonatomic, retain) NSTimer* playTimer;

@end

@implementation TravelInfoViewController

- (void)dealloc
{
    [_model release];
    [super dealloc];
}

-(UIButton*) playButton
{
    if(!_playButton)
    {
        _playButton = [[[UIButton alloc] initWithFrame:CGRectMake(5.0, 420.0, self.view.bounds.size.width - 10, 40.0)] autorelease];
        [_playButton setTitle:@"Play" forState:UIControlStateNormal];
        [_playButton setBackgroundColor:[UIColor grayColor]];
        [_playButton addTarget:self action:@selector(playSound:) forControlEvents:UIControlEventTouchDown];
    }
    return _playButton;
}

- (instancetype)initWithCurrentIndex:(int) index
{
    self = [super init];
    if(self)
    {
        self.index = index;
    }
    return self;
}

-(UISlider*) sliderView
{
    if(!_sliderView )
    {
        _sliderView = [[[UISlider alloc] initWithFrame:CGRectMake(5, 360, self.view.bounds.size.width - 5, 60 )] autorelease];
        [_sliderView setMaximumValue:250.0];
        [_sliderView setMinimumValue:0];
        [_sliderView setValue:100];
        _sliderView.continuous = YES;
        //[_sliderView addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _sliderView;
}


-(NSArray*) model
{
    if(!_model)
    {
        _model = [[DataSource.sharedDataSource getTravelItemCollection] retain];
    }
    return _model;
}

-(UIImageView*) backgroundView
{
    if(!_backgroundView)
    {
        _backgroundView = [[UIImageView alloc] initWithFrame:self.view.frame];
    }
    return  _backgroundView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //
    [self initViewValues];
    [self.view addSubview:self.backgroundView];
    UISwipeGestureRecognizer*swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(actionSwipeLeft:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipeLeft];
    [swipeLeft release];
    UISwipeGestureRecognizer*swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(actionSwipeRight:)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeRight];
    [swipeRight release];
    
    
    UIBarButtonItem* delete = [[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStyleDone target:self action:@selector(deleteTravelItem:)];
    self.navigationItem.rightBarButtonItem = delete;
    [delete release];
    
    [self.view addSubview:self.sliderView];
    [self.view addSubview:self.playButton];
    [self.sliderView becomeFirstResponder];
    

}

-(void) deleteTravelItem:(UIBarButtonItem*) button
{
    [DataSource.sharedDataSource removeTravelItem:(TravelItem* )self.model[self.index]];
    [self.navigationController popViewControllerAnimated:YES];
    [DataSource.sharedDataSource saveContexChanges];
    [[NSFileManager defaultManager] removeItemAtPath:((TravelItem* )self.model[self.index]).imageUrl error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:((TravelItem* )self.model[self.index]).soundUrl error:nil];
}

-(void) initViewValues
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
    TravelItem* displayModel = (TravelItem* )self.model[self.index];
    [self setTitle:displayModel.name];
    
    
    UIImage* img = [[UIImage alloc] initWithContentsOfFile:displayModel.imageUrl];
    self.backgroundView.image = img;
    [img release];
    NSData* soundData = [NSData dataWithContentsOfFile:displayModel.soundUrl];
    self.audioPlayer =[[AVAudioPlayer alloc] initWithData:soundData error:nil];
    self.sliderView.maximumValue = self.audioPlayer.duration;
    [self.audioPlayer setDelegate:self];
    self.sliderView.value = 0.0f;
}

-(void) updateTime:(NSTimer*) sender
{
    self.sliderView.value = self.sliderView.value + 1;
    if(self.sliderView.value >= self.sliderView.maximumValue)
    {
        [self.playTimer invalidate];
    }
}
- (void) actionSwipeLeft:(UISwipeGestureRecognizer*) gestureRecognizer
{
    self.index--;
    [self initViewValues];
}
- (void) actionSwipeRight:(UISwipeGestureRecognizer*) gestureRecognizer
{
    self.index++;
    [self initViewValues];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}
-(void)playSound:(UIButton*) sender
{
    if (self.audioPlayer)
    {
        
        if(self.sliderView.value == self.sliderView.maximumValue)
            self.sliderView.value = 0.0f;
        self.playTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target: self selector:@selector(updateTime:) userInfo: nil repeats: YES];
        self.audioPlayer.currentTime = self.sliderView.value;
        [self.audioPlayer play];
        
    }
}


@end
