//
//  JMPRcalibrateCamera.m
//  openCVImplementation
//
//  Created by johndoe on 25/07/2014.
//  Copyright (c) 2014 Jens Martensson. All rights reserved.
//

#import "JMPRcalibrateCamera.h"

using namespace cv;
using namespace std;


@implementation JMPRcalibrateCamera

typedef struct CameraStruct
{
    cv::Mat CameraMatrix;
    cv::Mat ImagePoints;
    cv::Mat DistortionCoefficients;
    cv::Mat Image;
}CameraStruct;

CameraStruct calibrateCamera(NSString *folderpath){
    
    NSError *error = nil;
    NSArray *desktopFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderpath error:&error];
    
   
    vector<string> filepaths;
    for (int i = 0; i < [desktopFiles count];i++)
    {
        //NSLog(@"%@/%@",folderpath,[desktopFiles objectAtIndex:i]);
        NSString *filepath = [NSString stringWithFormat:@"%@/%@",folderpath,[desktopFiles objectAtIndex:i]];
        string path = [filepath UTF8String];
        //cout<<"The file path is : "<<path<<endl;
        filepaths.push_back(path);
    }
    
    vector<string> goodimages;
    vector<string> nonimages;
    
    for (int i = 0; i < filepaths.size();i++){
        std::vector<cv::Point2f> imagePoints;
        Mat tempimage = imread(filepaths[i],CV_LOAD_IMAGE_GRAYSCALE);
        if(tempimage.rows)
        {
        
        if (findChessboardCorners(tempimage, cvSize(12,13), imagePoints))        {
            goodimages.push_back(filepaths[i]);
            cout<<"Found chesspatern in :"<<filepaths[i]<<"\n";
            cout<<"This is the number of imagepoints :"<<imagePoints.size()<<"\n";
        }else{
            cout<<"Bad image :"<<filepaths[i]<<"\n";
            
        }
        
            
        }else{
            cout<<"Non image :"<<filepaths[i]<<"\n";
            nonimages.push_back(filepaths[i]);
        }
        
    }
    cout<<"Total number of images is :"<<filepaths.size() - nonimages.size()<<"\n";
    cout<<"Number of good images is :"<<goodimages.size()<<"\n";
    cout<<"Number of non images is :"<<nonimages.size()<<"\n";
    
    
    //Set all values before loop
    
    unsigned int board_w = 12;
    unsigned int board_h = 13;
    unsigned int n_boards = int(goodimages.size());
    unsigned int board_n = board_h * board_w;
    cv::Size board_sz(board_w,board_h);
    
    std::vector<std::vector<cv::Point2f>> image_points(n_boards);
    std::vector<std::vector<cv::Point3f>> object_points(n_boards);
    Mat intrinsic_matrix(3,3,CV_32FC1);
    Mat distortion_coeffs(5,1,CV_32FC1);
    
    for( unsigned int i = 0; i< goodimages.size();i++)
    {
        vector<Point2f> corners;
        Mat tempimage =imread(goodimages[i],CV_LOAD_IMAGE_GRAYSCALE);
        bool found = findChessboardCorners(tempimage, board_sz, corners);
        if(found){
            cornerSubPix(tempimage, corners, board_sz, cv::Size(-1, -1), cv::TermCriteria(CV_TERMCRIT_EPS + CV_TERMCRIT_ITER, 30, 0.1));
            cout<<"CornerSubPix is working \n";
        }
        
    }
    
    
    
    
    


    
    
    
    
    
    
    
    
    
    
    
    CameraStruct camera;
    
    return camera;
}

@end
