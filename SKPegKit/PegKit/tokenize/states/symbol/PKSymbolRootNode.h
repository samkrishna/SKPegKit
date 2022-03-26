//
//  PKSymbolRootNode.h
//  SKPegKit
//
//  Created by Sam Krishna on 3/26/22.
//

#import <SKPegKit/PKSymbolNode.h>
#import <SKPegKit/PKTypes.h>

@class PKReader;

@interface PKSymbolRootNode : PKSymbolNode

- (void)add:(NSString *)s;
- (void)remove:(NSString *)s;
- (NSString *)nextSymbol:(PKReader *)r startingWith:(PKUniChar)cin;

@end
