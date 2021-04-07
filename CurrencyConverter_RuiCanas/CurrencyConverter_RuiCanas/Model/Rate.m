//
//  Rate.m
//  CurrencyConverter_RuiCanas
//
//  Created by itsector on 06/04/2021.
//

#import "Rate.h"
#import "AFNetworking.h"

@implementation Rate
- (instancetype)initWithCode: (NSString*)code andValue: (NSNumber*)value
{
    self = [super init];
    if (self) {
        self.currencyCode = code;
        self.value = [self giveDecimalPlaces:value];
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
