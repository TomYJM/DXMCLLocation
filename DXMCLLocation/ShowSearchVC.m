//
//  ShowSearchVC.m
//  DXMCLLocation
//
//  Created by YANGJINMING on 16/4/18.
//  Copyright © 2016年 YANGJINMING. All rights reserved.
//

#import "ShowSearchVC.h"
#import <MapKit/MapKit.h>

@interface ShowSearchVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@end

@implementation ShowSearchVC
- (void)loadView {
    [super loadView];
    self.showTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.showTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.currentTF.text = self.currentName;
    self.currentTF.delegate = self;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)updateViewArray:(NSArray *)arr
{
    self.showArray = arr;
    [self.showTableView reloadData];
}
#pragma mark - clickButton
- (IBAction)clickSure:(id)sender
{
    if (self.currentTF.text.length > 0) {
        MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
        request.naturalLanguageQuery = self.currentTF.text;
        request.region = self.currentRegion;
        
        //请求LocalSearch搜索附近结果
        MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
        __weak typeof(self) weakSelf = self;
        [search startWithCompletionHandler:^(MKLocalSearchResponse *r, NSError *e) {
            [weakSelf updateViewArray:r.mapItems];
        }];
    }
    [self.currentTF resignFirstResponder];
}
- (IBAction)textEditChanged:(id)sender
{
    if (self.currentTF.text.length > 0) {
        MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
        request.naturalLanguageQuery = self.currentTF.text;
        request.region = self.currentRegion;
        
        //请求LocalSearch搜索附近结果
        MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
        __weak typeof(self) weakSelf = self;
        [search startWithCompletionHandler:^(MKLocalSearchResponse *r, NSError *e) {
            [weakSelf updateViewArray:r.mapItems];
        }];
    }
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"ShowCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    MKMapItem *item = [self.showArray objectAtIndex:indexPath.row];
    cell.textLabel.text = item.name;
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MKMapItem *item = [self.showArray objectAtIndex:indexPath.row];
    self.currentTF.text = item.name;
    if ([self.delegate respondsToSelector:@selector(getSelectLocation:)]) {
        [self.delegate getSelectLocation:item];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length > 0) {
        return YES;
    }
    return NO;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}
@end
