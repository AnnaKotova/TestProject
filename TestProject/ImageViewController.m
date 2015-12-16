//
//  ImageController.m
//  TestProject
//
//  Created by Егор Сидоренко on 11/30/15.
//  Copyright © 2015 Егор Сидоренко. All rights reserved.
//

#import "ImageViewController.h"
#import "SoundRecordingViewController.h"
#import "MapViewController.h"
@interface ImageViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
   // float _bbb;
    //NSObject * _obj;
}
@property (atomic, readwrite, retain) NSObject * obj;

@property (nonatomic, retain) UIImageView * pickedImageView;
@property (nonatomic, retain) UIButton * doneButton;
@property (nonatomic, retain) UIImagePickerController * picker;
@property (nonatomic, retain) UITextField * imageNameTextField;

@property (nonatomic) BOOL isGetPictureFromCamera;
@property (nonatomic, copy) NSString * imagePath;
@property (nonatomic) int keyboardOffset;

//@property float aaa;
@end


@implementation ImageViewController

#pragma mark - UIViewController Life Cycle

- (instancetype)initWithSetting:(TravelItem *) travelItemModel
{
    self = [super initWithModel:travelItemModel];
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    UIAlertController * alert = [UIAlertController alertControllerWithTitle: @"" message: @"" preferredStyle: UIAlertControllerStyleActionSheet];

    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action)
                                                                {
                                                                    [self _backButtonAction];
                                                                }];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIAlertAction * showCameraAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Camera", nil)
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * _Nonnull action)
                                                                        {
                                                                            self.isGetPictureFromCamera = YES;
                                                                            [self _libraryButtonAction];
                                                                        }];
        [alert addAction:showCameraAction];
    }
    
    UIAlertAction * showLibraryAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Library", nil)
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction* _Nonnull action)
                                                                    {
                                                                        self.isGetPictureFromCamera = NO;
                                                                        [self _libraryButtonAction];
                                                                    }];
    
    [alert addAction: showLibraryAction];
    [alert addAction: cancelAction];
    [self presentViewController: alert animated: YES completion: nil];

    
    UIBarButtonItem * backBtn =[[[UIBarButtonItem alloc]initWithTitle:@"Back"
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(_backButtonAction)] autorelease];
    self.navigationItem.leftBarButtonItem = backBtn;
    
    [self.view addSubview: self.imageNameTextField];
    [self.view setBackgroundColor: [UIColor whiteColor]];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(_keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.pickedImageView = nil;
    self.imageNameTextField = nil;
    
}

#pragma mark - Properties Setters and Getters

- (UIImagePickerController *) picker
{
    if(!_picker)
    {
        _picker = [[UIImagePickerController alloc] init] ;
        if(self.isGetPictureFromCamera)
        {
            [_picker setSourceType: UIImagePickerControllerSourceTypeCamera];
            [_picker setShowsCameraControls: YES];
        }
        else
        {
            [_picker setSourceType: UIImagePickerControllerSourceTypePhotoLibrary];
        }
        
        _picker.delegate = self;
    }
    
    return _picker;
}

- (int) keyboardOffset
{
    return 80;
}

- (UITextField *) imageNameTextField
{
    if(!_imageNameTextField)
    {
        _imageNameTextField = [[[UITextField alloc] initWithFrame: CGRectMake(5.0, 210.0, self.view.bounds.size.width - 10, 40.0)] autorelease];
        _imageNameTextField.layer.borderWidth = 0.5f;
        _imageNameTextField.layer.borderColor = [[UIColor darkGrayColor] CGColor];
        [_imageNameTextField setBackgroundColor: [UIColor whiteColor]];
        _imageNameTextField.layer.cornerRadius = 10;
        [_imageNameTextField setHidden:YES];
    }
    return _imageNameTextField;
}

- (UIImageView *) pickedImageView
{
    if(!_pickedImageView)
    {
        _pickedImageView = [[[UIImageView alloc] init] autorelease];
        _pickedImageView.frame = self.view.frame;
    }
    return _pickedImageView;
}

#pragma mark - UIImagePicker Delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    UIImage * chosenImage = info[UIImagePickerControllerOriginalImage];
    self.pickedImageView.image = chosenImage;
    [picker dismissViewControllerAnimated: YES completion: NULL];
    
    [self.view addSubview: self.pickedImageView];
    NSDateFormatter * dateFormatter = [[NSDateFormatter new] autorelease];
    [dateFormatter setDateFormat: @"yyyyMMddhhmm"];
    NSString * fileName = [NSString stringWithFormat:@"%@.jpg",[dateFormatter stringFromDate:[NSDate date]]];
    NSString * filePath =[NSHomeDirectory() stringByAppendingPathComponent: [NSString stringWithFormat: @"Documents/%@", fileName]];
    
    if(![UIImageJPEGRepresentation(chosenImage, 1.0) writeToFile: filePath atomically: YES] )
    {
        NSLog(@"File isn't saved");
    }
    else
    {
        self.travelItemModel.imageUrl = filePath;
        [self.view bringSubviewToFront: self.imageNameTextField];
        [self.imageNameTextField becomeFirstResponder];
        [self.navigationController setNavigationBarHidden: NO];
        
        UIBarButtonItem * barBtn = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Next", nil)
                                                                     style:UIBarButtonItemStyleDone
                                                                    target:self
                                                                    action:@selector(_nextButtonAction:)] autorelease];
        self.navigationItem.rightBarButtonItem = barBtn;
        
    }
    self.imageNameTextField.hidden = NO;


}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self _backButtonAction];
}

#pragma mark - Private Actions

- (void)_backButtonAction
{
    [self.navigationController popViewControllerAnimated: YES];
    [DataSource.sharedDataSource removeTravelItem: self.travelItemModel];
}

- (void)_libraryButtonAction
{
    [self presentViewController: self.picker animated: NO completion: NULL];
}
- (void)_nextButtonAction:(UIBarButtonItem *) sender
{
    self.travelItemModel.name = self.imageNameTextField.text;
    SoundRecordingViewController * soundContrl = [[[SoundRecordingViewController alloc] initWithModel: self.travelItemModel] autorelease];
   [self.navigationController pushViewController:soundContrl animated:YES];
    [self _keyboardWillHide];
}

- (void)_keyboardWillShow
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration: 0.0];
    CGRect rect = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y + self.keyboardOffset, self.view.bounds.size.width, self.view.bounds.size.height + self.keyboardOffset);
    self.view.bounds = rect;
    [UIView commitAnimations];
}

- (void)_keyboardWillHide
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration: 0.0];
    CGRect rect = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y - self.keyboardOffset, self.view.bounds.size.width, self.view.bounds.size.height - self.keyboardOffset);
    self.view.bounds = rect;
    [UIView commitAnimations];
}
@end
