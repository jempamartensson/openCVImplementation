//
//  JMPRtriangulate.m
//  openCVImplementation
//
//  Created by johndoe on 03/08/2014.
//  Copyright (c) 2014 Jens Martensson. All rights reserved.
//

#import "JMPRtriangulate.h"
#import <fstream>



using namespace cv;
using namespace std;

@implementation JMPRtriangulate

void JMPRtriangulatePoints(Matx34d camera1,Matx34d camera2, vector<Point2f> &img_1_pts,vector<Point2f> &img_2_pts,Mat pts_3d)
{
    unsigned int pts_size = int(img_1_pts.size());
    Mat pt_3d_h(1,pts_size,CV_32FC4);
    triangulatePoints(camera1, camera2, img_1_pts, img_2_pts, pt_3d_h);
    pts_3d = pt_3d_h;
    vector<Point3f> pt_3d_vector;
    convertPointsFromHomogeneous(pt_3d_h.reshape(4, 1), pt_3d_vector);
    unsigned int pts_3d_size = int(pt_3d_vector.size());
    
    ofstream myfile;
    myfile.open("/Users/johndoe/Develop/statue_picture/example.txt");
    
    
    
    
    cout<<"Triangulation done \n";
    for (int i = 0; i < pts_3d_size;i++)
    {
//        cout<<pt_3d_h.col(i)<<"\n";
        Point3f _col = pt_3d_vector[i];
        cout<<"x is :"<<_col.x<<"\n";
        cout<<"y is :"<<_col.y<<"\n";
        cout<<"z is :"<<_col.z<<"\n";
        myfile <<_col.x<<" "<<_col.y<<" "<<_col.z<<"\n";
    }
    myfile.close();
    
}

@end
