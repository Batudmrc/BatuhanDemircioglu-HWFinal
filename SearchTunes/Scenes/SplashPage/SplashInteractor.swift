//
//  SplashInteractor.swift
//  SearchTunes
//
//  Created by Batuhan Demircioğlu on 6.06.2023.
//

import Foundation
import NetworkPackage

protocol SplashInteractorProtocol: AnyObject {
    func checkConnection()
}

protocol SplashInteractorOutputProtocol {
    func connectionStatus(status: Bool)
}

final class SplashInteractor: SplashInteractorProtocol {
    
    var output: SplashInteractorOutputProtocol?
    
    func checkConnection() {
        let internetStatus = NetworkUtility.checkNetworkConnectivity()
        self.output?.connectionStatus(status: internetStatus)

    }
}
