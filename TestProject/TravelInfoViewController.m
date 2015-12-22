//
//  TravelInfoViewController.m
//  TestProject
//
//  Created by Егор Сидоренко on 12/2/15.
//  Copyright © 2015 Егор Сидоренко. All rights reserved.
//

#import "TravelInfoViewController.h"

@interface TravelInfoViewController () <AVAudioPlayerDelegate, UIScrollViewDelegate, UIScrollViewDelegate>
{
    CGFloat _lastContentOffset;
    NSInteger _nextIndex;
    NSMutableArray<__kindof UIScrollView *> * _scrollViews;
    Boolean _isBackButtonClicked;
    Boolean _isDeleteButtonClicked;
    NSString * _projectPath;
}

@property (nonatomic, retain) NSArray * model;
@property (nonatomic, retain) UISlider * sliderView;
@property (nonatomic, retain) AVAudioPlayer * audioPlayer;
@property (nonatomic, retain) UIButton * playButton;
@property (nonatomic, retain) NSTimer * playTimer;
@property (nonatomic, retain) UIScrollView * imageSiderScrollView;


@property (nonatomic) NSInteger currentIndex;

@end

@implementation TravelInfoViewController

#pragma mark - UIViewController Lifecycle

- (void)dealloc
{
    [_model release];
    [_scrollViews release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self _setupViewValues];
    [self _setupScrollView];
    [self.view addSubview:self.imageSiderScrollView];
    
    UIBarButtonItem* delete = [[UIBarButtonItem alloc] initWithTitle:@"Delete"
                                                               style:UIBarButtonItemStyleDone
                                                              target:self
                                                              action:@selector(_deleteButtonAction:)];
    
    self.navigationItem.rightBarButtonItem = delete;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [delete release];
    _isBackButtonClicked = false;
    _isDeleteButtonClicked = false;
    [self.view addSubview:self.sliderView];
    [self.view addSubview:self.playButton];
    [self.sliderView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (instancetype)initWithCurrentIndex:(NSInteger) index
{
    self = [super init];
    if(self)
    {
        self.currentIndex = index;
        NSArray * dirPaths;
        dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        _projectPath = dirPaths[0];
    }
    return self;
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

- (UIScrollView *) imageSiderScrollView
{
    if(!_imageSiderScrollView)
    {
        _imageSiderScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0 ,0 , CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
        _imageSiderScrollView.contentSize = CGSizeMake(CGRectGetWidth(_imageSiderScrollView.bounds) * 3, CGRectGetHeight(_imageSiderScrollView.bounds));
        _imageSiderScrollView.showsVerticalScrollIndicator = NO;
        _imageSiderScrollView.delegate = self;
        _imageSiderScrollView.pagingEnabled = YES;
        _imageSiderScrollView.autoresizesSubviews = NO;
        _imageSiderScrollView.clipsToBounds = NO;
    }
    return _imageSiderScrollView;
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

#pragma mark - UIScroll Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_isBackButtonClicked || _isDeleteButtonClicked)
    {
        return;
    }
    
    if(self.imageSiderScrollView == scrollView)
    {
        if(scrollView.contentOffset.x == 0)
        {
         [self _setPreviousIndex];
        for (NSInteger i = 0 ; i < _scrollViews.count; i++)
        {
            UIScrollView * scrView = _scrollViews[i];
            UIImageView * imageView = [scrView subviews].firstObject;
            CGRect frameRectangel = scrView.frame;
            switch ((int)frameRectangel .origin.x)
            {
                case 0:
                    frameRectangel.origin.x = 320;
                    break;
                case 320:
                    frameRectangel.origin.x = 640;
                    break;
                case 640:
                    frameRectangel.origin.x = 0;
                    PHFetchResult * fetchResult = [PHAsset fetchAssetsWithLocalIdentifiers:@[((TravelItem *)self.model[_nextIndex]).imagePath] options:nil];

                    for(PHAsset * asset in fetchResult)
                    {
                        [PHImageManager.defaultManager requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                            imageView.image = result;
                        }];
                    }
                    break;
            }
            scrView.frame = frameRectangel;
        }
        self.title = ((TravelItem *)self.model[self.currentIndex]).name;
    }
    if (scrollView.contentOffset.x == 640)
    {
        [self _setNextIndex];
        for (NSInteger i = 0 ; i < _scrollViews.count; i++)
        {
            UIScrollView * scrView = _scrollViews[i];
            UIImageView * imageView = [scrView subviews].firstObject;
            CGRect frameRectangel = scrView.frame;
            switch ((int)frameRectangel .origin.x)
            {
                case 640:
                    frameRectangel.origin.x = 320;
                    break;
                case 320:
                    frameRectangel.origin.x = 0;
                    break;
                case 0:
                    self.title = ((TravelItem *)self.model[self.currentIndex]).name;
                    PHFetchResult * fetchResult = [PHAsset fetchAssetsWithLocalIdentifiers:@[((TravelItem *)self.model[_nextIndex]).imagePath] options:nil];

                    for(PHAsset * asset in fetchResult)
                    {
                        [PHImageManager.defaultManager requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                            imageView.image = result;
                        }];
                    }
                    frameRectangel.origin.x = 640;
                    break;
            }
            scrView.frame = frameRectangel;
        }
    }
    [scrollView setContentOffset:CGPointMake(320, 0)];
    [self _setupViewValues];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return [scrollView subviews].firstObject;
}

#pragma mark - Private Section

- (void)_deleteButtonAction:(UIBarButtonItem *) button
{
    _isDeleteButtonClicked = true;
    self.imageSiderScrollView.scrollEnabled = NO;
    [DataSource.sharedDataSource removeTravelItem:(TravelItem *)self.model[self.currentIndex]];
    [self.navigationController popViewControllerAnimated:YES];
    [DataSource.sharedDataSource saveContexChanges];
    NSString * soundFilePath = [_projectPath stringByAppendingPathComponent:((TravelItem *)self.model[self.currentIndex]).soundPath];
    [[NSFileManager defaultManager] removeItemAtPath:soundFilePath error:nil];
}

- (void)_setupViewValues
{
    if(self.currentIndex < 0 )
        self.currentIndex = self.model.count - 1;
    else if (self.currentIndex >= self.model.count)
        self.currentIndex = 0;
    
    [self.playTimer invalidate];
    
    if(self.audioPlayer)
    {
        [self.audioPlayer stop];
    }
    
    TravelItem * displayModel = (TravelItem *)self.model[self.currentIndex];
    [self setTitle:displayModel.name];
    
   
    NSString * soundFilePath = [_projectPath stringByAppendingPathComponent:displayModel.soundPath];
    
    NSData * soundData = [NSData dataWithContentsOfFile:soundFilePath];
    self.audioPlayer =[[[AVAudioPlayer alloc] initWithData:soundData error:nil] autorelease];
    [self.audioPlayer setDelegate:self];
    
    self.sliderView.maximumValue = self.audioPlayer.duration;
    self.sliderView.value = 0.0f;
    if (!self.audioPlayer) {
        self.playButton.enabled = NO;
        self.sliderView.enabled = NO;
    }
}

- (void)_updateTimeTimerAction:(NSTimer *) sender
{
    self.sliderView.value = self.sliderView.value + 1;
    if(self.sliderView.value >= self.sliderView.maximumValue)
    {
        [self.playTimer invalidate];
    }
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

- (void)_setupScrollView
{
    _scrollViews = [[NSMutableArray alloc] init];
    int offset = 0;
    int counter = 0;
    
    for(NSInteger i = self.currentIndex - 1 ;counter < 3 ; i++, counter++)
    {
        if(i < 0)
        {
            i = self.model.count - 1;
        }
        
        if(i >= self.model.count)
        {
            i = 0;
        }
        UIScrollView * currentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(offset ,0, CGRectGetWidth(self.imageSiderScrollView.layer.bounds), CGRectGetHeight(self.imageSiderScrollView.layer.bounds))];
        currentScrollView.contentSize = currentScrollView.bounds.size;
        currentScrollView.maximumZoomScale = 6.0;
        currentScrollView.minimumZoomScale = 0.5;
        currentScrollView.delegate = self;
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0 ,0, CGRectGetWidth(self.imageSiderScrollView.layer.bounds), CGRectGetHeight(self.imageSiderScrollView.layer.bounds))];
       
        PHFetchResult * fetchResult = [PHAsset fetchAssetsWithLocalIdentifiers:@[((TravelItem *)self.model[i]).imagePath] options:nil];

        for(PHAsset * asset in fetchResult)
        {
            [PHImageManager.defaultManager requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                imageView.image = result;
            }];
        }
        [currentScrollView addSubview:imageView];
        [_scrollViews addObject:currentScrollView];
        [currentScrollView autorelease];
        [imageView autorelease];
        offset += 320;
    }
    for(NSInteger i = 0 ; i < _scrollViews.count ;i++)
    {
        [self.imageSiderScrollView addSubview:_scrollViews[i]];
    }
    
    [self.imageSiderScrollView setContentOffset:CGPointMake(320,0) animated:NO];
}

- (void)_setPreviousIndex
{
    NSInteger index = self.currentIndex == 0 ? self.model.count - 1 : self.currentIndex - 1;
    self.currentIndex = index;
    index--;
    _nextIndex = index < 0 ? self.model.count - 1 : index;
    NSLog(@"current index: %d next Index:%d",self.currentIndex, _nextIndex);
}
- (void)_setNextIndex
{
    NSInteger index = self.currentIndex == self.model.count - 1  ? 0 : self.currentIndex + 1;
    self.currentIndex = index;
    index++;
    _nextIndex = index > self.model.count - 1  ? 0 : index;
    NSLog(@"current index: %d next Index:%d",self.currentIndex, _nextIndex);
}

@end
