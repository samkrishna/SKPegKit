//
//  PKWhitespaceState.h
//  SKPegKit
//
//  Created by Sam Krishna on 3/25/22.
//

#import <SKPegKit/PKTokenizerState.h>

@interface PKWhitespaceState : PKTokenizerState

- (BOOL)isWhitespaceChar:(PKUniChar)c;
- (void)setWhitespaceChars:(BOOL)yn from:(PKUniChar)start to:(PKUniChar)end;

@property (nonatomic, readwrite, assign) BOOL reportsWhitespaceTokens;
@end

