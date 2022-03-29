//
//  PKSymbolNode.h
//  SKPegKit
//
//  Created by Sam Krishna on 3/26/22.
//

@import Foundation;
#import <SKPegKit/PKTypes.h>

@interface PKSymbolNode : NSObject

- (instancetype)initWithParent:(PKSymbolNode *)p character:(PKUniChar)c;

@property (nonatomic, readonly, strong) NSString *ancestor;

@property (nonatomic, readwrite, assign) BOOL reportsAddedSymbolsOnly;

@end
