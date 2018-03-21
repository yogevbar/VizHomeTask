//
//  ViewController.m
//  HomeProject
//
//  Created by Yogev Barber on 21/03/2018.
//  Copyright © 2018 Yogev Barber. All rights reserved.
//

#import "ViewController.h"
#import "Api.h"
#import "UIImage+Crop.h"
#import "FaceDetectModel.h"
#import "FaceRectangleModel.h"

#define INSTRUCTIONS_TEXT @"Select an image to detect emotion"
#define LOADING_TEXT @"Loading..."
#define IMAGE_BORDER_WIDTH 1.0
#define IMAGE_BORDER_COLOR [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3].CGColor

@interface ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) UIImage *currentImage;
@property (nonatomic, strong) UIImagePickerController *pickerViewController;
@property (nonatomic, strong) NSArray<FaceDetectModel*> *faces;

@property (weak, nonatomic) IBOutlet UIStackView *multiFacesStackView;
@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *lblEmotion;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
}

-(void)setupView{
    self.imageView.hidden = true;
    self.activityIndicator.hidden = true;
    self.imageView.layer.borderWidth = IMAGE_BORDER_WIDTH;
    self.imageView.layer.borderColor = IMAGE_BORDER_COLOR;
    self.lblEmotion.text = INSTRUCTIONS_TEXT;
    self.pickerViewController = [[UIImagePickerController alloc] init];
    self.pickerViewController.delegate = self;
    self.pickerViewController.allowsEditing = YES;
}

-(void)callApi:(UIImage*)image{
    if (!image) {
        return;
    }
    
    [Api getFaceElementsFromImage:image success:^(NSArray<FaceDetectModel *> *faces) {
        
        self.faces = faces;
        
        if (faces.count > 1) {
            [self updateMultipleFaces];
        }else{
            [self updateImageAndEmotionAtIndex:0];
        }
        
    } failure:^(NSError *error) {
        [self errorState:error];
    }];
}

- (IBAction)selectImageAction:(UIButton *)sender {
    [self.pickerViewController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:self.pickerViewController animated:YES completion:nil];
}

- (IBAction)takePhotoAction:(UIButton *)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.pickerViewController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.pickerViewController animated:YES completion:nil];
    } else {
        [self showPickerCameraError];
    }
}

-(void)showPickerCameraError{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Camera is not available" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:picker completion:nil];
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    self.currentImage = image;
    [self loadingState];
    [self callApi:image];
}

-(void)updateImageAndEmotionAtIndex:(NSInteger)index{
    FaceDetectModel *currentFace = self.faces[index];
    self.imageView.hidden = false;
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = true;
    [self.imageView setImage:[self.currentImage croppedImage:[currentFace.faceRectangle getRect]]];
    self.lblEmotion.text = [currentFace getStrongestEmotion];
}

-(void)updateMultipleFaces{
    if (self.multiFacesStackView.subviews.count) {
        [self removeMultiFacesStackViewFromView];
    }
    
    NSInteger index = 0;
    for(FaceDetectModel *face in self.faces){
        UIImage *image = [self.currentImage croppedImage:[face.faceRectangle getRect]];
        UIButton *imageViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        imageViewButton.layer.borderColor = IMAGE_BORDER_COLOR;
        imageViewButton.layer.borderWidth = IMAGE_BORDER_WIDTH;
        imageViewButton.tag = index;
        [imageViewButton addTarget:self action:@selector(replaceFace:) forControlEvents:UIControlEventTouchUpInside];
        [imageViewButton setBackgroundImage:image forState:UIControlStateNormal];
        [imageViewButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [imageViewButton addConstraint:[NSLayoutConstraint
                                      constraintWithItem:imageViewButton
                                      attribute:NSLayoutAttributeHeight
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:imageViewButton
                                      attribute:NSLayoutAttributeWidth
                                      multiplier:1
                                      constant:0]];
        [self.multiFacesStackView addArrangedSubview:imageViewButton];
        index++;
    }
    
    self.multiFacesStackView.hidden = false;
    [self updateImageAndEmotionAtIndex:0];
}

-(void)removeMultiFacesStackViewFromView{
    for(UIView *view in self.multiFacesStackView.subviews){
        [view removeFromSuperview];
    }
    self.multiFacesStackView.hidden = true;
}

-(void)replaceFace:(UIButton*)button{
    [self updateImageAndEmotionAtIndex:button.tag];
}

-(void)loadingState{
    self.multiFacesStackView.hidden = true;
    self.imageView.hidden = true;
    self.activityIndicator.hidden = false;
    [self.activityIndicator startAnimating];
    self.lblEmotion.text = LOADING_TEXT;
}

-(void)errorState:(NSError*)error{
    NSLog(@"%@", error.localizedDescription);
    self.imageView.hidden = true;
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = true;
    self.lblEmotion.text = [error localizedDescription];
}
@end
