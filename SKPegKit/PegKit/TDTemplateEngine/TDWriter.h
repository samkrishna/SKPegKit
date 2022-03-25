//
//  TDWriter.h
//  SKPegKit
//
//  Created by Sam Krishna on 3/24/22.
//

@import Foundation;

@interface TDWriter : NSObject

@property (nonatomic, readwrite, strong) NSOutputStream *output;

+ (instancetype)writerWithOutputStream:(NSOutputStream *)output;
- (instancetype)initWithOutputStream:(NSOutputStream *)output;

- (void)appendObject:(id)obj;
- (void)appendString:(NSString *)str;
- (void)appendFormat:(NSString *)fmt, ... NS_FORMAT_FUNCTION(1, 2);

@end

