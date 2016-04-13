import SlackBot

extension Slack: IntegrationBot {
	
	public func handleIntegration(details: FullDetails, completion: (Bool) -> ()) {
		
		let fallback = fallbackForStatus(details.integration.status) ?? "Unknown"
		let title = Title.Linked(fallback, details.targetUrl)
		let text = fallback
		let color = colorForStatus(details.integration.status)
		
		print("Slack integration")
		
		let postItem = [
			Attachment(fallback: fallback,
						color: color,
						text: text,
						title: title
			)
		]

		self.post(attachments: postItem) { success in
			print("Finished posting slack integration")
			completion(success)
		}
	}
	
	private func fallbackForStatus(status: IntegrationStatus) -> String? {
		switch status {
			case .BuildErrors: return "Build failed"
			case .TestFailures: return "Tests failed"
			case .Succeeded: return "Build succeeded"
			default: return nil
		}
	}
	
	private func colorForStatus(status: IntegrationStatus) -> ColorValue? {
		switch status {
			case .BuildErrors: return ColorValue.Good
			case .TestFailures: return ColorValue.Warning
			case .Succeeded: return ColorValue.Danger
			default: return nil
		}
	}
}