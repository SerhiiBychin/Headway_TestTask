//
//  GitHubAPIService.swift
//  Headway_TestTask
//
//  Created by Serhii Bychin on 25.10.2020.
//


import RxSwift
import RxCocoa

protocol GitHubAPIAuthProvider {
    func login(withUsername username: String, password: String) -> Observable<Bool>
}

protocol GitHubAPIProvider: GitHubAPIAuthProvider { }


final class GitHubAPIService: GitHubAPIProvider {
    private let httpClient: HTTPClientProvider
    
    init(httpClient: HTTPClientProvider = HTTPClient()) {
        self.httpClient = httpClient
    }
    
    
    func login(withUsername username: String, password: String) -> Observable<Bool> {
        let credentialData = "\(username):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        
        
        return httpClient.post(url: "https://api.github.com/authorizations",
                               params: ["scopes": ["repo", "read:user"], "note": ["test"], "fingerprint": ["\(UUID().uuidString)"]],
                               base64Credentials: base64Credentials)
            .map { (data) -> Bool in
                guard let data = data,
                      let response = try? JSONDecoder().decode(AuthorizationResponse.self, from: data) else {
                    return false
                }
                print(response.token ?? "")
                return true
            }
            .catchError { (error) in
                throw error
            }
    }
}

extension GitHubAPIService: StaticFactory {
    enum Factory {
        static let `default`: GitHubAPIProvider = GitHubAPIService()
    }
}
