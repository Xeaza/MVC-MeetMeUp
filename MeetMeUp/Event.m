//
//  Event.m
//  MeetMeUp
//
//  Created by Dave Krawczyk on 9/8/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "Event.h"
#import "Comment.h"


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
        //self.photoURL = [NSURL URLWithString:dictionary[@"photo_url"]];
        int width = arc4random_uniform(100) + 100;
        int height = arc4random_uniform(100) + 100;
        self.photoURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://placekitten.com/%d/%d", width, height]];

    }
    return self;
}

+ (void)performSearchWithKeyword: (NSString *)keyword completionBlock:(void (^)(NSArray *meetUps))complete
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

- (void)requestEventCommentsForId:(NSString *)eventID completionBlock:(void (^)(NSArray *eventComments))complete
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.meetup.com/2/event_comments?&sign=true&photo-host=public&event_id=%@&page=20&key=11744725b2c306e2d9711156454a12",eventID]];

    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];

        NSArray *jsonArray = [dict objectForKey:@"results"];

        self.commentsArray = [Comment objectsFromArray:jsonArray];
        complete(self.commentsArray);
    }];
}

- (void)requestEventImageForUrl:(NSURL *)imageURL completionBlock:(void (^)(UIImage *eventImage))complete {
    if (imageURL)
    {
        NSURLRequest *imageReq = [NSURLRequest requestWithURL:imageURL];

        [NSURLConnection sendAsynchronousRequest:imageReq queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!connectionError) {
                    complete([UIImage imageWithData:data]);
                }
            });
        }];
    }
    else
    {
        complete([UIImage imageNamed:@"logo"]);
    }
}

@end
