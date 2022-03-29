//
//  PKWordState.h
//  SKPegKit
//
//  Created by Sam Krishna on 3/25/22.
//

#import <SKPegKit/PKTokenizerState.h>

@interface PKWordState : PKTokenizerState

- (void)setWordChars:(BOOL)yn from:(PKUniChar)start to:(PKUniChar)end;

- (BOOL)isWordChar:(PKUniChar)c;

@end

