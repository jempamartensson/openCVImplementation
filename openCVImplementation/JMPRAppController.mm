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
//    NSString *stringfilepath = [[NSString alloc] initWithFormat:@"%@",[pathLabelOne stringValue]];
//    int rows = [rowslabel integerValue];
//    int cols = [collabel integerValue];
//    
//    cv::Size size = cv::Size(cols,rows);
//    
//    std::cout<<"This is the size: "<<size<<" \n";
//    
//    std::string cFilepath([stringfilepath UTF8String]);
//    std::cout<<cFilepath;
//    cv::Mat processIMage = cv::imread(cFilepath);
//    if(processIMage.empty())
//    {
//        std::cerr << "Could not read image!" << std::endl;
//    }
//    cv::Mat drawimage;
//    cv::cvtColor(processIMage, processIMage, CV_BGR2GRAY);
//    
//    
//    std::vector<std::vector<cv::Point2f>> imagePoints(1);
//    
//    
//    CameraStruct camera = CalibrateCamera(processIMage, cv::Size(cols,rows),1,TRUE,TRUE);
//    cv::Mat outImage;
//    
//    cv::undistort(camera.Image, outImage, camera.CameraMatrix, camera.DistortionCoefficients);
//    cv:cvtColor(outImage, drawimage, CV_GRAY2BGR);
//    
//    Calc3d calc;
//    
//    Mat cam_matrix = (Mat_<double>(3, 3) <<
//                      6624.070862,           0, 1008.853968,
//                      0, 6624.995786, 1132.158299,
//                      0,           0, 1);
//    
//    Mat dist_coeff = (Mat_<double>(1, 5) << -0.159685, 0.037437, -0.000708, -0.000551, 0.000000);
//    
//    
//    cv::Mat img1;
//    cv::Mat img2;
//    
//    Mat img1distorted = imread( "/Users/johndoe/Develop/statue_picture/hou_img1.jpg" );
//    Mat img2distorted = imread( "/Users/johndoe/Develop/statue_picture/hou_img2.jpg" );
    
//    cv::Mat img1distorted = cv::imread("/Users/johndoe/Develop/statue_picture/img1.jpg");
//    cv::Mat img2distorted = cv::imread("/Users/johndoe/Develop/statue_picture/img2.jpg");
    
//    Mat imgdrawkey;
    
//    Mat flannImg = testFlann(camera.CameraMatrix,camera.DistortionCoefficients,imgdrawkey);
    
//    cv::Mat img1distorted = cv::imread("/Users/johndoe/Develop/develop_picture/nelly_1.jpg");
//    cv::Mat img2distorted = cv::imread("/Users/johndoe/Develop/develop_picture/nelly_2.jpg");
    
//    cv::undistort(img1distorted, img1, camera.CameraMatrix, camera.DistortionCoefficients);
//    cv::undistort(img2distorted, img2, camera.CameraMatrix, camera.DistortionCoefficients);
    
    
//    calc = getP1(img1distorted, img2distorted,camera.CameraMatrix,camera.DistortionCoefficients);
    
    //std::cout<<calc.pointCloud.size()<<std::endl;
    //std::cout<<calc.pointCloud.rows<<std::endl;
    
    //Mat ofpc;
    
    //ofpc = sfm(img1distorted, img2distorted, cam_matrix, dist_coeff);
    
    //cout<<ofpc.cols<<std::endl;
    
//    vector<Point3f> points;
//    for ( int i = 0; i < ofpc.cols; i++ ) {
//        Mat m = ofpc.col( i );
//        float x = m.at<float>(0);
//        float y = m.at<float>(1);
//        float z = m.at<float>(2);
//        
//        points.push_back( Point3f(x, y, z) );
//    }
//    cout<<points.size()<<std::endl;
//    
//    Mat labels, center;
//    kmeans( ofpc.t(), 1, labels, TermCriteria( CV_TERMCRIT_ITER, 1000, 1e-5), 1, KMEANS_RANDOM_CENTERS, center );
//    
//    for(Point3f point: points){
//        point.x -= center.at<float>(0, 0);
//        point.y -= center.at<float>(0, 1);
//        point.z -= center.at<float>(0, 2);
//    }
//    
//    CameraStruct othercam;
    NSString *folderpath = @"/Users/johndoe/Develop/calib_chessboards";

    calibrateCamera(folderpath,1.35);
    
    
    //NSImage *dimage = [NSImage imageWithCVMat:calc.Image];
    
    //NSImage *image = [NSImage imageWithCVMat:imgdrawkey];
    
    //[imageViewOne setImage:dimage];
    
    //[imageViewTwo setImage:dimage];
    
//    std::ofstream myfile;
//    myfile.open ("/Users/johndoe/Develop/statue_picture/example.txt");
//    
//    for(unsigned int i = 0;i < calc.pointCloud.size(); i++){
//        
//        cv::Point3f pt;
//        //std::cout<<calc.points.at(i)<<std::endl;
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
