#import "XmlDelegate.h"

@implementation XmlDelegate
@synthesize uri = _uri;
@synthesize GoButton = _GoButton;
@synthesize test = _test;
@synthesize safari ;



-(void)awakeFromNib{
    
    
}

- (IBAction)connectToUrl:(id)sender {
    NSArray *data =[self getXmlData:[self.uri stringValue]];    
    [[self.safari mainFrame ]loadRequest:[data objectAtIndex:1]];
    [self manipulateXml:[data objectAtIndex:0]];
    
}

-(void)manipulateXml:(NSString *) xmlData{
    NSError *error;
    NSXMLDocument * xmlDoc = [[NSXMLDocument alloc ]init ];
    xmlDoc = [xmlDoc initWithXMLString:xmlData options:[@"" integerValue] error:&error];
    
    NSFileHandle *file;
    NSData *data;
    
    file = [NSFileHandle fileHandleForUpdatingAtPath: @"/Users/Thoughtworks/Desktop/RightNowDetails.csv"];
    
    NSArray *children = [[xmlDoc rootElement] children];
    
    int i, count = [children count];
    for (i=0; i < count; i++) {
        NSXMLElement *child = [children objectAtIndex:i];
        if ([child.name isEqual:@"user"]) {
            
            NSXMLNode *uri = [child attributeForName:@"uri"];
            NSXMLNode *hash = [child attributeForName:@"hash"];
            
            NSString *uriValue = [uri stringValue];
            NSString *hashValue = [hash stringValue];
            NSString * emailId = [self getEmail:uriValue];
            NSString * loginID = [child.nextNode stringValue];
            
            
            NSLog(@"@Url :%@", uriValue);
            NSLog(@"@hash :%@", hashValue);
            NSLog(@"@loginID :%@",loginID);
            
            
            NSLog(@"@emailID :%@", emailId);
            
            NSString *nonByteString = [NSString stringWithFormat:@"%@, %@, %@\r\n", hashValue, loginID, emailId];
            //const char *byteString =[nonByteString cStringUsingEncoding:NSUTF8StringEncoding];
            
            data = [nonByteString dataUsingEncoding:NSUnicodeStringEncoding];
            [self writeDataToFile:data :file];
            
        }
    }
    [file closeFile];
    [self.test setStringValue:[[xmlDoc rootElement]XMLString]];
}

-(NSString*)getEmail:(NSString*) url{
    NSArray *data =[self getXmlData:url];
    NSError *error;
    NSXMLDocument * xmlDoc = [[NSXMLDocument alloc ]init ];
    xmlDoc = [xmlDoc initWithXMLString:[data objectAtIndex:0] options:[@"" integerValue]  error:&error];
    
    return [[[xmlDoc rootElement] childAtIndex:2] stringValue];
}

-(NSArray*)getXmlData:(NSString*)uri{
    
    NSString *authorizationString;
    
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    CFHTTPMessageRef dummyRequest =
    CFHTTPMessageCreateRequest(
                               kCFAllocatorDefault,
                               CFSTR("GET"),
                               (__bridge CFURLRef)[urlRequest URL],
                               kCFHTTPVersion1_1);
    CFHTTPMessageAddAuthentication(
                                   dummyRequest,
                                   nil,
                                   (CFStringRef)@"username",
                                   (CFStringRef)@"password",
                                   kCFHTTPAuthenticationSchemeBasic,
                                   FALSE);
    authorizationString =
    (__bridge NSString *)CFHTTPMessageCopyHeaderFieldValue(
                                                           dummyRequest,
                                                           CFSTR("Authorization"));
    CFRelease(dummyRequest);    
    
    
    [urlRequest setURL:[NSURL URLWithString: uri]];
    [urlRequest setValue:authorizationString forHTTPHeaderField:@"Authorization"];
    
    NSData *urlData; 
    NSURLResponse *response; 
    NSError *error;
    
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error]; 
    if(!urlData) {
        NSLog(@"No connection!");
    }
    
    //    NSLog(@"Receive:%lu bytes",[urlData length]);
    NSString *aStr = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding]; 
    NSMutableArray *auxArray =[[NSMutableArray alloc]init];
    [auxArray addObject:aStr];
    [auxArray addObject:urlRequest];
    
    return auxArray;
}

-(void)writeDataToFile:(NSData *) data :(NSFileHandle *) file { 
    
    if (file == nil)
        NSLog(@"Failed to open file");
    [file seekToEndOfFile];
    [file writeData: data];


}



@end
