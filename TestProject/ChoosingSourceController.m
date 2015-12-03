//
//  ChoosingSourceController.m
//  TestProject
//
//  Created by Егор Сидоренко on 11/30/15.
//  Copyright © 2015 Егор Сидоренко. All rights reserved.
//

#import "ChoosingSourceController.h"
#import "ImageController.h"
#import "TravelModel.h"

@interface ChoosingSourceController()

@property (nonatomic) UIButton* libraryButton;
@property (nonatomic) UIButton* cameraButton;
@property (nonatomic) UIButton* cancelButton;
@property (nonatomic) int padding;
@end

@implementation ChoosingSourceController

- (int) padding {
    return 5;
}

-(UIButton*) libraryButton {
    if(!_libraryButton)
    {
       _libraryButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0 + self.padding, 280, self.view.bounds.size.width - self.padding * 2, 60)];
        [_libraryButton setBackgroundColor:[UIColor darkGrayColor]];
        [_libraryButton  setTitle:@"Library" forState:UIControlStateNormal];
        [_libraryButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_libraryButton addTarget:self action:@selector(goToLibraryView:) forControlEvents:UIControlEventTouchDown];
    }
    return _libraryButton;
}

-(UIButton*) cameraButton {
    if(!_cameraButton)
    {
        _cameraButton = [[UIButton alloc] initWithFrame:CGRectMake(0 + self.padding, 360, self.view.bounds.size.width - self.padding * 2, 60)];
        [_cameraButton setBackgroundColor:[UIColor darkGrayColor]];
        [_cameraButton  setTitle:@"Camera" forState:UIControlStateNormal];
        [_cameraButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cameraButton addTarget:self action:@selector(goToCameraView:) forControlEvents:UIControlEventTouchDown];
    }
    return _cameraButton;
}
-(UIButton*) cancelButton {
    if(!_cancelButton)
    {
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0 + self.padding, 450, self.view.bounds.size.width - self.padding * 2, 60)];
        [_cancelButton setBackgroundColor:[UIColor darkGrayColor]];
        [_cancelButton  setTitle:@"Cancel" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(goToPreviousView:) forControlEvents:UIControlEventTouchDown];
    }
    return _cancelButton;
}



-(void) viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.navigationController setNavigationBarHidden:YES];
    [self.view addSubview:self.libraryButton];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self.view addSubview:self.cameraButton];
    }
    [self.view addSubview:self.cancelButton];
}

-(void) viewDidUnload {
    [super viewDidUnload];
    self.libraryButton = nil;
    self.cameraButton = nil;
    self.cancelButton = nil;
}

-(void) goToLibraryView: (UIButton*) sender {
    ImageController* imgContr = [[ImageController alloc] initWithSetting:NO :self.model];
    [self.navigationController pushViewController: imgContr animated: YES];
    [imgContr release];
}

-(void) goToCameraView: (UIButton*) sender {
    [self.navigationController pushViewController: [[ImageController alloc] initWithSetting:YES :self.model] animated: YES];
}
-(void) goToPreviousView: (UIButton*) sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
