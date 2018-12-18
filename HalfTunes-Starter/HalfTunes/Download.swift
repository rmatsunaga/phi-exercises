//
//  Download.swift
//  HalfTunes
//
//  Created by Rey Matsunaga on 12/18/18.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import Foundation

class Download {
  // Track to download, url property is unique identifier for a Download
  var track: Track
  
  init(track: Track) {
    self.track = track
  }
  
  // Download service sets these values:
  
  // URLSessionDownloadTask that downloads track
  var task: URLSessionDownloadTask?
  // Whether download is ongoing or paused
  var isDownloading = false
  // Stores Data produced when download is paused. If host supports it, app can use resumeData to resume a paused download later
  var resumeData: Data?
  
  // Download delegate sets this value:
  //    fractional progress of download: between 0.0 and 1.0
  var progress: Float = 0
  
}
