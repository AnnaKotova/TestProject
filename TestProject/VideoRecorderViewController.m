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
}

@end

@implementation VideoRecorderViewController

#pragma mark - ViewController Life Cycle

- (instancetype)initWithModel:(TravelItem *)travelItemModel
{
    self = [super init];
    if(self)
    {
        self.travelItemModel = travelItemModel;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _videorecorderImagePickerController = [[UIImagePickerController alloc] init];
    _videorecorderImagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    NSArray * mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    _videorecorderImagePickerController.mediaTypes = mediaTypes;
    [mediaTypes release];
    _videorecorderImagePickerController.allowsEditing = NO;
    _videorecorderImagePickerController.delegate = self;
    [self presentViewController: _videorecorderImagePickerController animated: NO completion: NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [_videorecorderImagePickerController release];
    [super dealloc];
}


#pragma mark - ImagePicker delegates

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSURL * url = [info objectForKey:UIImagePickerControllerMediaURL];
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^
     {
         PHAssetChangeRequest* assetChangeRequest = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:url];
         self.travelItemModel.videoUrl = [[assetChangeRequest placeholderForCreatedAsset] localIdentifier];
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
                completionHandler:^(BOOL success, NSError *error)
     {
         if (!success)
         {
             NSLog(@"Image From Camera not saved !!");
         }
     }];
    [_videorecorderImagePickerController dismissViewControllerAnimated:YES completion:^{}];
    
    
}




@end
