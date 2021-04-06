//
//  CountriesInfo.m
//  CurrencyConverter_RuiCanas
//
//  Created by itsector on 06/04/2021.
//

#import "CountriesRates.h"
#import "AFNetworking.h"

@implementation CountriesRates

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.rates = [[NSMutableArray alloc] init];
        self.source = [[NSString alloc] init];
        self.timestamp = [[NSString alloc] init];
    }
    return self;
}

- (void) requestQuotes{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

    NSURL *URL = [NSURL URLWithString:@"https://api.exchangerate.host/latest?base=EUR"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSDictionary* helpDict = [[NSDictionary alloc] initWithDictionary:[responseObject valueForKey:@"rates"]];
            self.source = [responseObject valueForKey:@"base"];
            self.timestamp = [responseObject valueForKey:@"date"];
            [self readRatesFromDictionary:helpDict];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(updateTableView)]) {
                    [self.delegate updateTableView];
                }
            });
        }
    }];
    [dataTask resume];
}

- (void) readRatesFromDictionary: (NSDictionary*) dict{
    for(id key in dict){
        Rate *rate = [[Rate alloc] initWithCode:key andValue:[dict objectForKey:key]];
        [self.rates addObject:rate];
    }
    [self.rates sortUsingSelector:@selector(compare:)];
}
@end
