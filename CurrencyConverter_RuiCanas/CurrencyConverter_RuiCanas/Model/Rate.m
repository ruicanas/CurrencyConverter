//
//  Rate.m
//  CurrencyConverter_RuiCanas
//
//  Created by itsector on 06/04/2021.
//

#import "Rate.h"

@implementation Rate
- (instancetype)initWithCode: (NSString*)code andValue: (NSNumber*)value
{
    self = [super init];
    if (self) {
        self.code = code;
        self.value = [self giveDecimalPlaces:value];
    }
    return self;
}

- (NSComparisonResult)compare:(Rate *)otherObject {
    return [self.code compare:otherObject.code];
}

- (NSString*) giveDecimalPlaces: (NSNumber*)value{
    NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
    [fmt setPositiveFormat:@"0.####"];
    return [fmt stringFromNumber:value];
}
@end
