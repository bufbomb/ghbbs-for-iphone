    //
//  NewPostViewController.m
//  ghbbs
//
//  Created by Chenqun Hang on 12/1/10.
//  Copyright 2010 bufbomb.com. All rights reserved.
//

#import "NewPostViewController.h"
#import "NewPostParser.h"
#import "DataConvertor.h"

@interface NewPostViewController()
- (void) updateUIWithTitleAndContent:(NSArray *)titleAndContent;

@end


@implementation NewPostViewController

- (id) init
{
    if (self = [super init])
    {
        _titleView = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 30.0f)];
        _postView = [[UITextView alloc] initWithFrame:CGRectMake(0.0f, 35.0f, 320.0f, 430.0f)];
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _indicatorView.frame = CGRectMake(140.0f, 160.0f, 40.0f, 40.0f);
        _indicatorView.hidesWhenStopped = YES;
        _postView.scrollEnabled = YES;
        _postView.contentSize = CGSizeMake(320.0f, 600.0f);
        
        _bid = nil;
        _pid = nil;
        
        _boardPermission = nil;
    }
    return self;
}

- (void) setTarget:(id)target Selector:(SEL)selector
{
    NSAssert(target != nil, @"target shouldn't be nil.");
    [_target release];
    _target = [target retain];
    _selector = selector;
}

- (void) setBid:(NSString *)bid
{
    [_bid release];
    _bid = [bid retain];
}

- (void) setPid:(NSString *)pid
{
    [_pid release];
    _pid = [pid retain];
}


- (void)loadView {
    [super loadView];
    UIBarButtonItem * button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                             target:self 
                                                                             action:@selector(done)];
    self.navigationItem.rightBarButtonItem = button;
    [button release];

    _titleView.borderStyle = UITextBorderStyleRoundedRect;
    _titleView.placeholder = @"标题";
    _titleView.backgroundColor = [UIColor blackColor];
    _postView.delegate = self;

    _postView.font = [UIFont systemFontOfSize:14.0f];
    [_postView becomeFirstResponder];
    [self.view addSubview:_titleView];
    [self.view addSubview:_postView];
    [self.view addSubview:_indicatorView];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void) done
{
    [_titleView resignFirstResponder];
    [_postView resignFirstResponder];
    [self beginPost];
}

- (void) beginPost
{
    NSString * urlString = [NSString stringWithFormat: @"http://bbs.fudan.sh.cn/bbs/snd?bid=%@&f=%@", _bid, _pid == nil ? @"" : _pid];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:urlString]];
    [theRequest setHTTPMethod:@"POST"];
    //HTTPBody format: title=...&sig=.&text=...
    NSString * httpBody = [NSString stringWithFormat:@"title=%@&sig=1&text=%@", [DataConvertor URLEncodeGB18030String:_titleView.text], [DataConvertor URLEncodeGB18030String:_postView.text], nil];
    [theRequest setHTTPBody:[httpBody dataUsingEncoding:NSUTF8StringEncoding]];
    [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil error:nil];
    [self endPost];
}

- (void) endPost
{
    [self.navigationController popViewControllerAnimated:YES];
    [_target performSelector:_selector withObject:_titleView.text withObject:_postView.text];
}

- (void) fetch
{
    NSAssert(_bid != nil, @"Bid shouldn't be nil");
    [self setEnableInput:NO];
    NSMutableString * urlstr = [[NSMutableString alloc] initWithFormat:@"http://bbs.fudan.sh.cn/bbs/pst?bid=%@", _bid];
    if ([self isReplyPost]) 
    {
        //This is a reply instead of a new topic
        [urlstr appendFormat:@"&f=%@", _pid];
    }
    NSURL * url = [[NSURL alloc] initWithString:urlstr];
    NewPostParser * parser = [[NewPostParser alloc] initWithURL:url];
    [urlstr release];
    [url release];
    parser.delegate = self;
    NSOperationQueue * queue = [NSOperationQueue new];
    [queue addOperation:parser];
    [parser release];
}

