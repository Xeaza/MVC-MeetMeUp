//
//  Event.m
//  MeetMeUp
//
//  Created by Dave Krawczyk on 9/8/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "Event.h"

@implementation Event


- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        self.name = dictionary[@"name"];
        

        self.eventID = dictionary[@"id"];
        self.RSVPCount = [NSString stringWithFormat:@"%@",dictionary[@"yes_rsvp_count"]];
        self.hostedBy = dictionary[@"group"][@"name"];
        self.eventDescription = dictionary[@"description"];
        self.address = dictionary[@"venue"][@"address"];
        self.eventURL = [NSURL URLWithString:dictionary[@"event_url"]];
        self.photoURL = [NSURL URLWithString:dictionary[@"photo_url"]];
    }
    return self;
}

+ (void)performSearchWithKeyword: (NSString *)keyword completionBlock:(void (^)(NSArray *))complete
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.meetup.com/2/open_events.json?zip=60604&text=%@&time=,1w&key=11744725b2c306e2d9711156454a12",keyword]];

    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        NSArray *jsonArray = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil] objectForKey:@"results"];
        NSMutableArray *meetUps = [[NSMutableArray alloc] initWithCapacity:jsonArray.count];

        for (NSDictionary *dict in jsonArray) {
            Event *event = [[Event alloc] initWithDictionary:dict];
            [meetUps addObject:event];
        }
        complete(meetUps);
    }];
}


@end
