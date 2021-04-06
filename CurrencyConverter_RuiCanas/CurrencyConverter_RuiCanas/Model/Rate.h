//
//  Rate.h
//  CurrencyConverter_RuiCanas
//
//  Created by itsector on 06/04/2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Rate : NSObject
@property NSString* code;
@property NSString* value;

- (instancetype)initWithCode: (NSString*)code andValue: (NSNumber*)value;
@end

NS_ASSUME_NONNULL_END
