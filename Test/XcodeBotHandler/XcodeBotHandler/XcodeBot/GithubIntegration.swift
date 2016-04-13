import GitHubBot
import Foundation

extension GitHub: IntegrationBot {	
	public func handleIntegration(details: FullDetails, completion: (Bool) -> ()) {
        let repository = Repository(user: "bjtitus", name: "Test")
		
		let sha = shaFromDirectory(details.integration.sourceDirectory)
		
		let description = "Something happened"
		
		let statusEndpoint = Status(sha: sha!, state: State(status: details.integration.status), description: description, targetUrl: details.targetUrl, context: "xcs/bot")
		post(repository, endpoint: statusEndpoint) { success in
			completion(success)
		}
	}
}

public extension State {
	init(status: IntegrationStatus) {
	    switch status {
	        case .Unknown: self = .Pending
	        case .TestFailures, .BuildErrors: self = .Failed
	        case .Warnings, .AnalyzerWarnings, .Succeeded: self = .Succeeded
	    }
	}
}

func shell(args: String...) -> String
{
    let task = NSTask()
    task.launchPath = "/usr/bin/env"
    task.arguments = args

    let pipe = NSPipe()
    task.standardOutput = pipe
    task.launch()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output: String = NSString(data: data, encoding: NSUTF8StringEncoding) as! String

    return output
}

func gitSha(directory: String) -> String {
    return shell("git", "-C", directory, "rev-parse", "HEAD").stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
}

func shaFromDirectory(directory: String) -> String? {
	let fileManager = NSFileManager()
	do {
	    print("Running")

        let folderName = try fileManager.contentsOfDirectoryAtPath(directory).first!

        return gitSha(folderName)
	} catch {
		print("Error getting sha")
	}
	return nil
}
