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
    print("Finished downloading to \(location).")
  }
}
