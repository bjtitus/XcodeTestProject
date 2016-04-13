import Foundation

public struct Repository {
	let user: String
	let name: String
	
	var url: String { return "https://api.github.com/repos/\(user)/\(name)" }
	
	public init(user: String, name: String) {
		self.user = user
		self.name = name
	}
}