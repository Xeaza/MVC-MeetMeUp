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
    cell.tag = event.photoURL.hash;

//    [event requestEventImageForUrl:event.photoURL completionBlock:^(UIImage *eventImage) {
//        [cell.imageView setImage:eventImage];
//        [cell layoutSubviews];
//    }];

    if (event.photoURL)
    {
        NSURLRequest *request = [NSURLRequest requestWithURL:event.photoURL];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

            // fixing flicker issue
            // check if the cell the image is going in is still the cell that represents that event.
            // We do that by setting the cell's tag to the photoURL's tag
            // Should have a custom cell with a property that is set to the event.
            // This code should go in the custom cell. Check "Is the event the same event"
            if (cell.tag == response.URL.hash) {
                UIImage *image = [UIImage imageWithData:data];
                cell.imageView.image = image;
            }
            else
            {
                NSLog(@"Loaded wrong image!");
            }

        }];
    }
    else
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
