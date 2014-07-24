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


using namespace cv;

@implementation JMPRAppController



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
    NSString *stringfilepath = [[NSString alloc] initWithFormat:@"%@",[pathLabelOne stringValue]];
    int rows = [rowslabel integerValue];
    int cols = [collabel integerValue];
    
    //cv::Size size = cv::Size(cols,rows);
    
    //std::cout<<"This is the size: "<<size<<" \n";
    
    std::string cFilepath([stringfilepath UTF8String]);
    std::cout<<cFilepath;
    cv::Mat processIMage = cv::imread(cFilepath);
    if(processIMage.empty())
    {
        std::cerr << "Could not read image!" << std::endl;
    }
    cv::Mat drawimage;
    cv::cvtColor(processIMage, processIMage, CV_BGR2GRAY);
    
    
    std::vector<std::vector<cv::Point2f>> imagePoints(1);
    
    
    CameraStruct camera = CalibrateCamera(processIMage, cv::Size(cols,rows),1,TRUE,TRUE);
    cv::Mat outImage;
    
    cv::undistort(camera.Image, outImage, camera.CameraMatrix, camera.DistortionCoefficients);
    cv:cvtColor(outImage, drawimage, CV_GRAY2BGR);
    
    Calc3d calc;
    
    cv::Mat img1;
    cv::Mat img2;
    
    cv::Mat img1distorted = cv::imread("/Users/johndoe/Develop/statue_picture/img1.jpg");
    cv::Mat img2distorted = cv::imread("/Users/johndoe/Develop/statue_picture/img2.jpg");
    
    Mat imgdrawkey;
    
    Mat flannImg = testFlann(camera.CameraMatrix,camera.DistortionCoefficients,imgdrawkey);
    
//    cv::Mat img1distorted = cv::imread("/Users/johndoe/Develop/develop_picture/nelly_1.jpg");
//    cv::Mat img2distorted = cv::imread("/Users/johndoe/Develop/develop_picture/nelly_2.jpg");
    
    //cv::undistort(img1distorted, img1, camera.CameraMatrix, camera.DistortionCoefficients);
    //cv::undistort(img2distorted, img2, camera.CameraMatrix, camera.DistortionCoefficients);
    
    
    //calc = getP1(img1distorted, img2distorted,camera.CameraMatrix,camera.DistortionCoefficients);
    
    //std::cout<<calc.pointCloud.size()<<std::endl;
    //std::cout<<calc.pointCloud.rows<<std::endl;
    
    
    //NSImage *dimage = [NSImage imageWithCVMat:calc.Image];
    
    NSImage *image = [NSImage imageWithCVMat:imgdrawkey];
    
    [imageViewOne setImage:image];
    
    //[imageViewTwo setImage:dimage];
    
//    std::ofstream myfile;
//    myfile.open ("/Users/johndoe/Develop/statue_picture/example.txt");
//    
//    for(unsigned int i = 0;i < calc.pointCloud.size(); i++){
//        
//        cv::Point3f pt;
//        //std::cout<<calc.pointCloud.at(i)<<std::endl;
//        pt = calc.pointCloud.at(i);
//        
//        myfile<<pt.x<<" "<<pt.y<<" "<<pt.z<<" "<<std::endl;
//    }
//    myfile.close();
    
 

    
    
    
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
