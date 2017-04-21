//
//  SamocutViewController.swift
//  Meme
//
//  Created by Orangesoft Developer on 18.04.17.
//  Copyright © 2017 Orangesoft. All rights reserved.
//

import UIKit
import Samocut

class SamocutViewController: UIViewController {

    @IBOutlet weak var videoInputField: UITextField!
    @IBOutlet weak var parseButton: UIButton!
    
    // MARK: Private methods
    
    func onUITextViewTextDidChange(notification: Notification) {
        videoInputFieldTextDidChange()
    }
    
    func videoInputFieldTextDidChange() {
        if let text = videoInputField.text {
            parseButton.isEnabled = text.characters.count > 0;
        }
    }
    
    // MARK: UIViewController methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        videoInputField.delegate = self;
        parseButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(SamocutViewController.onUITextViewTextDidChange), name: Notification.Name.UITextFieldTextDidChange, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UITextFieldTextDidChange, object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is VideoQualityViewController {
            let destination = segue.destination as! VideoQualityViewController
            destination.videoURL = URL(string: videoInputField.text!)
        }
    }
    
    // MARK: Actions
    
    @IBAction func onParseButtonTap(_ sender: UIButton) {
        if let videoURL = URL(string: videoInputField.text!) {
            let samocut = Samocut()
            if samocut.videoIdFrom(videoURL: videoURL) != nil {
                self.performSegue(withIdentifier: "QualitySegueIdnetifier", sender: videoURL)
            } else {
                self.alert(title: "Hmmm...", message: "Can't find video id from URL")
            }
        } else {
            self.alert(title: "Wow!", message: "Video URL is incorrect")
        }
    }
    
    @IBAction func onDefaultURLTap(_ sender: UIButton) {
        self.videoInputField.text = "https://youtu.be/iNJdPyoqt8U";
        videoInputFieldTextDidChange()
    }
}

extension SamocutViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let text = videoInputField.text {
            if text.characters.count > 0 {
                self.onParseButtonTap(self.parseButton)
            }
        }
        return false
    }
    
}
