import Foundation

public class GitHub {
	let username: String
	let token: String
	
	lazy var urlSession: NSURLSession = NSURLSession.sharedSession()
	
	public init(username: String, token: String) {
		self.username = username
		self.token = token
	}
	
	public func post(repository: Repository, endpoint: Endpoint, completion: ((Bool) -> Void)? = nil) {
		if let endpointUrl = NSURL(string: "\(repository.url)/\(endpoint.endpoint)") {
			let jsonDictionary = endpoint.payload
			
			print(endpointUrl.absoluteString)
					
			submitPayload(jsonDictionary, toUrl: endpointUrl, completion: completion)
		} else {
			print("Invalid endpoint URL")
		}
	}
	
	// func updateGithubStatus(status: Status, repo: String, sha: String) {
	//     if let statusesURL = NSURL(string: "https://api.github.com/repos/\(repo)/statuses/\(sha)") {
	//         // let targetUrl = "https://\(xcodeHost)/xcode/bots/" + env["XCS_BOT_TINY_ID"]! + "/latest/" + env["XCS_INTEGRATION_TINY_ID"]!
	//
	// 		let jsonDictionary = status.dictionary
	//
	// 		submitPayload(jsonDictionary, toUrl: statusesUrl)
	//
	// 	} else {
	//         print("No statuses url")
	//     }
	// }
	
	private func submitPayload(dictionary: [String: AnyObject], toUrl: NSURL, completion: ((Bool) -> Void)? = nil) {
        do {
            print("posting")
            let postData = try NSJSONSerialization.dataWithJSONObject(dictionary, options: NSJSONWritingOptions(rawValue: 0))
			
	        let urlRequest = NSMutableURLRequest(URL: toUrl, cachePolicy: .ReloadIgnoringCacheData, timeoutInterval: 15.0)
        
			urlRequest.addJSONHeaders()
	        urlRequest.addAuthorizationHeader(username, password: token)
        
	        urlRequest.HTTPMethod = "POST"
            urlRequest.HTTPBody = postData
			
            urlSession.dataTaskWithRequest(urlRequest) { (data, response, error) -> Void in
                print("Finished \(error)")
                print(response)
				
                if let httpResponse = response as? NSHTTPURLResponse where 200...299 ~= httpResponse.statusCode {
                    completion?(true)
                    return
                }
				
                if let error = error {
                    print("Error: \(error)")
                }
                completion?(false)
				
			}.resume()
        } catch let error as NSError {
            print("JSON Serialization Failed \(error)")
        }
	}
}

public protocol Endpoint {
	var endpoint: String { get }
	var payload: [String: AnyObject] { get }
}

extension NSMutableURLRequest {
    func addAuthorizationHeader(username: String, password: String) {
        let authAscii =  ("\(username):\(password)" as NSString).dataUsingEncoding(NSASCIIStringEncoding)
        let authValue = "Basic \(authAscii!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding76CharacterLineLength))"
        self.addValue(authValue, forHTTPHeaderField: "Authorization")
    }
	
	func addJSONHeaders() {
        self.addValue("application/json", forHTTPHeaderField: "Content-Type")
        self.addValue("application/json", forHTTPHeaderField: "Accept")
	}
}
