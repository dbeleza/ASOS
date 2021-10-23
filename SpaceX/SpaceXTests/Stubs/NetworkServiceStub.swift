//
//  NetworkServiceStub.swift
//  SpaceXTests
//
//  Created by David Beleza on 23/10/2021.
//

import Foundation
import SpaceX

final class NetworkServiceStub: NetworkService {
    var response: Response?

    func execute(request: Request, completion: @escaping (Response) -> Void) {
        if let response = self.response {
            completion(response)
        }
    }
}
