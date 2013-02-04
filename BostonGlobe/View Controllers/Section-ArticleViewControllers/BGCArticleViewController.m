//
//  ViewController.m
//  bostonglob
//
//  Created by Amit Vyawahare on 12/7/12.
//  Copyright (c) 2012 Amit Vyawahare. All rights reserved.
//

#import "BGCArticleViewController.h"
#import "GRMustacheTemplate.h"
#import "BGMArticle.h"
#import "BGMArticleAbstract.h"
#import "BGMArticleImage.h"
#import "BGMImageManager.h"
#import "BGCSectionStoryFeedTableViewController.h"
#import "BGCSectionScrollViewController.h"
#import "BGCRootViewController.h"

@interface BGCArticleViewController () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIActivityIndicatorView *articleIsLoadingIndicator;

@end

@implementation BGCArticleViewController

- (id)initWithArticle:(BGMArticle *)article
{
    self = [super init];
    if (self) {
        self.article = article;
        self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
        
        self.webView.delegate = self;
        self.webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
        [self preLoadWebView];
        
        self.articleIsLoadingIndicator = [[UIActivityIndicatorView alloc] initWithFrame:self.view.frame];
        self.articleIsLoadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;

        CGAffineTransform transform = CGAffineTransformMakeScale(3.0f, 3.0f);
        self.articleIsLoadingIndicator.transform = transform;
        
        [self.view addSubview:self.webView];
        [self.view addSubview:self.articleIsLoadingIndicator];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(imageDoneDownloading:)
                                                     name:IMAGE_DONE_DOWNLOADING_NOTIFICATION
                                                   object:nil];
    }
    return self;
}

- (void)imageDoneDownloading:(NSNotification *)notificaiton
{
    BGMArticleImage *articleImage = notificaiton.object;
    [self performSelectorOnMainThread:@selector(loadImage:) withObject:articleImage waitUntilDone:YES];
}

- (void)loadImage:(BGMArticleImage *)articleImage
{
    NSString *imageFilePath = articleImage.imageFilePath;

    NSUInteger index = [self.article.articleAbstract.articleImages indexOfObject:articleImage];
    
    NSString *jsFormatString = @"$('#slider .slides li img:eq(%d)').fadeOut(400, function(e){ var $that = $(this); $that.attr('src', \"%@\"); $that.fadeIn(400); });";
    NSString *jsString = [NSString stringWithFormat:jsFormatString, index+1, imageFilePath ];
    [self.view.subviews[0] stringByEvaluatingJavaScriptFromString:jsString];
    
    if (index == self.article.articleAbstract.articleImages.count-1) {
        jsString = [NSString stringWithFormat:jsFormatString, 0, imageFilePath ];
        [self.view.subviews[0] stringByEvaluatingJavaScriptFromString:jsString];
    } else if (index == 0) {
        jsString = [NSString stringWithFormat:jsFormatString, self.article.articleAbstract.articleImages.count+1, imageFilePath ];
        [self.view.subviews[0] stringByEvaluatingJavaScriptFromString:jsString];
    }
}

