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
        std::vector<std::vector<cv::Point2f>> imagePoints(1);
        Mat tempimage = imread(filepaths[i],CV_LOAD_IMAGE_GRAYSCALE);
        if(tempimage.rows)
        {
        
        if (findChessboardCorners(tempimage, cvSize(12,13), imagePoints[0]))        {
            goodimages.push_back(filepaths[i]);
            cout<<"Found chesspatern in :"<<filepaths[i]<<"\n";
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
    
    unsigned int board_w = 12;
    unsigned int board_h = 13;
    
    unsigned int n_boards = int(goodimages.size());
    
    
    unsigned int board_n = board_h * board_w;
    
    cv::Size board_sz = cv::Size(board_w,board_h);
    
    Mat image_points = Mat(n_boards,board_n,2,CV_32FC1);
    
    Mat object_points = Mat(n_boards,board_n,3,CV_32FC1);
    
    
    
    
    
    
    
    
    CameraStruct camera;
    
    return camera;
}

@end
