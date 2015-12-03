//
//  ImageController.m
//  TestProject
//
//  Created by Егор Сидоренко on 11/30/15.
//  Copyright © 2015 Егор Сидоренко. All rights reserved.
//

#import "ImageController.h"
#import "SoundRecordingController.h"
@import AssetsLibrary;
@interface ImageController()

@property (nonatomic) UIImageView* image;
@property (nonatomic) UIButton* doneButton;
@property (nonatomic) UIImagePickerController* picker;
@property (nonatomic) UITextField *imageName;

@property (nonatomic) BOOL initWithCamera;
@property (nonatomic) NSString* imageURL;

@end

@implementation ImageController

-(UIImagePickerController*) picker {
    if(!_picker) {
        _picker = [[UIImagePickerController alloc] init];
        if(self.initWithCamera) {
            [_picker setSourceType:UIImagePickerControllerSourceTypeCamera];
            [_picker setShowsCameraControls:YES];
        } else {
            [_picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
        
        [_picker setToolbarHidden:NO];
        _picker.delegate = self;
    }
    return _picker;
}

-(UITextField*) imageName {
    if(!_imageName) {
        _imageName = [[UITextField alloc] initWithFrame:CGRectMake(5.0, 210.0, self.view.bounds.size.width - 10, 40.0)];
        _imageName.layer.borderWidth = 0.5f;
        _imageName.layer.borderColor = [[UIColor darkGrayColor] CGColor];
        [_imageName setBackgroundColor:[UIColor whiteColor]];
        _imageName.layer.cornerRadius = 10;
    }
    return _imageName;
}

-(UIImageView*) image {
    if(!_image){
        _image = [[UIImageView alloc] init];
        _image.frame = self.view.frame;
    }
    return _image;
}

- (instancetype)initWithSetting:(BOOL) isCamera :(TravelModel*) model
{
    self = [super initWithModel:model];
    if (self) {
        self.initWithCamera = isCamera;
    }
    return self;
}

-(void) viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.imageName];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self presentViewController:self.picker animated:NO completion:NULL];
    [self.picker release];
    
}
-(void) viewDidUnload {
    [super viewDidUnload];
    self.image = nil;
    self.imageName = nil;
    
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSLog(@"PickImage");
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    self.image.image = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [self.view addSubview:self.image];
    
    [self.view bringSubviewToFront:self.imageName];
    [self.imageName becomeFirstResponder];
    [self.navigationController setNavigationBarHidden:NO];
    UIBarButtonItem* barBtn = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(goToNextView:)];
    self.navigationItem.rightBarButtonItem = barBtn;
    [barBtn release];
    NSURL *imageUrl = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
    NSString *imageName = [imageUrl lastPathComponent];
    NSString *docDirPath    = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    self.imageURL = [docDirPath stringByAppendingPathComponent:imageName];


}

-(void) goToNextView :(UIBarButtonItem *) sender {
    self.model.imageUrl = self.imageURL;
    self.model.name = self.imageName.text;
    SoundRecordingController* soundContrl = [[SoundRecordingController alloc] initWithModel:self.model];
   [self.navigationController pushViewController:soundContrl animated:YES];
    [soundContrl release];
}
@end