- (void)preLoadWebView
{
    NSString *htmlPath;
    htmlPath = [[NSBundle mainBundle] pathForResource:@"articleTemplateWithImage" ofType:@"html"];
    
    NSString *content = [NSString stringWithContentsOfFile:htmlPath
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    
    [self.webView loadHTMLString:content baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSDate *shortDate = self.article.articleAbstract.pubDate;
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setTimeStyle:NSDateFormatterShortStyle];
    [timeFormatter setDateStyle:NSDateFormatterNoStyle];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateFormat:ArticleDateFormat];
    
    NSString *todaysDate = [dateFormatter stringFromDate:[NSDate date]];
    NSString *timeStamp = [dateFormatter stringFromDate:shortDate];
    NSString *timeStampSuffix = @"";
    
    if (![timeStamp isEqualToString:todaysDate]) {
        timeStamp = [timeFormatter stringFromDate:shortDate];
        if ([timeStamp rangeOfString:AMString].length > 0) {
            timeStamp = [timeStamp stringByReplacingOccurrencesOfString:AMString withString:@""];
            timeStampSuffix = AMString;
        } else if ([timeStamp rangeOfString:PMString].length > 0) {
            timeStamp = [timeStamp stringByReplacingOccurrencesOfString:PMString withString:@""];
            timeStampSuffix = PMString;
        }
    }
    
    
    NSString *authorName = self.article.articleAbstract.author;
    NSString *authorByTTL = [self.article.articleAbstract.authorByTTL uppercaseString];
    
    NSArray *viewContentObjects;
    NSArray *viewContentKeys;
    
    if (![timeStampSuffix isEqualToString:@""]) {
        viewContentObjects = @[self.article.articleAbstract.title, self.article.articleAbstract.sectionName, timeStamp, timeStampSuffix, authorName, self.article.articleAbstract.kicker, authorByTTL];
        viewContentKeys = @[ArticleHeadline, ArticleSection, ArticleTimeStamp, ArticleTimeStampSuffix, ArticleAuthor, ArticleKickerText, ArticleAuthorJob];
    } else {
        viewContentObjects = @[self.article.articleAbstract.title, self.article.articleAbstract.sectionName, timeStamp, authorName, self.article.articleAbstract.kicker, authorByTTL];
        viewContentKeys = @[ArticleHeadline, ArticleSection, ArticleTimeStamp, ArticleAuthor, ArticleKickerText, ArticleAuthorJob];
    }
    
    NSDictionary *object = [NSDictionary dictionaryWithObjects:viewContentObjects
                                                       forKeys:viewContentKeys];
    
    NSString *htmlPath;
    if (self.article.articleAbstract.articleImages.count > 0) {
        htmlPath = [[NSBundle mainBundle] pathForResource:ArticleTemplateWithImage ofType:@"html"];
    } else {
        htmlPath = [[NSBundle mainBundle] pathForResource:ArticleTemplateWithoutImage ofType:@"html"];
    }
    
    NSString *content = [NSString stringWithContentsOfFile:htmlPath
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    
    if (authorName == nil || [authorName isEqualToString:@""]) {
        content = [content stringByReplacingOccurrencesOfString:@"By <b>{{author}}</b>"
                                                     withString:[NSString stringWithFormat:@"<b>{{author}}</b>"]];
    }
    
    if (self.article.articleAbstract.articleImages.count > 0) {
        for (BGMArticleImage *articleImage in self.article.articleAbstract.articleImages) {
            content = [content stringByReplacingOccurrencesOfString:@"<!-- INSERT IMAGES HERE -->"
                                                         withString:[NSString stringWithFormat:@"<li>\n<img src=\"%@\" />\n</li>\n<!-- INSERT IMAGES HERE -->", @"Icon@2x.png"]];
        }
    }
    
    for (int i = 0; i < self.article.paragraphs.count; i++) {
        content = [content stringByReplacingOccurrencesOfString:@"<!-- INSERT ARTICLE CONTENTS HERE -->"
                                                     withString:[NSString stringWithFormat:@"%@<!-- INSERT ARTICLE CONTENTS HERE -->", self.article.paragraphs[i]]];
    }
    
    NSString *html = [GRMustacheTemplate renderObject:object fromString:content error:nil];
    
    [self.webView loadHTMLString:html baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.rootViewController changeChromeToArticleViewChrome];
    
    for (BGMArticleImage *articleImage in self.article.articleAbstract.articleImages) {
        NSString *imagePath = [[BGMImageManager sharedInstance] imagePathForArticleImage:articleImage];
        if (imagePath != nil) {
            [self loadImage:articleImage];
        }
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.articleIsLoadingIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.articleIsLoadingIndicator stopAnimating];
    self.articleIsLoadingIndicator.hidden = YES;
    
    NSString *js = @"var styleNode = document.createElement('style');\n"
                    "styleNode.type = 'text/css';\n"
                    "var styleText = document.createTextNode('a {-webkit-tap-highlight-color:rgba(0,0,0,0)}');\n"
                    "styleNode.appendChild(styleText);\n"
                    "document.getElementsByTagName('head')[0].appendChild(styleNode);\n";

    [self.webView stringByEvaluatingJavaScriptFromString:js];
    [self.rootViewController hideChromeWithDelay:2.0];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url = request.URL;
	NSString *urlString = url.absoluteString;
    if ([urlString isEqualToString:@"http://goback/"]) {
        [self.sectionViewController goBackToSectionStoryFeed];
        return NO;
    } else if ([urlString isEqualToString:@"http://togglechrome/"]) {
        [self.rootViewController toggleChromeWithDelay:0.0];
        return NO;
    }
    return YES;
}

@end
