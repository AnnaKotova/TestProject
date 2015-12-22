//
//  VideoRecorderViewController.m
//  TestProject
//
//  Created by User on 12/21/15.
//  Copyright © 2015 Егор Сидоренко. All rights reserved.
//

#import "VideoRecorderViewController.h"


@interface VideoRecorderViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIImagePickerController * _videorecorderImagePickerController;
    AVPlayerViewController * _mediaPlayer;
}

@end

@implementation VideoRecorderViewController

- (instancetype)initWithModel:(TravelItem *)travelItemModel
{
    self = [super init];
    if(self)
    {
        self.travelItemModel = travelItemModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _videorecorderImagePickerController = [[UIImagePickerController alloc] init];
    _videorecorderImagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    NSArray * mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    _videorecorderImagePickerController.mediaTypes = mediaTypes;
    [mediaTypes release];
    _videorecorderImagePickerController.allowsEditing = NO;
    _videorecorderImagePickerController.delegate = self;
    [self presentViewController: _videorecorderImagePickerController animated: NO completion: NULL];
    
    _mediaPlayer = [[AVPlayerViewController alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    [_videorecorderImagePickerController release];
    [super dealloc];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [DataSource.sharedDataSource removeTravelItem:self.travelItemModel];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info  {
    NSURL * url = [info objectForKey:UIImagePickerControllerMediaURL];
    UISaveVideoAtPathToSavedPhotosAlbum([url absoluteString],nil,nil,nil);
    self.travelItemModel.videoUrl = [url absoluteString];
    [_videorecorderImagePickerController dismissViewControllerAnimated:YES completion:^{}];
    //_mediaPlayer
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