- (void) setEnableInput:(BOOL)enabled
{
    _titleView.enabled= enabled;
    _postView.editable = enabled;
    self.navigationItem.rightBarButtonItem.enabled = enabled;
    if (enabled) 
    {
        [_indicatorView stopAnimating];
        [_postView becomeFirstResponder];
    }
    else
    {
        [_indicatorView startAnimating];
    }
}

- (void) enableInput
{
    [self setEnableInput:YES];
}

- (void) disableInput;
{
    [self setEnableInput:NO];
}

- (BOOL) isReplyPost
{
    return _pid != nil;
}

- (void) viewDidLoad {
    [super viewDidLoad];
    [self fetch];
}

#pragma mark -
#pragma mark BBSParserDelegate
- (void) onParseSuccessful:(NSDictionary *)data
{
    _boardPermission = [data objectForKey:kBoardPermission];
    NSString * _postTitle = [data objectForKey:kTitle];
    NSString * _postContent = [data objectForKey:kPostContent];
    if (_postTitle != nil && _postContent != nil) 
    {
        [self performSelectorOnMainThread:@selector(updateUIWithTitleAndContent:) withObject:[NSArray arrayWithObjects:_postTitle, _postContent, nil] waitUntilDone:YES];
    }
    [self performSelectorOnMainThread:@selector(enableInput) withObject:nil waitUntilDone:YES];
}

- (void) updateUIWithTitleAndContent:(NSArray *)titleAndContent
{
    NSAssert(titleAndContent != nil, @"TitleAndContent shouldn't be nil");
    NSAssert([titleAndContent count] == 2, @"TitleAndContent should be array of size 2");
    NSString * _postTitle = [titleAndContent objectAtIndex:0];
    NSString * _content = [titleAndContent objectAtIndex:1];
    if (_postTitle != nil) 
    {
        if ([self isReplyPost] && ![_postTitle hasPrefix:@"Re: "])
        {
            _titleView.text = [NSString stringWithFormat:@"Re: %@", _postTitle];
        }
        else
        {
            _titleView.text = _postTitle;            
        }
    }
    if (_content != nil)
    {
        NSRange range = {0, 0};
        NSString * postText = [NSString stringWithFormat:@"\n%@", _content];
        _postView.text = postText;
        _postView.selectedRange = range;
    }
    
}

- (void) onParseFailed:(ErrorType)error
{
    switch (error) 
    {
        case ErrorTypeNetwork:
            [self popUpRetryAlertWithTitle:@"发生错误" Message:@"网络错误"];
            break;
        case ErrorTypeParse:
            [self popUpConfirmAlertWithTitle:@"发生错误" Message:@"解析文档时发生错误"];
            break;
        case ErrorTypeEncoding:
            [self popUpConfirmAlertWithTitle:@"发生错误" Message:@"由于文档编码错误，该页无法显示"];
            break;
        case ErrorTypeNotLogin:
            [self popUpConfirmAlertWithTitle:@"发生错误" Message:@"由于文档编码错误，该页无法显示"];
            break;
        case ErrorTypeNoPermission:
            [self popUpConfirmAlertWithTitle:@"发生错误" Message:@"由于文档编码错误，该页无法显示"];
            break;
        default:
            assert(NO);
    }    
}

- (void) popUpRetryAlertWithTitle:(NSString *)title Message:(NSString *)message
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重试", nil];
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
    [alert release];
}

- (void) popUpConfirmAlertWithTitle:(NSString *)title Message:(NSString *)message
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:NO];
    [alert release];
}


#pragma mark -
#pragma mark UITextViewDelegate
- (void) textViewDidBeginEditing:(UITextView *)textView
{
    if (textView == _postView) 
    {
        _postView.frame = CGRectMake(0.0f, 35.0f, 320.0f, 200.0f);
    }
}
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [_bid release];
    [_pid release];
    [_postView release];
    [_target release];
    [_indicatorView release];
    [super dealloc];
}


@end
