import Foundation

public struct Status {
	let sha: String
	let state: State
	let description: String?
	let targetUrl: NSURL?
	let context: String?
	
	public init(sha: String, state: State, description: String? = nil, targetUrl: NSURL? = nil, context: String? = nil) {
		self.sha = sha
		self.state = state
		self.description = description
		self.targetUrl = targetUrl
		self.context = context
	}
}

extension Status: Endpoint {
	public var endpoint: String {
		return "statuses/\(sha)"
	}
	
	public var payload: [String: AnyObject] {
        //TODO: Replace target_url with bots page
        //TODO: Replace description with Bot Name b
        var jsonDictionary = ["state": state.rawValue]
		
		if let targetUrl = targetUrl {
			jsonDictionary["target_url"] = targetUrl.absoluteString
		}
		
		if let description = description {
			jsonDictionary["description"] = description
		}
		
		if let context = context {
			jsonDictionary["context"] = context
		}
    
        print(jsonDictionary)
		return jsonDictionary
	}
}

public enum State: String {
    case Pending = "pending"
    case Failed = "failure"
    case Succeeded = "success"
    case Error = "error"
    
    // init(intStatus: IntegrationStatus) {
    //     switch intStatus {
    //         case .Unknown: self = .Pending
    //         case .TestFailures, .BuildErrors: self = .Failed
    //         case .Warnings, .AnalyzerWarnings, .Succeeded: self = .Succeeded
    //     }
    // }
}
