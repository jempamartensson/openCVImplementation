//
//  JMPRhybridFeatureFinder.m
//  openCVImplementation
//
//  Created by johndoe on 29/07/2014.
//  Copyright (c) 2014 Jens Martensson. All rights reserved.
//

#import "JMPRhybridFeatureFinder.h"

@implementation JMPRhybridFeatureFinder


void hybridFeatureFinder(Mat img_1,Mat img_2,Mat cameraMatrix, Mat distCoeffs,vector<Point2f> &img_1_pts,vector<Point2f> &img_2_pts){
    
    
    
    //create the keypoints
    vector<KeyPoint> KeyPoints1, KeyPoints2;
    
    FAST(img_1, KeyPoints1, 1);
    FAST(img_2, KeyPoints2, 1);
    
    cout<<"FAST is done \n";
    
    vector<Point2f> img_1_points;
    KeyPoint::convert(KeyPoints1, img_1_points);
    
    vector<Point2f> img_2_points(img_1_points.size());
    
    Mat prevgray, gray;
    if(img_1.channels() == 3){
        cvtColor(img_1, prevgray, CV_RGB2GRAY);
        cvtColor(img_2, gray, CV_RGB2GRAY);
    } else {
        prevgray = img_1;
        gray = img_2;
    }
    
    //error and stautus for individual points
    vector<uchar> vstatus;
    vector<float> verror;
    
    calcOpticalFlowPyrLK(prevgray, gray, img_1_points, img_2_points, vstatus, verror);
    
    vector<Point2f> img_2_points_tofind;
    vector<int> img_2_points_index;
    
    for (int i = 0; i < vstatus.size(); i++){
        if (vstatus[i]  && verror[i] < 12.0){
            img_2_points_index.push_back(i);
            img_2_points_tofind.push_back(img_2_points[i]);
        } else {
            vstatus[i] = 0;
        }
    }
    
    Mat img_2_points_tofind_flat = Mat(img_2_points_tofind).reshape(1,int(img_2_points_tofind.size()));
    
    vector<Point2f> img_2_features;
    KeyPoint::convert(KeyPoints2, img_2_features);
    
    Mat img_2_features_flat = Mat(img_2_features).reshape(1, int(img_2_features.size()));
    
    BFMatcher matcher(CV_L2);
    vector<vector<DMatch>> nearest_neighbour;
    matcher.radiusMatch(img_2_points_tofind_flat, img_2_features_flat, nearest_neighbour, 2.0f);
    
    vector<DMatch> matches;
    
    set<int> found_in_img2_points;
    for (int i = 0; i < nearest_neighbour.size(); i++){
        DMatch _match;
        if (nearest_neighbour[i].size() ==1){
            _match = nearest_neighbour[i][0];
        } else if(nearest_neighbour[i].size() > 1){
            double ratio = nearest_neighbour[i][0].distance / nearest_neighbour[i][1].distance;
            if (ratio < 0.7) {
                _match = nearest_neighbour[i][0];
            }else{
                continue;
            }
        }else{
            continue;
        }
            
        if (found_in_img2_points.find(_match.trainIdx) == found_in_img2_points.end()){
            _match.queryIdx = img_2_points_index[_match.queryIdx];
            found_in_img2_points.insert(_match.trainIdx);
            matches.push_back(_match);
            
        }
    
    
    }
    
    
    
    vector<Point2f> imagepoints_1, imagepoints_2;
    
    for (unsigned int i = 0; i <matches.size(); i++){
        imagepoints_1.push_back(KeyPoints1[matches[i].queryIdx].pt);
        imagepoints_2.push_back(KeyPoints2[matches[i].trainIdx].pt);
        
    }
    
    undistortPoints(imagepoints_1, imagepoints_1, cameraMatrix, distCoeffs);
    undistortPoints(imagepoints_2, imagepoints_2, cameraMatrix, distCoeffs);
    
    
    img_1_pts = imagepoints_1;
    img_2_pts = imagepoints_2;
    
    
    
}

@end
