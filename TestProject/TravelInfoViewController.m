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

@property (nonatomic) TravelCollection* model;
@property (nonatomic) int index;
@property (nonatomic) UIImageView* backgroundView;
@property (nonatomic) AVAudioPlayer* audioPlayer;

@end

@implementation TravelInfoViewController

- (instancetype)initWithModel:(TravelCollection*) model andCurrentIndex:(int) index
{
    self = [super init];
    if(self) {
        self.model = model;
        self.index = index;
        //NSLog(@"%@, %f , %f , %@",model.name, model.latitude,model.longitude,model.imageUrl);
    }
    return self;
}

-(UIImageView*) backgroundView {
    if(!_backgroundView) {
        //UIImage* image = [[UIImage alloc] ini:self.model.imageUrl];
        //NSLog(@"%@", self.model.imageUrl);
        //NSData* imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:self.model.imageUrl ofType:@"image"]];
        //UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfFile:imageData]];
        _backgroundView = [[UIImageView alloc] initWithFrame:self.view.frame];
        //_backgroundView.image = image;
    }
    return  _backgroundView;
}

- (void)viewDidLoad {
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
    
    // Do any additional setup after loading the view.
}

-(void) initViewValues {
    if(self.index < 0 ) self.index = self.model.travelPoints.count -1;
    else if (self.index >= self.model.travelPoints.count) self.index = 0;
    TravelModel* displayModel = (TravelModel*)self.model.travelPoints[self.index];
    [self setTitle:displayModel.name];
    //NSLog(displayModel.imageUrl);
    NSData* imgData = [NSData dataWithContentsOfFile:@"/asset.JPG"];
    UIImage* image = [UIImage imageWithData:imgData];
    self.backgroundView.image =image;
    //[image release];
   /* ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    __block UIImage *returnValue = nil;
    NSURL* url = [NSURL URLWithString:displayModel.imageUrl];
    [library assetForURL:url resultBlock:^(ALAsset *asset) {
        returnValue = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
    } failureBlock:^(NSError *error) {
        NSLog(@"error : %@", error);
    }];
    self.backgroundView.image = returnValue;*/
}
- (void) actionSwipeLeft:(UISwipeGestureRecognizer*) gestureRecognizer{
    self.index--;
    [self initViewValues];
}
- (void) actionSwipeRight:(UISwipeGestureRecognizer*) gestureRecognizer{
    self.index++;
        [self initViewValues];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
