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
#import "JMPRhybridFeatureFinder.h"
#import "JMPRfundamentalMatrix.h"
#import "JMPRtriangulate.h"



using namespace cv;
using namespace std;

@implementation JMPRAppController

NSMutableArray *distArray = [[NSMutableArray alloc] init];

NSMutableArray *cameraArray = [[NSMutableArray alloc] init];

Mat cameraM = Mat::eye(3,3,CV_32F);
Mat distCoeff(5,1,CV_32F);

Mat img_1;
Mat img_2;

vector<Point2f> img_1_pts;
vector<Point2f> img_2_pts;

Matx34d P;
Matx34d P1;
Mat E;
Mat F;

Mat pts_3d;




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
    
    calibrateCamera(folderpath,1.35,distCoeff,cameraM);
    
    for ( int i = 0; i < distCoeff.cols; i ++)
    {
        vector<double> rowOneCoeff = distCoeff.row(0);
        
        NSNumber *numberincols = [[NSNumber alloc] initWithDouble:rowOneCoeff.at(i)];
        [distArray addObject:numberincols];
    }
  
    for (int i = 0; i < cameraM.rows;i++){
        
        vector<double> row = cameraM.row(i);
            for ( int j = 0; j < row.size();j++){
                NSNumber *number = [[NSNumber alloc]initWithDouble:row.at(j)];
                [cameraArray addObject:number];
                                    
        }
        
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

- (IBAction)getFundamentalMatrix:(id)sender
{
    fundamentalMatrix(img_1_pts, img_2_pts, cameraM, F, E, P, P1);
}

- (IBAction)trinagulatePoints:(id)sender
{
    JMPRtriangulatePoints(P, P1, img_1_pts, img_2_pts, pts_3d);
}

- (IBAction)featureFinder:(id)sender
{
    
    

    
    NSWindow *window = windowController;
    
    // Create and configure the panel.
    NSOpenPanel* panel = [NSOpenPanel openPanel];
    [panel setCanChooseDirectories:NO];
    [panel setAllowsMultipleSelection:YES];
    [panel setMessage:@"Select two images."];
    
    // Display the panel attached to the document's window.
    [panel beginSheetModalForWindow:window completionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton) {
            NSArray* urls = [panel URLs];
            if([urls count] <2 ){
                NSLog(@"Not enough images, must be two");
            }else if([urls count] > 2){
                NSLog(@"To many images, must be two");
            }else{
               
                NSString *img1path = [[NSString alloc] initWithFormat:@"%@",[urls[0] path]];
                string path_1([img1path UTF8String]);
                
               // NSImage *image_1 = [[NSImage alloc]initWithContentsOfURL:urls[0]];
                
                img_1 = imread(path_1);
                
                NSString *img2path = [[NSString alloc] initWithFormat:@"%@",[urls[1] path]];
                string path_2([img2path UTF8String]);
                
                img_2 = imread(path_2);
                Mat matchimg;
                
                cout<<"The images are loaded with : \n"<<path_1<<endl<<path_2<<endl;
                
                hybridFeatureFinder(img_1, img_2, cameraM,distCoeff ,img_1_pts, img_2_pts,matchimg);
                 
                imwrite("/Users/johndoe/Develop/statue_picture/matchImage.jpg", matchimg);
            }
            
            
            
        }
        
    }];
    
    
    
    
}

- (IBAction)printCoeffs:(id)sender
{
    NSLog(@"%@",distArray);
}

- (IBAction)importFilesAndDirectories:(id)sender {
    // Get the main window for the document.
    NSWindow *window = windowController;
    
    // Create and configure the panel.
    NSOpenPanel* panel = [NSOpenPanel openPanel];
    [panel setCanChooseDirectories:NO];
    [panel setAllowsMultipleSelection:YES];
    [panel setMessage:@"Import one or more files or directories."];
    
    // Display the panel attached to the document's window.
    [panel beginSheetModalForWindow:window completionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton) {
            NSArray* urls = [panel URLs];
            
            // Use the URLs to build a list of items to import.
        }
        
    }];
}


- (IBAction)printCamera:(id)sender
{
    NSLog(@"%@",cameraArray);
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
