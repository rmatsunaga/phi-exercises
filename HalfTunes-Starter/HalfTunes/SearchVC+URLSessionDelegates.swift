//
//  SearchVC+URLSessionDelegates.swift
//  HalfTunes
//
//  Created by Rey Matsunaga on 12/18/18.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import Foundation
import UIKit
extension SearchViewController: URLSessionDownloadDelegate {
  func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
    // Extract original request URL from task & remove corresponding download from dictionary
    guard let sourceURL = downloadTask.originalRequest?.url else { return }
    let download = downloadService.activeDownloads[sourceURL]
    downloadService.activeDownloads[sourceURL] = nil
    // pass URL to localFilePath(for:) helper method in SearchViewController.swift, generating a permanent local file path to save to. Appends lastPath Component of URL to path of app's documents directory
    let destinationURL = localFilePath(for: sourceURL)
    print(destinationURL)
    // Uses FileMnager to move download file from temp location to desired file path destination. Clears out item at location before starting to copy task. Shows that file has been downloaded
    let fileManager = FileManager.default
    try? fileManager.removeItem(at: destinationURL)
    do {
      try fileManager.copyItem(at: location, to: destinationURL)
      download?.track.downloaded = true
    } catch let error {
      print("Could not copy file to disk: \(error.localizedDescription)")
    }
    // Uses download track's index property to reload corresponding cell
    if let index = download?.track.index {
      DispatchQueue.main.async {
        self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
      }
    }
    
  }
  func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
    // Extract URL of provided downloadTask and find matching download in dictionary of active downloads
    guard let url = downloadTask.originalRequest?.url,
      let download = downloadService.activeDownloads[url] else { return }
    // provides total bytes writtena nd total bytes expected to be written. Calculate progress as ratio of the two values and save result in Download. Track cell uses this to update progress view
    download.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
    // Takes a byte value and generates readable string showing total download file size. Uses string to show download size as well as percentage complete
    let totalSize = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite, countStyle: .file)
    // Find responsible cell for displaying Track and calls fnction to update progress view and progress label with values previously derived. 
    DispatchQueue.main.async {
      if let trackCell = self.tableView.cellForRow(at: IndexPath(row: download.track.index, section: 0)) as? TrackCell {
        trackCell.updateDisplay(progress:download.progress, totalSize: totalSize)
      }
    }
  }
}

extension SearchViewController: URLSessionDelegate {
  
  func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
    DispatchQueue.main.async {
      if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
        let completionHandler = appDelegate.backgroundSessionCompletionHandler {
        appDelegate.backgroundSessionCompletionHandler = nil
        completionHandler()
      }
    }
  }
  
}
