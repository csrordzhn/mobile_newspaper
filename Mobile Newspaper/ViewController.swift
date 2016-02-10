//
//  ViewController.swift
//  Mobile Newspaper
//
//  Created by Cesar Ordonez on 2/6/16.
//  Copyright © 2016 Cesar Ordonez. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIWebViewDelegate {


    @IBOutlet weak var pgProgress: UIProgressView!
    @IBOutlet weak var wvPDFViewer: UIWebView!
    @IBAction func btnAction(sender: AnyObject) {
        pgProgress.hidden = false
        pgProgress.setProgress(0.0, animated: true)
        
        let api_url = getAPIURL()
        pgProgress.setProgress(0.2, animated: true)
        getNewspaperURL(api_url)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        wvPDFViewer.delegate = self
        pgProgress.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func webViewDidFinishLoad(webView: UIWebView)
    {
        //print("Done")
        pgProgress.setProgress(1.0, animated: true)
        sleep(2)
        pgProgress.hidden = true
    }
    
    //my functions
    func getNewspaperURL(api_url: String) -> Void {
        
        let url:NSURL = NSURL(string: api_url)!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        let task = session.dataTaskWithRequest(request) {
            
            (let data, let response, let error) in
            guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                print("error")
                return
            }
            
            let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            
            self.pgProgress.setProgress(0.6, animated: true)
            //going the string parsing way to start
            let start = dataString!.rangeOfString("http")
            let finish = dataString!.rangeOfString("pdf")
            let urlLength = finish.location + finish.length - start.location
            let pdfURL = dataString!.substringWithRange(NSRange(location: start.location, length: urlLength))
            self.pgProgress.setProgress(0.8, animated: true)
            let url = NSURL(string: pdfURL)
            let request: NSURLRequest = NSURLRequest(URL: url!)
            
            self.wvPDFViewer.loadRequest(request)
            
        }
        task.resume()
    }
    
    func getAPIURL() ->String {
        //get API URL from plist file
        let path = NSBundle.mainBundle().pathForResource("hhn", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!)
        let api_url: AnyObject = dict!.objectForKey("api_url")!
        
        return api_url as! String
    }
}

