//
//  CountriesInfo.h
//  CurrencyConverter_RuiCanas
//
//  Created by itsector on 06/04/2021.
//

#import <UIKit/UIKit.h>
#import "Rate.h"

@protocol CountriesRatesDelegate;

@interface CountryRateModel : NSObject
//Properties
@property NSString *baseCurrency;
@property NSMutableArray <Rate *> *rates;
@property NSString *timestamp;
@property (weak, nonatomic) id<CountriesRatesDelegate> delegate;

//Methods
- (void) requestRatesWithBase: (NSString*)currencyCode;
@end

@protocol CountriesRatesDelegate <NSObject>
- (void) updateTableView;
@end
