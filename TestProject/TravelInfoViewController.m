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
    NSMutableArray<__kindof UIScrollView *> * _scrollViews;
    BOOL _isBackButtonClicked;
    BOOL _isDeleteButtonClicked;
    BOOL _isScrolableView;
    AVPlayer * _mediaAVPlayer;
    NSInteger _modelCounter;
}

@property (nonatomic) NSInteger countOfTravelItems;
@property (nonatomic) NSInteger currentOffset;
@property (nonatomic) TravelItem * travelItem;
@property (nonatomic, retain) NSMutableArray * travelArray;
@property (nonatomic, retain) UISlider * sliderView;
@property (nonatomic, retain) AVAudioPlayer * audioPlayer;
@property (nonatomic, retain) UIButton * playButton;
@property (nonatomic, retain) NSTimer * playTimer;
@property (nonatomic, retain) UIScrollView * imageSiderScrollView;
@property (nonatomic, copy) NSString * projectPath;


@property (nonatomic) NSInteger currentIndex;

@end

@implementation TravelInfoViewController

#pragma mark - UIViewController Lifecycle

- (void)dealloc
{
    [self.travelArray release];
    [_scrollViews release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    

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
    if (_isScrolableView)
    {
        self.countOfTravelItems = [DataSource.sharedDataSource getCountOfTravelItems];
        [self.travelArray addObject:[self _getTravelItemFromDataSource:self.currentOffset - 1]];
        [self.travelArray addObject:[self _getTravelItemFromDataSource:self.currentOffset]];
        [self.travelArray addObject:[self _getTravelItemFromDataSource:self.currentOffset + 1]];
    }
    
    [self _setupViewValues];
    [self _setupScrollView];
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
        self.currentOffset = index;
        _isScrolableView = YES;
        NSArray * dirPaths;
        dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.projectPath = dirPaths[0];
        _modelCounter = 3;
        self.currentIndex = 1;
    }
    return self;
}

- (instancetype)initWithTravelModel:(TravelItem *) model
{
    self = [super init];
    if(self)
    {
        _modelCounter = 1;
        [self.travelArray addObject:model];
        self.currentIndex = 0;
        _isScrolableView = NO;
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
        _imageSiderScrollView.contentSize = CGSizeMake(CGRectGetWidth(_imageSiderScrollView.bounds) * _modelCounter, CGRectGetHeight(_imageSiderScrollView.bounds));
        _imageSiderScrollView.showsVerticalScrollIndicator = NO;
        _imageSiderScrollView.delegate = self;
        _imageSiderScrollView.pagingEnabled = YES;
        _imageSiderScrollView.autoresizesSubviews = NO;
        _imageSiderScrollView.clipsToBounds = NO;
        if(!_isScrolableView)
        {
            _imageSiderScrollView.scrollEnabled = NO;
        }
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


- (NSMutableArray *)travelArray
{
    if(!_travelArray)
    {
        _travelArray = [[[NSMutableArray alloc] init] retain];
    }
    return _travelArray;
}

#pragma mark - UIScroll Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(self.imageSiderScrollView == scrollView)
    {
        if(scrollView.contentOffset.x == 0)
        {
            //[self _setPreviousIndex];
            self.currentOffset = [self _getPreviousOffset];
            TravelItem * item = [self _getTravelItemFromDataSource:self.currentOffset - 1];
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
                        [self.travelArray removeObjectAtIndex:0];
                        [self.travelArray insertObject:item atIndex:0];
                        frameRectangel.origin.x = 0;
                        PHFetchResult * fetchResult = [PHAsset fetchAssetsWithLocalIdentifiers:@[item.imagePath] options:nil];

                        for(PHAsset * asset in fetchResult)
                        {
                            [PHImageManager.defaultManager requestImageForAsset:asset
                                                                     targetSize:PHImageManagerMaximumSize
                                                                    contentMode:PHImageContentModeDefault
                                                                        options:nil
                                                                  resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info)
                            {
                                imageView.image = result;
                            }];
                        }
                        break;
                }
                scrView.frame = frameRectangel;
            }
        }
        else if (scrollView.contentOffset.x == 640)
        {
            self.currentOffset = [self _getNextOffset];
            TravelItem * item = [self _getTravelItemFromDataSource:self.currentOffset + 1];
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
                        [self.travelArray removeObjectAtIndex:2];
                        [self.travelArray addObject:item];
                        self.title = ((TravelItem *)self.travelArray[self.currentIndex]).name;
                        PHFetchResult * fetchResult = [PHAsset fetchAssetsWithLocalIdentifiers:@[item.imagePath] options:nil];

                        for(PHAsset * asset in fetchResult)
                        {
                            [PHImageManager.defaultManager requestImageForAsset:asset
                                                                     targetSize:PHImageManagerMaximumSize
                                                                    contentMode:PHImageContentModeDefault
                                                                        options:nil
                                                                  resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                imageView.image = result;
                            }];
                        }
                        frameRectangel.origin.x = 640;
                        break;
                }
                scrView.frame = frameRectangel;
            }
        }
        [self _setupViewValues];
        [scrollView setContentOffset:CGPointMake(320, 0)];
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
    [DataSource.sharedDataSource removeTravelItem:(TravelItem *)self.travelArray[self.currentIndex]];
    [self.navigationController popViewControllerAnimated:YES];
    [DataSource.sharedDataSource saveContexChanges];
    NSString * soundFilePath = [self.projectPath stringByAppendingPathComponent:((TravelItem *)self.travelArray[self.currentIndex]).soundPath];
    [[NSFileManager defaultManager] removeItemAtPath:soundFilePath error:nil];
}

