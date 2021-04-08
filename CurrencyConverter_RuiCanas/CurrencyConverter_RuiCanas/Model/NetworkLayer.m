//
//  CountriesInfo.m
//  CurrencyConverter_RuiCanas
//
//  Created by itsector on 06/04/2021.
//

#import "NetworkLayer.h"
#import "AFNetworking.h"

@implementation NetworkLayer

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}


- (void) requestRatesWithBase: (NSString*)currencyCode withBlock:(void (^)(NSArray<Rate*>*))Block{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];

    NSString* strUrl = [NSString stringWithFormat:@"https://api.exchangerate.host/latest?base=%@", currencyCode];
    NSURL *URL = [NSURL URLWithString:strUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSDictionary* jsonResponse = [responseObject valueForKey:@"rates"];
            NSArray* allArrays = [self readRatesFromDictionary:jsonResponse andBase:currencyCode withTime:[responseObject valueForKey:@"date"]];
            Block(allArrays);
        }
    }];
    [dataTask resume];
}

- (NSArray*) readRatesFromDictionary: (NSDictionary*) dict andBase: (NSString*)baseCurrency withTime: (NSString*)time{
    NSMutableArray <Rate*> *allRates = [[NSMutableArray alloc] init];
    Rate *baseRate;
    for(id key in dict){
        Rate *rate = [[Rate alloc] initWithCode:key andValue:[dict objectForKey:key] andTime:time];
        if(rate.currencyCode == baseCurrency){
            baseRate = rate;
        }
        [allRates addObject:rate];
    }
    [allRates sortUsingSelector:@selector(compare:)];
    //The base rate will be added at the top of the array in order to avoid any issues with indexPath in UITableView
    [allRates insertObject:baseRate atIndex:0];
    return allRates;
}

//Useful method to fill the remaining info - Currency name and the flag photo.
- (void) requestInfoWithCurrency: (NSString*) currency andBlock:(void (^)(NSString*, NSString*))Block{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSString* strUrl = [NSString stringWithFormat:@"http://countryapi.gear.host/v1/Country/getCountries?pCurrencyCode=%@", currency];
    NSURL *URL = [NSURL URLWithString:strUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];

    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSArray <NSDictionary *> *countries = [responseObject valueForKey:@"Response"];
            __block NSString* currencyName;
            __block NSString* flagUrl;
            if(countries.count != 0){
                [self array:countries toFillCurrency:currencyName andPhoto:flagUrl withBase:currency andBlock:^(NSString * currency, NSString *url) {
                    currencyName = currency;
                    flagUrl = url;
                }];
            }
            else{
                NSString *const DEFAULT_IMG = @"https://cdn1.iconfinder.com/data/icons/rounded-flat-country-flag-collection-1/2000/_Unknown.png";
                NSString *const DEFAULT_NAME = @"Unavailable Name";
            
                currencyName = DEFAULT_NAME;
                flagUrl = DEFAULT_IMG;
            }
            Block(currencyName, flagUrl);
        }
    }];
    [dataTask resume];
}

- (void) array: (NSArray*) countries toFillCurrency: (NSString*)currencyName andPhoto: (NSString*)png withBase: (NSString*)baseCurrency andBlock:(void (^)(NSString*, NSString*))Block{
    NSString *const USA = @"United States of America";
    NSString *const POR = @"Portugal";
    

    if([baseCurrency isEqualToString:@"USD"] || [baseCurrency isEqualToString:@"EUR"]){
        for(NSDictionary* dict in countries){
            if([dict[@"Name"] isEqualToString:USA]){
                currencyName = dict[@"CurrencyName"];
                png = dict[@"FlagPng"];
            }
            else if([dict[@"Name"] isEqualToString:POR]){
                currencyName = dict[@"CurrencyName"];
                png = dict[@"FlagPng"];
            }
        }
    }else{
        currencyName = countries[0][@"CurrencyName"];
        png = countries[0][@"FlagPng"];
    }
    Block(currencyName, png);
}
@end
