//
//  MockHomeRouter.swift
//  SearchTunesTests
//
//  Created by Batuhan Demircioğlu on 11.06.2023.
//

import Foundation
@testable import SearchTunes

final class MockHomeRouter: HomeRouterProtocol {
    var navigateToDetailCalled = false
    var navigateToDetailRoute: HomeRoutes?
    var navigateParameters: (route: HomeRoutes, Void)?

    func navigateToDetail(_ route: HomeRoutes) {
        navigateToDetailCalled = true
        navigateParameters = (route, ())
    }
}
