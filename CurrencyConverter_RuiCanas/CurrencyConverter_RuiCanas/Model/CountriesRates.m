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

- (void) requestRatesWithBase: (NSString*)currencyCode{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

    NSString* strUrl = [NSString stringWithFormat:@"https://api.exchangerate.host/latest?base=%@", currencyCode];
    NSURL *URL = [NSURL URLWithString:strUrl];
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
                [self requestRemainingInfo];
            });
        }
    }];
    [dataTask resume];
}

- (void) readRatesFromDictionary: (NSDictionary*) dict{
    [self.rates removeAllObjects];
    Rate *baseRate;
    for(id key in dict){
        Rate *rate = [[Rate alloc] initWithCode:key andValue:[dict objectForKey:key]];
        if(rate.currencyCode == self.source){
            baseRate = rate;
        }
        [self.rates addObject:rate];
    }
    [self.rates sortUsingSelector:@selector(compare:)];
    //The base rate will be added at the top of the array in order to avoid any issues with indexPath in UITableView
    [self.rates insertObject:baseRate atIndex:0];
}

- (void) requestRemainingInfo{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    for(Rate* r in self.rates){
        NSString* strUrl = [NSString stringWithFormat:@"http://countryapi.gear.host/v1/Country/getCountries?pCurrencyCode=%@", r.currencyCode];
        NSURL *URL = [NSURL URLWithString:strUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        
        NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if (error) {
                NSLog(@"Error: %@", error);
            } else {
                NSArray <NSDictionary *> *countries = [responseObject valueForKey:@"Response"];
                if(countries.count != 0){
                    [self infoFromArray:countries toCountry:r];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([self.delegate respondsToSelector:@selector(updateTableView)]) {
                        [self.delegate updateTableView];
                    }
                });
            }
        }];
        [dataTask resume];
    }
}

- (void) infoFromArray: (NSArray*) countries toCountry: (Rate*)country{
    NSString *const USA = @"United States of America";
    NSString *const POR = @"Portugal";
    
    if([country.currencyCode isEqualToString:@"USD"] || [country.currencyCode isEqualToString:@"EUR"]){
        for(NSDictionary* dict in countries){
            if([dict[@"Name"] isEqualToString:USA]){
                country.currencyName = dict[@"CurrencyName"];
                country.flagUrl = dict[@"FlagPng"];
            }
            else if([dict[@"Name"] isEqualToString:POR]){
                country.currencyName = dict[@"CurrencyName"];
                country.flagUrl = dict[@"FlagPng"];
            }
        }
    }else{
        country.currencyName = countries[0][@"CurrencyName"];
        country.flagUrl = countries[0][@"FlagPng"];
    }
}
@end
