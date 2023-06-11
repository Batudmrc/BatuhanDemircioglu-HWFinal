//
//  MockHomeViewController.swift
//  SearchTunesTests
//
//  Created by Batuhan Demircioğlu on 11.06.2023.
//

import Foundation
@testable import SearchTunes

final class MockHomeViewController: HomeViewControllerProtocol {
    
    var setupTableViewCalled = false
    var showLoadingCalled = false
    var hideLoadingCalled = false
    var reloadDataCalled = false
    var setupEmptyViewCalled = false
    
    func setupTableView() {
        setupTableViewCalled = true
    }
    
    func showLoading() {
        showLoadingCalled = true
    }
    
    func hideLoading() {
        hideLoadingCalled = true
    }
    
    func reloadData() {
        reloadDataCalled = true
    }
    
    func setupEmptyView() {
        setupEmptyViewCalled = true
    }
    
}
