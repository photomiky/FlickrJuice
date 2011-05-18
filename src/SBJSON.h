/*
 Copyright (C) 2007-2009 Stig Brautaset. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution.
 
 * Neither the name of the author nor the names of its contributors may be used
   to endorse or promote products derived from this software without specific
   prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import <Foundation/Foundation.h>
#import <extThree20JSON/SBJsonParser.h>
#import <extThree20JSON/SBJsonWriter.h>


/**
 @brief Options for the parser class.
 
 This exists so the SBJSON facade can implement the options in the parser without having to re-declare them.
 */
@protocol SBJsonParser

/**
 @brief Return the object represented by the given string.
 
 Returns the object represented by the passed-in string or nil on error. The returned object can be
 a string, number, boolean, null, array or dictionary.
 
 @param repr the json string to parse
 */
- (id)objectWithString:(NSString *)repr;

@end

/**This exists so the SBJSON facade can implement the options in the writer without having to re-declare them.
*/
@protocol SBJsonWriter

/**
 @brief Whether we are generating human-readable (multiline) JSON.
 
 Set whether or not to generate human-readable JSON. The default is NO, which produces
 JSON without any whitespace. (Except inside strings.) If set to YES, generates human-readable
 JSON with linebreaks after each array value and dictionary key/value pair, indented two
 spaces per nesting level.
 */
@property BOOL humanReadable;

/**
 @brief Whether or not to sort the dictionary keys in the output.
 
 If this is set to YES, the dictionary keys in the JSON output will be in sorted order.
 (This is useful if you need to compare two structures, for example.) The default is NO.
 */
@property BOOL sortKeys;

/**
 @brief Return JSON representation (or fragment) for the given object.
 
 Returns a string containing JSON representation of the passed in value, or nil on error.
 If nil is returned and @p error is not NULL, @p *error can be interrogated to find the cause of the error.
 
 @param value any instance that can be represented as a JSON fragment
 
 */
- (NSString*)stringWithObject:(id)value;

@end




/**
 @brief Facade for SBJsonWriter/SBJsonParser.

 Requests are forwarded to instances of SBJsonWriter and SBJsonParser.
 */
@interface SBJSON : SBJsonBase <SBJsonParser, SBJsonWriter> {

@private    
    SBJsonParser *jsonParser;
    SBJsonWriter *jsonWriter;
}


/// Return the fragment represented by the given string
- (id)fragmentWithString:(NSString*)jsonrep
                   error:(NSError**)error;

/// Return the object represented by the given string
- (id)objectWithString:(NSString*)jsonrep
                 error:(NSError**)error;

/// Parse the string and return the represented object (or scalar)
- (id)objectWithString:(id)value
           allowScalar:(BOOL)x
    			 error:(NSError**)error;


/// Return JSON representation of an array  or dictionary
- (NSString*)stringWithObject:(id)value
                        error:(NSError**)error;

/// Return JSON representation of any legal JSON value
- (NSString*)stringWithFragment:(id)value
                          error:(NSError**)error;

/// Return JSON representation (or fragment) for the given object
- (NSString*)stringWithObject:(id)value
                  allowScalar:(BOOL)x
    					error:(NSError**)error;


@end
