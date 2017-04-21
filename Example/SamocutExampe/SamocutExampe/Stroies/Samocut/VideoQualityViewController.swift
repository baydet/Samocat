//
//  VideoQualityViewController.swift
//  Meme
//
//  Created by Orangesoft Developer on 18.04.17.
//  Copyright © 2017 Orangesoft. All rights reserved.
//

import UIKit
import Samocut
import AVKit
import AVFoundation

class VideoQualityViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var videoURL: URL?
    let samocut = Samocut()
    var qualities = [String]()
    var qualitiesData = [String: String]()
    var videoPlayer: AVPlayerViewController?
    
    // MARK: Private methods
    
    func presentMediaPlayer(videoURL: URL) {
        let player = AVPlayer(url: videoURL)
        if videoPlayer == nil {
            let playerVideController = AVPlayerViewController()
            playerVideController.view.frame = CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: view.frame.width);
            
            addChildViewController(playerVideController)
            tableView.tableHeaderView = playerVideController.view;
            tableView.tableHeaderView?.frame = playerVideController.view.frame
            
            videoPlayer = playerVideController
        }
        
        videoPlayer?.player?.pause()
        videoPlayer?.player = player;
        videoPlayer?.player?.play()
    }
    
    // MARK: UIViewController methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assert(videoURL != nil, "Video URL can't be nil")

        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.refreshControl?.beginRefreshing()
        samocut.fetchVideoQualitiesBy(videoURL: videoURL!) { [unowned self] (response: [String : String]?, error: String?) -> Swift.Void in
            DispatchQueue.main.async {
                if let responseQuality = response {
                    self.qualities = Array(responseQuality.keys)
                    self.qualitiesData = responseQuality
                    self.tableView.reloadData()
                } else {
                    self.alert(title: "Intresting..", message: "Can't get a video qualities, lets rock — run UNIT tests!")
                }
            }
        }
    }
    
    deinit {
        videoPlayer?.player?.pause()
        videoPlayer = nil
    }
}

extension VideoQualityViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.qualities.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "SamocutQualityCellIdentifier")!
    }
    
}

extension VideoQualityViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.text = self.qualities[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
        
        let quality = self.qualities[indexPath.row];
        if let stringURL = self.qualitiesData[quality] {
            if let videoURL = URL(string: stringURL) {
                self.presentMediaPlayer(videoURL: videoURL)
            }
        }
    }
}
