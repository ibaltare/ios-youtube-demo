//
//  VideoTableViewCell.swift
//  youtube-demo
//
//  Created by Nicolas on 03/05/23.
//

import UIKit

class VideoTableViewCell: UITableViewCell {

    @IBOutlet var img: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    var video: Video?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(_ v:Video) {
        self.video = v
        
        guard self.video != nil else { return }
        
        self.titleLabel.text = video?.title
        let df = DateFormatter()
        df.dateFormat = "EEEE, MMM d, yyyy"
        self.dateLabel.text = df.string(from: video!.published)
        
        guard self.video?.thumbnail != ""  else {
            return
        }
        
        // check cache before download data
        if let cacheData = CacheManager.getVideoCache(self.video!.thumbnail) {
            DispatchQueue.main.async {
                self.img.image = UIImage(data: cacheData)
            }
            return
        }
        
        //download the thumbnail data
        let url = URL(string: self.video!.thumbnail)
        // get shared url session object
        let session = URLSession.shared
        // create data task
        let dataTask = session.dataTask(with: url!) { data, response, error in
            if error == nil && data != nil {
                // save data in the cache
                CacheManager.setVideoCache(url!.absoluteString, data)
                
                /**check that the download url matches the video thumbnail url that this cell
                 is currently set to display**/
                if url!.absoluteString != self.video?.thumbnail {
                    /** video cell  has been recycled for another video and no longer
                     matches the thumbnail that was downloaded*/
                    return
                }
                
                let image = UIImage(data: data!)
                DispatchQueue.main.async {
                    self.img.image = image
                }
            }
        }
        dataTask.resume()
    }

}
