//
//  LaunchServiceStub.swift
//  SpaceXTests
//
//  Created by David Beleza on 23/10/2021.
//

import Foundation
import SpaceX

final class LaunchServiceStub: LaunchService {

    typealias ListResponse = Launch.ListResponse
    typealias Response = ListResponse.Response
    typealias ResponseMetadata = Response.Metadata
    typealias MetadataImages = ResponseMetadata.Images
    typealias ResponseRocket = Response.Rocket

    var listResponse = ListResponse(list: [Response(id: "1",
                                                    missionName: "Spacex",
                                                    launchDateUnix: 123456789,
                                                    launchSuccess: true,
                                                    metadata: ResponseMetadata(images: MetadataImages(small: "",
                                                                                                      large: ""),
                                                                               articleLink: "https://article.com",
                                                                               wikipediaLink: "https://wikipedia.com",
                                                                               youtubeLink: "https://youtube.com"),
                                                    rocket: ResponseRocket(name: "Fenix",
                                                                           type: "F1"))],
                                    totalResults: 100)

    var delayRequestSeconds: Double?
    var launchesResponse: (Result<Launch.ListResponse, Error>)?
    func fetchLaunches(limit: Int, offset: Int, filter: Filter.State?, completion: @escaping ((Result<Launch.ListResponse, Error>)) -> Void) {
        if let secondsDelay = delayRequestSeconds {
            DispatchQueue.global().asyncAfter(deadline: .now() + secondsDelay) { [weak self] in
                guard let self = self else { return }
                completion(self.launchesResponse!)
            }
        } else {
            completion(launchesResponse!)
        }

    }
}
