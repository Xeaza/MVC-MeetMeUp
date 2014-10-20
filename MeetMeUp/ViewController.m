//
//  ViewController.m
//  MeetMeUp
//
//  Created by Dave Krawczyk on 9/8/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "Event.h"
#import "EventDetailViewController.h"
#import "ViewController.h"

@interface ViewController () <UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *searchBar;
@property (nonatomic, strong) NSArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];

    [Event performSearchWithKeyword:@"mobile" completionBlock:^(NSArray *meetUps) {
        self.dataArray = meetUps;
    }];
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    [self.tableView reloadData];
}

#pragma mark - Tableview Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eventCell"];
    
    Event *event = self.dataArray[indexPath.row];

    cell.textLabel.text = event.name;
    cell.detailTextLabel.text = event.address;
    if (event.photoURL)
    {
        NSURLRequest *imageReq = [NSURLRequest requestWithURL:event.photoURL];
        
        [NSURLConnection sendAsynchronousRequest:imageReq queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
           dispatch_async(dispatch_get_main_queue(), ^{
               if (!connectionError) {
                   [cell.imageView setImage:[UIImage imageWithData:data]];
                   [cell layoutSubviews];
               }
           });


        }];
        
        
    }else
    {
       [cell.imageView setImage:[UIImage imageNamed:@"logo"]];
    }
    
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    EventDetailViewController *detailVC = [segue destinationViewController];

    Event *e = self.dataArray[self.tableView.indexPathForSelectedRow.row];
    detailVC.event = e;
}

#pragma searchbar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [Event performSearchWithKeyword:searchBar.text completionBlock:^(NSArray *searchResponseArray) {
        self.dataArray = searchResponseArray;
    }];

    [searchBar resignFirstResponder];
}

@end
