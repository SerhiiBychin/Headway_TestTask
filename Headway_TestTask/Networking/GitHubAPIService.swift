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

protocol GitHubAPIReposProvider {
    func fetchRepos() -> Observable<Repos?>
    func searchRepos(forQuery query: String) -> Observable<Repos?>
}

protocol GitHubAPIProvider: GitHubAPIAuthProvider, GitHubAPIReposProvider { }


final class GitHubAPIService: GitHubAPIProvider {
    private let httpClient: HTTPClientProvider
    private let storage: StorageSavable
    
    init(httpClient: HTTPClientProvider = HTTPClient(), storage: StorageSavable = Storage()) {
        self.httpClient = httpClient
        self.storage = storage
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
                self.storage.saveToken(response.token ?? "")
                return true
            }
            .catchError { (error) in
                throw error
            }
    }
    
    func fetchRepos() -> Observable<Repos?> {
        return httpClient.get(url: "https://api.github.com/user/repos", token: storage.getToken() ?? "", params: nil)
            .map { (data) -> Repos? in
                guard let data = data,
                      let response = try? JSONDecoder().decode(Repos.self, from: data) else {
                    return nil
                }
                return response
            }
            .map { (repos) -> Repos? in
                return repos?.sorted(by: { (repo1, repo2) -> Bool in
                    return repo1.stargazersCount < repo2.stargazersCount
                })
            }
    }
    
    func searchRepos(forQuery query: String) -> Observable<Repos?> {
        return httpClient.get(url: "https://api.github.com/search/repositories?", token: storage.getToken() ?? "", params: ["q": query])
            .map { (data) -> Repos? in
                guard let data = data,
                      let response = try? JSONDecoder().decode(ReposResult.self, from: data) else {
                    return nil
                }
                return response.items
            }
            .map { (repos) -> Repos? in
                return repos?.sorted(by: { (repo1, repo2) -> Bool in
                    return repo1.stargazersCount < repo2.stargazersCount
                })
            }
    }
}

extension GitHubAPIService: StaticFactory {
    enum Factory {
        static let `default`: GitHubAPIProvider = GitHubAPIService()
    }
}
