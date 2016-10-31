//
//  ShowSearchVC.h
//  DXMCLLocation
//
//  Created by YANGJINMING on 16/4/18.
//  Copyright © 2016年 YANGJINMING. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol ShowSearchVCDelegate <NSObject>

- (void)getSelectLocation:(MKMapItem *)mapItem;

@end

@interface ShowSearchVC : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *showTableView;
@property (strong, nonatomic) NSArray *showArray;
@property (weak, nonatomic) IBOutlet UITextField *currentTF;
@property (copy,nonatomic) NSString *currentName;
@property (nonatomic) MKCoordinateRegion currentRegion;
@property (weak,nonatomic) id <ShowSearchVCDelegate>delegate;

@end
