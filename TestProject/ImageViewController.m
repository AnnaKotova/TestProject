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
@interface ImageViewController()

@property (nonatomic, retain) UIImageView * image;
@property (nonatomic, retain) UIButton * doneButton;
@property (nonatomic, retain) UIImagePickerController * picker;
@property (nonatomic, retain) UITextField * imageName;

@property (nonatomic) BOOL initWithCamera;
@property (nonatomic, copy) NSString * imageURL;
@property (nonatomic) int keyboardOffset;

@end

@implementation ImageViewController

-(UIImagePickerController *) picker
{
    if(!_picker)
    {
        _picker = [[[UIImagePickerController alloc] init] autorelease];
        if(self.initWithCamera)
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

-(int) keyboardOffset
{
    return 80;
}

-(UITextField *) imageName
{
    if(!_imageName)
    {
        _imageName = [[[UITextField alloc] initWithFrame: CGRectMake(5.0, 210.0, self.view.bounds.size.width - 10, 40.0)] autorelease];
        _imageName.layer.borderWidth = 0.5f;
        _imageName.layer.borderColor = [[UIColor darkGrayColor] CGColor];
        [_imageName setBackgroundColor: [UIColor whiteColor]];
        _imageName.layer.cornerRadius = 10;
    }
    return _imageName;
}

-(UIImageView*) image
{
    if(!_image)
    {
        _image = [[[UIImageView alloc] init] autorelease];
        _image.frame = self.view.frame;
    }
    return _image;
}

- (instancetype)initWithSetting:(TravelItem *) travelItemModel
{
    self = [super initWithModel:travelItemModel];
    return self;
}

-(void) viewDidLoad
{
    [super viewDidLoad];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle: @"!" message: @"" preferredStyle: UIAlertActionStyleDefault];

    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:
    ^(UIAlertAction * _Nonnull action)
    {
        [self backToPreviousController];
    }];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIAlertAction* showCameraAction = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:
        ^(UIAlertAction* _Nonnull action)
        {
            self.initWithCamera = YES;
            [self showLibrary];
        }];
        [alert addAction:showCameraAction];
    }
    
    UIAlertAction* showLibraryAction = [UIAlertAction actionWithTitle:@"Library" style:UIAlertActionStyleDefault handler:
    ^(UIAlertAction* _Nonnull action)
    {
        self.initWithCamera = NO;
        [self showLibrary];
    }];
    
    [alert addAction: showLibraryAction];
    [alert addAction: cancelAction];
    [self presentViewController: alert animated: YES completion: nil];

    
    [self.view addSubview: self.imageName];
    [self.view setBackgroundColor: [UIColor whiteColor]];
    
}

-(void) backToPreviousController
{
    [self.navigationController popViewControllerAnimated: YES];
    [DataSource.sharedDataSource removeTravelItem: self.travelItemModel];
}

-(void) viewDidUnload
{
    [super viewDidUnload];
    self.image = nil;
    self.imageName = nil;
    
}
-(void) showLibrary
{
    [self presentViewController: self.picker animated: NO completion: NULL];
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    self.image.image = chosenImage;
    [picker dismissViewControllerAnimated: YES completion: NULL];
    
    [self.view addSubview: self.image];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyyMMddhhmm"];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg",[dateFormatter stringFromDate:[NSDate date]]];
    NSString* filePath =[NSHomeDirectory() stringByAppendingPathComponent: [NSString stringWithFormat: @"Documents/%@", fileName]];
    
    if(![UIImageJPEGRepresentation(chosenImage, 1.0) writeToFile: filePath atomically: YES] )
    {
        NSLog(@"File isn't saved");
    }
    else
    {
        self.travelItemModel.imageUrl = filePath;
        [self.view bringSubviewToFront: self.imageName];
        [self.imageName becomeFirstResponder];
        [self.navigationController setNavigationBarHidden: NO];
        
        UIBarButtonItem* barBtn = [[UIBarButtonItem alloc] initWithTitle:@"Next" style: UIBarButtonItemStyleDone target: self action: @selector(goToNextView:)];
        self.navigationItem.rightBarButtonItem = barBtn;
        [barBtn release];
    }



}
-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self backToPreviousController];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(keyboardWillShow) name: UIKeyboardWillShowNotification object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(keyboardWillHide) name: UIKeyboardWillHideNotification object: nil];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver: self name: UIKeyboardWillShowNotification object: nil];
    [[NSNotificationCenter defaultCenter] removeObserver: self name: UIKeyboardWillHideNotification object: nil];
}
-(void) goToNextView :(UIBarButtonItem *) sender
{
    self.travelItemModel.name = self.imageName.text;
    SoundRecordingViewController* soundContrl = [[SoundRecordingViewController alloc] initWithModel: self.travelItemModel];
   [self.navigationController pushViewController: soundContrl animated: YES];
    [soundContrl release];
    [self keyboardWillHide];
}

-(void) keyboardWillShow
{
    [UIView beginAnimations: nil context: NULL];
    [UIView setAnimationDuration: 0.0];
    CGRect rect = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y + self.keyboardOffset, self.view.bounds.size.width, self.view.bounds.size.height + self.keyboardOffset);
    self.view.bounds = rect;
    [UIView commitAnimations];
}

-(void) keyboardWillHide
{
    [UIView beginAnimations: nil context: NULL];
    [UIView setAnimationDuration: 0.0];
    CGRect rect = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y - self.keyboardOffset, self.view.bounds.size.width, self.view.bounds.size.height - self.keyboardOffset);
    self.view.bounds = rect;
    [UIView commitAnimations];
}
@end
