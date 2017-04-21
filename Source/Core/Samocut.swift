//
//  Samocut.swift
//  Samocut
//
//  Created by Orangesoft Developer on 14.04.17.
//  Copyright © 2017 Orangesoft. All rights reserved.
//

import Foundation

public class Samocut : NSObject {
    let videoInfoByIdURL = "https://www.youtube.com/get_video_info?v=3&video_id="
    public typealias SamocutCompletionHandler = (_ responseData: [String : String]?, _ error: String?) -> Swift.Void
    
    private func videoURLBy(videoId: String) -> URL {
        return URL(string: self.videoInfoByIdURL + videoId)!
    }
    
    open func videoIdFrom(videoURL: URL) -> String? {
        var videoId: String?
        let host = videoURL.host
        let pathComponents = videoURL.pathComponents
        if host != nil && pathComponents.count > 0 {
            switch host! {
            case "youtu.be":
                videoId = pathComponents.last
                break
            case "www.youtube.com", "youtube.com":
                if videoURL.absoluteString.contains("youtube.com/embed") {
                    videoId = pathComponents.last
                } else {
                    if let result = videoURL.absoluteString.components(separatedBy: "?").last {
                        let components = parse(URLString: result)
                        videoId = components?["v"]
                    }
                }
                break
            default:
                break
            }
        }
        return videoId?.characters.count == 0 ? nil : videoId
    }
    
    func parse(URLString: String) -> [String : String]? {
        var data = [String : String]()
        for item in URLString.components(separatedBy: "&") {
            let itemValues = item.components(separatedBy: "=")
            if itemValues.count != 2 {
                continue
            }
            
            let key = self.decode(URLString: itemValues.first!)
            let value = self.decode(URLString: itemValues.last!)
            data[key] = value
            if value.contains("&") && value.contains("=") {
                if let valueItems = parse(URLString: value) {
                    data.append(other: valueItems)
                }
            }
        }
        return data.keys.count > 0 ? data : nil
    }
    
    func parseVideoComponentsFrom(videoInformation: [String : String]) -> [String : String]? {
        guard var streamMap = videoInformation["url_encoded_fmt_stream_map"] else {
            return nil
        }
        if let fpsStremapMap = videoInformation["adaptive_fmts"] {
            streamMap = streamMap + "&" + fpsStremapMap
        }

        let streamMapItems = streamMap.components(separatedBy: ",")
        var videoComponents = [String : String]()
        for item in streamMapItems {
            if let components = parse(URLString: item), let componentType = components["type"] {
                if componentType.contains("mp4") {
                    if let url = components["url"], let quality = components["quality"] ?? components["quality_label"] {
                        videoComponents[quality] = self.decode(URLString: url)
                    }
                } else {
                    continue
                }
            }
        }
        return videoComponents.keys.count > 0 ? videoComponents : nil
    }
    
    func decode(URLString: String) -> String {
        let editedURLString = URLString.replacingOccurrences(of: "+", with: " ")
        guard let decodedString = editedURLString.removingPercentEncoding else {
            return editedURLString
        }
        return decodedString
    }
    
    func dataTastWithURL(URL: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.timeoutIntervalForRequest = 10.0
        
        let session = URLSession(configuration: sessionConfiguration)
        let dataTask = session.dataTask(with: URL, completionHandler: completionHandler)
        dataTask.resume()
    }
    
    func serializeVideoResponse(data: Data) -> [String : String]? {
        guard let dataString = String(data: data, encoding: .utf8) else {
            return nil
        }
        guard let videoInformation = self.parse(URLString: dataString) else {
            return nil
        }
        guard let components = self.parseVideoComponentsFrom(videoInformation: videoInformation) else {
            return nil
        }
        return components;
    }
    
    open func fetchVideoQualitiesBy(videoId: String, completionHandler: @escaping SamocutCompletionHandler) {
        let errorMessage = "Error while fetch video data";
        if videoId.characters.count == 0 {
            completionHandler(nil, errorMessage + ", uncorrect video identifier");
            return
        }
        dataTastWithURL(URL: videoURLBy(videoId: videoId)) { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if data != nil {
                if let components = self.serializeVideoResponse(data: data!) {
                    completionHandler(components, nil);
                } else {
                    completionHandler(nil, errorMessage);
                }
            } else {
                completionHandler(nil, errorMessage);
            }
        }
    }
    
    open func fetchVideoQualitiesBy(videoURL: URL, completionHandler: @escaping SamocutCompletionHandler) {
        if let videoId = videoIdFrom(videoURL: videoURL) {
            fetchVideoQualitiesBy(videoId: videoId, completionHandler: completionHandler)
        } else {
            completionHandler(nil, "Error while get video identifier from URL")
        }
    }
}

extension Dictionary {
    mutating func append(other:Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey:key)
        }
    }
}
