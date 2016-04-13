import Foundation
import SlackBot
import GitHubBot

public class XcodeBotService {
	let integrationBots: [(IntegrationBot, [IntegrationStatus])]
	
	public init(integrationBots: [(IntegrationBot, [IntegrationStatus])]) {
		self.integrationBots = integrationBots
	}
	
	public func runServices(environment: [String: String], completion: ((Bool) -> Void)? = nil) {
		let botDetails = FullDetails(environment: environment)
		
		var integrationsComplete = 0
		
		let bots = integrationBots.filter(){ (bot, statuses) in
			return statuses.contains(botDetails.integration.status)
		}
		
		var totalIntegrations = bots.count
		
		func updateIntegrationCount() {
			integrationsComplete = integrationsComplete + 1
			
			if integrationsComplete >= totalIntegrations {
				print("Integrations complete")
				completion?(true)
			}
		}
				
		if bots.count == 0 {
			completion?(true)
			return
		}
		for (integrationBot, _) in bots {
			integrationBot.handleIntegration(botDetails) { success in
				updateIntegrationCount()
			}
		}		
	}
}

struct IntegrationDetails {
	let tinyID: String
	let sourceDirectory: String
	let status: IntegrationStatus
	
	init(environment: [String: String]) {
		if environment["XCS_INTEGRATION_RESULT"] == nil {
			print("Missing Integration Result")
		}
        self.status = IntegrationStatus(rawValue: environment["XCS_INTEGRATION_RESULT"]!)!
		if environment["XCS_SOURCE_DIR"] == nil {
			print("Missing Source Dir")
		}
		self.sourceDirectory = environment["XCS_SOURCE_DIR"]!
		if environment["XCS_INTEGRATION_TINY_ID"] == nil {
			print("Missing Integration Tiny ID")
		}
		self.tinyID = environment["XCS_INTEGRATION_TINY_ID"]!
	}
}

public struct BotDetails {
	let tinyID: String
	
	init(environment: [String: String]) {
		if environment["XCS_BOT_TINY_ID"] == nil {
			print("Missing Bot Tiny ID")
		}
		self.tinyID = environment["XCS_BOT_TINY_ID"]!
	}
}

public struct ServerDetails {
	let host: String
	
	init(environment: [String: String]) {
		if environment["XC_HOST"] == nil {
			print("Missing Xcode Host")
		}
		self.host = environment["XC_HOST"]!
	}
}

public struct FullDetails {
	let integration: IntegrationDetails
	let bot: BotDetails
	let server: ServerDetails
	
	init(environment: [String: String]) {
		self.integration = IntegrationDetails(environment: environment)
		self.bot = BotDetails(environment: environment)
		self.server = ServerDetails(environment: environment)
	}
}

extension FullDetails {
	var targetUrl: NSURL {
		return NSURL(string: "https://\(server.host)/xcode/bots/\(bot.tinyID)/latest/\(integration.tinyID)")!
	}
}

public protocol IntegrationBot {
	func handleIntegration(details: FullDetails, completion: (Bool) -> ())
}

public enum IntegrationStatus: String {
    case Unknown = "unknown"
    case BuildErrors = "build-errors"
    case Warnings = "warnings"
    case AnalyzerWarnings = "analyzer-warnings"
    case TestFailures = "test-failures"
    case Succeeded = "succeeded"
	
	public static var allStatuses: [IntegrationStatus] {
		return [.Unknown, .BuildErrors, .Warnings, .AnalyzerWarnings, .TestFailures, .Succeeded]
	}
}

// let slackClient = Slack(url: NSURL(string: "https://hooks.slack.com/services/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")!)
//
// // let postItem = "Test Post"
//
// var callCount = 0
//
// func operationCompleted() {
// 	callCount--
// 	if callCount <= 0 {
// 		exit(0)
// 	}
// }
//
// let postItem = [
// 	Attachment(fallback: "Fallback text",
// 				color: ColorValue.Good,
// 				text: "Something succeeded",
// 				title: Title.Text("Hello")
// 	),
// 	Attachment(fallback: "Some fallback",
// 				color: ColorValue.Warning,
// 				text: "Something warned",
// 				title: Title.Text("Hey"),
// 				fields: [Field(title: "Some field", value: "Blah"), Field(title: "Another field", value: "Blah")]
// 	)
// ]
//
// slackClient.post(attachments: postItem) { success in
// 	// exit(success ? 0 : 1)
// 	operationCompleted()
// }
// callCount++
//
// let githubClient = GitHub(username: "bjtitus", token: "beb66eb51f89b1880d9e6b1bc1482ca335a1a04f")
// githubClient.post(Repository(user: "bjtitus", name: "XcodeTestProject"), endpoint:
// 					Status(sha: "91f7486046e4dd931c037a141ba9aaf7f6091f99", state: State.Pending, description: "Posting from Swift", targetUrl: NSURL(string: "http://google.com")!, context: "swift/test")) { success in
// 						operationCompleted()
// 						// exit(success ? 0 : 1)
// 					}
// callCount++
//
// dispatch_main()