//
//  JMPRAppController.m
//  openCVImplementation
//
//  Created by johndoe on 15/07/2014.
//  Copyright (c) 2014 Jens Martensson. All rights reserved.
//

#import "JMPRAppController.h"
#import "openCVtoImage.h"
#import <fstream>
#import "JMPRcalibrateCamera.h"
#import "JMPRAppDelegate.h"
#import "JMPRhybridFeatureFinder.h"
#import "JMPRfundamentalMatrix.h"
#import "JMPRtriangulate2.h"



using namespace cv;
using namespace std;

@implementation JMPRAppController

NSMutableArray *distArray = [[NSMutableArray alloc] init];

NSMutableArray *cameraArray = [[NSMutableArray alloc] init];

Mat K = Mat::eye(3,3,CV_64F);
Mat Kinv = K.inv();
Mat distCoeff(5,1,CV_64F);

Mat img_1;
Mat img_2;

vector<Point2f> img_1_pts;
vector<Point2f> img_2_pts;

Matx34d P;
Matx34d P1;
Mat E;
Mat F;

Mat pts_3d;

vector<Point3d> pointCloud;



typedef struct CameraStruct
{
    cv::Mat CameraMatrix;
    cv::Mat ImagePoints;
    cv::Mat DistortionCoefficients;
    cv::Mat Image;
}CameraStruct;




- (IBAction)findChessPattern:(id)sender
{

   // NSString *folderpath = @"/Users/johndoe/Develop/calib_chessboards";
    NSString *folderpath = [[NSString alloc]initWithFormat:@"%@",[folderPath stringValue]];
    
    calibrateCamera(folderpath,1,distCoeff,K);
    
    for ( int i = 0; i < distCoeff.cols; i ++)
    {
        vector<double> rowOneCoeff = distCoeff.row(0);
        
        NSNumber *numberincols = [[NSNumber alloc] initWithDouble:rowOneCoeff.at(i)];
        [distArray addObject:numberincols];
    }
  
    for (int i = 0; i < K.rows;i++){
        
        vector<double> row = K.row(i);
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

    fundamentalMatrix(img_1_pts, img_2_pts, K, F, E, P, P1);
}

- (IBAction)trinagulatePoints:(id)sender
{
    JMPRtriangulateTwo(img_1_pts, img_2_pts, P, P1, K, Kinv, pointCloud);
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
                
                hybridFeatureFinder(img_1, img_2, K,distCoeff ,img_1_pts, img_2_pts,matchimg);
                 
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

- (IBAction)writeKtodisk:(id)sender
{
    string Kfilename = "/Users/johndoe/Develop/statue_picture/K.xml";
    FileStorage fs(Kfilename, FileStorage::WRITE);
    fs << "K" << K;
    fs << "distCoeff" << distCoeff;
}

- (IBAction)readKtoapp:(id)sender
{
    string Kfilename = "/Users/johndoe/Develop/statue_picture/K.xml";
    FileStorage fs(Kfilename, FileStorage::READ);
    fs["K"] >> K;
    fs["distCoeff"] >> distCoeff;
    
}


@end
