//
//  TravelInfoViewController.m
//  TestProject
//
//  Created by Егор Сидоренко on 12/2/15.
//  Copyright © 2015 Егор Сидоренко. All rights reserved.
//

#import "TravelInfoViewController.h"

@interface TravelInfoViewController () <AVAudioPlayerDelegate, UIScrollViewDelegate>
{
    CGFloat _lastContentOffset;
    NSMutableArray<__kindof UIView *> * _imageViewArray;
    NSInteger _nextIndex;
}

@property (nonatomic, retain) NSArray * model;
//@property (nonatomic, retain) UIImageView * backgroundImageView;
@property (nonatomic, retain) UISlider * sliderView;
@property (nonatomic, retain) AVAudioPlayer * audioPlayer;
@property (nonatomic, retain) UIButton * playButton;
@property (nonatomic, retain) NSTimer * playTimer;
@property (nonatomic, retain) UIScrollView * imageSiderScrollView;
@property (nonatomic) ScrollDirection scrollDirection;


@property (nonatomic) NSInteger currentIndex;

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
    [self _setupViewValues];
    [self _setupScrollView];
    [self.view addSubview:self.imageSiderScrollView];
    
    
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
        self.currentIndex = index;
    }
    return self;
}

- (UIScrollView *) imageSiderScrollView
{
    if(!_imageSiderScrollView)
    {
        CGFloat verticalOffset = CGRectGetMinY(self.navigationController.navigationBar.frame) + CGRectGetHeight(self.navigationController.navigationBar.frame);
        _imageSiderScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds) , CGRectGetHeight(self.view.bounds))];
        _imageSiderScrollView.contentSize = CGSizeMake(CGRectGetWidth(_imageSiderScrollView.bounds) * 3, CGRectGetHeight(self.view.bounds));
        _imageSiderScrollView.showsVerticalScrollIndicator = NO;
        _imageSiderScrollView.delegate = self;
        _imageSiderScrollView.pagingEnabled = YES;
        _imageSiderScrollView.autoresizesSubviews = YES;
        _imageSiderScrollView.clipsToBounds = YES;
        
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


//-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    /*[_imageViewArray enumerateObjectsUsingBlock:^(__kindof UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
     {
         NSLog(@"ImageVie %d frame in scroll : %@",idx,NSStringFromCGRect(obj.frame));
     }];
    return;*/
    
     //NSInteger yOffset = self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height;
    if(scrollView.contentOffset.x == 0)
    {
         [self _setPreviousIndex];
        for (NSInteger i = 0 ; i < _imageViewArray.count; i++)
        {
            UIImageView * imageView = _imageViewArray[i];
            CGRect frameRectangel = imageView.frame;
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
                    UIImage * image = [[UIImage alloc] initWithContentsOfFile:((TravelItem *)self.model[_nextIndex]).imagePath];
                    imageView.image = image;
                    [image release];
                    break;
            }
            //frameRectangel.origin.y = -20;
            imageView.frame = frameRectangel;
        }
        self.title = ((TravelItem *)self.model[self.currentIndex]).name;
    }
    if (scrollView.contentOffset.x == 640)
    {
        [self _setNextIndex];
        for (NSInteger i = 0 ; i < _imageViewArray.count; i++)
        {
            UIImageView * imageView = _imageViewArray[i];
            CGRect frameRectangel = imageView.frame;
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
                    UIImage * image = [[UIImage alloc] initWithContentsOfFile:((TravelItem *)self.model[_nextIndex]).imagePath];
                    imageView.image = image;
                    [image release];
                    frameRectangel.origin.x = 640;
                    break;
            }
            imageView.frame = frameRectangel;
        }
           }
    [scrollView setContentOffset:CGPointMake(320, 0)];
}

#pragma mark - Private Section

- (void)_deleteButtonAction:(UIBarButtonItem *) button
{
    [DataSource.sharedDataSource removeTravelItem:(TravelItem *)self.model[self.currentIndex]];
    [self.navigationController popViewControllerAnimated:YES];
    [DataSource.sharedDataSource saveContexChanges];
    [[NSFileManager defaultManager] removeItemAtPath:((TravelItem *)self.model[self.currentIndex]).imagePath error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:((TravelItem *)self.model[self.currentIndex]).soundPath error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:((TravelItem *)self.model[self.currentIndex]).thumbnailPath error:nil];
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
    
    NSData * soundData = [NSData dataWithContentsOfFile:displayModel.soundPath];
    self.audioPlayer =[[[AVAudioPlayer alloc] initWithData:soundData error:nil] autorelease];
    [self.audioPlayer setDelegate:self];
    
    self.sliderView.maximumValue = self.audioPlayer.duration;
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
    self.currentIndex--;
    [self _setupViewValues];
}

- (void)_actionSwipeRight:(UISwipeGestureRecognizer *) gestureRecognizer
{
    self.currentIndex++;
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

- (void)_setupScrollView
{
    _imageViewArray = [[NSMutableArray alloc] init];
    int offset = 0;
    int counter = 0;
    //NSInteger yOffset = self.navigationController.navigationBar.frame.origin.y + self.navigationController.navigationBar.frame.size.height;
     NSLog(@"%d", [self.imageSiderScrollView subviews].count);
    //CGFloat verticalOffset = CGRectGetMinY(self.navigationController.navigationBar.frame) + CGRectGetHeight(self.navigationController.navigationBar.frame);
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
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(offset , 0, CGRectGetWidth(self.imageSiderScrollView.layer.bounds), CGRectGetHeight(self.imageSiderScrollView.layer.bounds) - 0)];
        UIImage * image = [UIImage imageWithContentsOfFile:((TravelItem *)self.model[i]).imagePath];
        imageView.image = image;

        [_imageViewArray addObject:imageView];
        [imageView autorelease];
        offset += 320;
    }

    for(NSInteger i = 0 ; i < _imageViewArray.count ;i++)
    {
        [self.imageSiderScrollView addSubview:_imageViewArray[i]];
    }
    NSLog(@"%d", [self.imageSiderScrollView subviews].count);
    [self.imageSiderScrollView setContentOffset:CGPointMake(320,0) animated:YES];
}

- (void)_setPreviousIndex
{
    NSInteger index = self.currentIndex == 0 ? self.model.count - 1 : self.currentIndex - 1;
    self.currentIndex = index;
    index--;
    _nextIndex = index < 0 ? self.model.count - 1 : index;
}
- (void)_setNextIndex
{
    NSInteger index = self.currentIndex == self.model.count - 1  ? 0 : self.currentIndex + 1;
    self.currentIndex = index;
    index++;
    _nextIndex = index > self.model.count - 1  ? 0 : index;
}

@end
