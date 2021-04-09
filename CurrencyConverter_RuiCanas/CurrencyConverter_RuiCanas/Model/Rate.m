//
//  Rate.m
//  CurrencyConverter_RuiCanas
//
//  Created by itsector on 06/04/2021.
//

#import "Rate.h"
#import "AFNetworking.h"

@implementation Rate
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (instancetype)initWithCode: (NSString*)code andValue: (NSNumber*)value andTime: (NSString*) time
{
    self = [super init];
    if (self) {
        self.currencyCode = code;
        self.value = [self giveDecimalPlaces:value];
        self.time = time;
        self.currencyName = @"Unavailable Name";
        self.flagUrl = @"";
    }
    return self;
}

- (NSComparisonResult)compare:(Rate *)otherObject {
    return [self.currencyCode compare:otherObject.currencyCode];
}

- (NSString*) giveDecimalPlaces: (NSNumber*)value{
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setPositiveFormat:@"0.####"];
    return [fmt stringFromNumber:value];
}
@end