- (void)_setupViewValues
{
    if(self.currentIndex < 0 )
    {
        self.currentIndex = self.countOfTravelItems - 1;
    }
    else if (self.currentIndex >= self.countOfTravelItems)
    {
        self.currentIndex = 0;
    }
    
    [self.playTimer invalidate];
    
    if(self.audioPlayer)
    {
        [self.audioPlayer stop];
    }
    self.audioPlayer = nil;
    TravelItem * displayModel = (TravelItem *)self.travelArray[self.currentIndex];
    [self setTitle:displayModel.name];
    [self.playButton setHidden:NO];
    if (displayModel.soundPath != nil)
    {
        NSString * soundFilePath = [self.projectPath stringByAppendingPathComponent:displayModel.soundPath];
        
        NSData * soundData = [NSData dataWithContentsOfFile:soundFilePath];
        self.audioPlayer =[[[AVAudioPlayer alloc] initWithData:soundData error:nil] autorelease];
        [self.audioPlayer setDelegate:self];
        
        self.sliderView.maximumValue = self.audioPlayer.duration;
        self.sliderView.value = 0.0f;
        if (!self.audioPlayer)
        {
            self.playButton.enabled = NO;
            self.sliderView.enabled = NO;
        }
        [self.sliderView becomeFirstResponder];
        [self.sliderView setHidden:NO];
    }
    else if( displayModel.videoUrl != nil)
    {
        PHFetchResult * fetchResult = [PHAsset fetchAssetsWithLocalIdentifiers:@[displayModel.videoUrl] options:nil];

        for(PHAsset * asset in fetchResult)
        {
            [PHImageManager.defaultManager requestPlayerItemForVideo:asset options:nil resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
                _mediaAVPlayer = [[AVPlayer alloc] initWithPlayerItem:playerItem];
            }];
        }
        [self.sliderView setHidden:YES];
    }
    else
    {
        [self.playButton setHidden:YES];
        [self.sliderView setHidden:YES];
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
                                                        selector: @selector(_updateTimeTimerAction:)
                                                        userInfo: nil
                                                         repeats: YES];
        
        self.audioPlayer.currentTime = self.sliderView.value;
        [self.audioPlayer play];
        
    }
    else
    {
        AVPlayerViewController * playerController = [[AVPlayerViewController alloc] init];
        playerController.player = _mediaAVPlayer;
        [self presentViewController:playerController animated:YES completion:nil];
        [playerController release];
    }
}

- (void)_setupScrollView
{
    _scrollViews = [[NSMutableArray alloc] init];
    int offset = 0;
    int counter = 0;
    
    for(NSInteger i = 0 ;counter < _modelCounter ; i++, counter++)
    {
        if(i < 0)
        {
            i = self.countOfTravelItems - 1;
        }
        
        if(i >= self.countOfTravelItems)
        {
            i = 0;
        }
        UIScrollView * currentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(offset ,0, CGRectGetWidth(self.imageSiderScrollView.layer.bounds), CGRectGetHeight(self.imageSiderScrollView.layer.bounds))];
        currentScrollView.contentSize = currentScrollView.bounds.size;
        currentScrollView.maximumZoomScale = 6.0;
        currentScrollView.minimumZoomScale = 0.5;
        currentScrollView.delegate = self;
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0 ,0, CGRectGetWidth(self.imageSiderScrollView.layer.bounds), CGRectGetHeight(self.imageSiderScrollView.layer.bounds))];
       
        PHFetchResult * fetchResult = [PHAsset fetchAssetsWithLocalIdentifiers:@[((TravelItem *)self.travelArray[i]).imagePath] options:nil];

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
    if(_isScrolableView )
    {
        [self.imageSiderScrollView setContentOffset:CGPointMake(320,0) animated:NO];
    }
}

- (NSInteger)_getNextOffset
{
    return self.currentOffset == self.countOfTravelItems - 1  ? 0 : self.currentOffset + 1;
}

-(NSInteger)_getPreviousOffset
{
    return self.currentOffset == 0 ? self.countOfTravelItems - 1 : self.currentOffset - 1;
}
- (TravelItem *)_getTravelItemFromDataSource : (NSInteger) offset
{
    
    if(offset < 0)
    {
        offset = self.countOfTravelItems - 1;
    }
    if(offset >= self.countOfTravelItems)
    {
        offset = 0;
    }
    return [DataSource.sharedDataSource getTravelItem:offset];
}

@end
