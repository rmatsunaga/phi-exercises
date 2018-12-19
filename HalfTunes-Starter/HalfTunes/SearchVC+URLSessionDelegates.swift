//
//  SearchVC+URLSessionDelegates.swift
//  HalfTunes
//
//  Created by Rey Matsunaga on 12/18/18.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import Foundation
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
}
