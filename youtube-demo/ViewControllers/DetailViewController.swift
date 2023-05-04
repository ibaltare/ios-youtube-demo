//
//  DetailViewController.swift
//  youtube-demo
//
//  Created by Nicolas on 03/05/23.
//

import UIKit
import WebKit
class DetailViewController: UIViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var textView: UITextView!
    @IBOutlet var webView: WKWebView!
    
    var video: Video?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        // clear the fields
        titleLabel.text = ""
        dateLabel.text = ""
        textView.text = ""
        
        //check video
        guard video != nil else { return }
        
        //ceate embed url
        let embedUrl = Constants.YT_EMBED_URL + video!.videoId
        
        // load it into the webview
        let request = URLRequest(url: URL(string: embedUrl)!)
        webView.load(request)
        
        //set the text
        titleLabel.text = video?.title
        
        let df = DateFormatter()
        df.dateFormat = "EEEE, MMM d, yyyy"
        dateLabel.text = df.string(from: video!.published)
        
        textView.text = video?.description
    }

}
