//
//  JMPRAppController.m
//  openCVImplementation
//
//  Created by johndoe on 15/07/2014.
//  Copyright (c) 2014 Jens Martensson. All rights reserved.
//

#import "JMPRAppController.h"
#import "openCVtoImage.h"
#import "JMPRgetCamera.h"
#import "JMPRcalc3d.h"
#import <fstream>
#import "JMPRflannMatcher.h"
#import "JMPRfarnebackOf.h"
#import "JMPRcalibrateCamera.h"
#import "JMPRAppDelegate.h"


using namespace cv;

@implementation JMPRAppController

NSMutableArray *distArray = [[NSMutableArray alloc] init];



typedef struct CameraStruct
{
    cv::Mat CameraMatrix;
    cv::Mat ImagePoints;
    cv::Mat DistortionCoefficients;
    cv::Mat Image;
}CameraStruct;


typedef struct Calc3d
{
    cv::Matx34d P1;
    cv::Matx34d P2;
    std::vector<cv::Point3f> ImagePoints1;
    std::vector<cv::Point3f> ImagePoints2;
    cv::Mat Image;
    std::vector<cv::Point3f> pointCloud;
}Calc3d;

- (IBAction)findChessPattern:(id)sender
{

   // NSString *folderpath = @"/Users/johndoe/Develop/calib_chessboards";
    NSString *folderpath = [[NSString alloc]initWithFormat:@"%@",[folderPath stringValue]];
    
    Mat cameraM = Mat::eye(3,3,CV_32F);
    Mat distCoeff(5,1,CV_32F);
    
    calibrateCamera(folderpath,1.35,distCoeff,cameraM);
    for ( int i = 0; i < distCoeff.cols; i ++)
    {
        vector<double> rowOne = distCoeff.row(0);
        NSNumber *numberincols = [[NSNumber alloc] initWithDouble:rowOne.at(i)];
        [distArray addObject:numberincols];
        

        
        
        
        
    }
  
}


- (IBAction)chooseCheesboardFolder:(id)sender
{
    // Get the main window for the document.
    NSWindow* window = [self window];
    
    // Create and configure the panel.
    NSOpenPanel* panel = [NSOpenPanel openPanel];
    [panel setCanChooseDirectories:YES];
    [panel setAllowsMultipleSelection:YES];
    [panel setMessage:@"Import one or more files or directories."];
    
    // Display the panel attached to the document's window.
    [panel beginSheetModalForWindow:window completionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton) {
            NSURL *folder = [[panel URLs]objectAtIndex:0];
            NSString *thefolder = [[NSString alloc] initWithFormat:@"%@", [folder path]];
            [folderPath setStringValue:thefolder];
        }
        
    }];
}


- (IBAction)printCoeffs:(id)sender
{
    NSLog(@"%@",distArray);
}


- (IBAction)openImageOne:(id)sender
{
    NSOpenPanel* panel = [NSOpenPanel openPanel];
    
    [panel beginWithCompletionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton) {
            NSURL*  theDoc1 = [[panel URLs] objectAtIndex:0];
            NSString *theDoc1String = [[NSString alloc]initWithFormat:@"%@",[theDoc1 path]];
            NSImage *imageOne =[[NSImage alloc]initWithContentsOfURL:theDoc1];
            [imageViewOne setImage:imageOne];
            [pathLabelOne setStringValue:theDoc1String];
            
            
        }
        
    }];
}


- (IBAction)openImageTwo:(id)sender
{
    NSOpenPanel* panel = [NSOpenPanel openPanel];
    
    [panel beginWithCompletionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton) {
            NSURL*  theDoc2 = [[panel URLs] objectAtIndex:0];
            NSString *theDoc2String = [[NSString alloc]initWithFormat:@"%@",[theDoc2 path]];
            NSImage *imageTwo =[[NSImage alloc]initWithContentsOfURL:theDoc2];
            [imageViewTwo setImage:imageTwo];
            
            [pathLabelTwo setStringValue:theDoc2String];
        }
        
    }];
}


@end
