//
//  EventDetailViewController.m
//  MeetMeUp
//
//  Created by Dave Krawczyk on 9/8/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "Event.h"
#import "WebViewController.h"
#import "CommentsTableViewController.h"
#import "EventDetailViewController.h"

@interface EventDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *hostedByLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextview;

@end

@implementation EventDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.nameLabel.text = self.event.name;
    self.addressLabel.text = self.event.address;
    self.countLabel.text = self.event.RSVPCount;
    self.hostedByLabel.text = self.event.hostedBy;
    self.descriptionTextview.text = self.event.eventDescription;

    self.navigationItem.rightBarButtonItem.title = @"MEHH";
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier]isEqualToString:@"webSegue"]) {
        WebViewController *webVC = [segue destinationViewController];
        webVC.eventURL = self.event.eventURL;
        
    }
    if ([[segue identifier]isEqualToString:@"commentSegue"]) {
        CommentsTableViewController *commentTable = [segue destinationViewController];
        commentTable.event = self.event;
        
    }
}

@end
