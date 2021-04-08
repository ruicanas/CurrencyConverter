//
//  CountriesInfo.h
//  CurrencyConverter_RuiCanas
//
//  Created by itsector on 06/04/2021.
//

#import <UIKit/UIKit.h>
#import "Rate.h"

@interface NetworkLayer : NSObject
- (void) requestRatesWithBase: (NSString*)currencyCode withBlock:(void (^)(NSArray<Rate*>*))Block;
- (void) requestInfoWithCurrency: (NSString*) currency andBlock:(void (^)(NSString*, NSString*))Block;
@end
