import Foundation

public class Slack {
    public let endpointURL: NSURL
    public var username: String?
        
    public init(url: NSURL) {
        self.endpointURL = url
    }
    
    public func post(attachments inAttachments: [Attachment], completion: ((Bool) -> ())? = nil) {
        var dictionary: [String: AnyObject] = [:]
        
        var attachments: [[String: AnyObject]] = []
        
        for inAttachment in inAttachments {
            var attachment: [String: AnyObject] = [:]
            
            attachment["fallback"] = inAttachment.fallback
            
            if let color = inAttachment.color {
                attachment["color"] = color.description
            }
            
            if let pretext = inAttachment.pretext {
                attachment["pretext"] = pretext
            }
            
            if let author = inAttachment.author {
                if let name = author.name {
                    attachment["author_name"] = name
                }

                if let link = author.link {
                    attachment["author_link"] = link.absoluteString
                }
                
                if let icon = author.icon {
                    attachment["author_icon"] = icon.absoluteString
                }
            }
            
            if let title = inAttachment.title {
                switch title {
                case .Text(let titleText):
                    attachment["title"] = titleText
                case .Linked(let titleText, let titleLink):
                    attachment["title"] = titleText
                    attachment["title_link"] = titleLink.absoluteString
                }
            }

            attachment["text"] = inAttachment.text
            
            if let inFields = inAttachment.fields where !inFields.isEmpty {
                var fields: [[String: AnyObject]] = []
                for inField in inFields {
                    let field: [String: AnyObject] = ["title": inField.title, "value": inField.value, "short": inField.short]
                    fields.append(field)
                }
                attachment["fields"] = fields
            }
            
            if let imageUrl = inAttachment.imageUrl {
                attachment["image_url"] = imageUrl.absoluteString
            }
            
            if let thumbUrl = inAttachment.thumbUrl {
                attachment["thumb_url"] = thumbUrl.absoluteString
            }
            
            attachments.append(attachment)
        }
        
        dictionary["attachments"] = attachments
        
		print("Posting")
        submitPayload(dictionary, completion: completion)
    }
    
    public func post(text: String, iconUrl: NSURL? = nil, iconEmoji: String? = nil, completion: ((Bool) -> ())? = nil) {
        var dictionary: [String: AnyObject] = [:]
        
        if let username = username {
            dictionary["username"] = username
        }
        
        dictionary["text"] = text
        
        if let iconUrl = iconUrl {
            dictionary["icon_url"] = iconUrl.absoluteString
        }
        
        if let iconEmoji = iconEmoji {
            dictionary["icon_emoji"] = iconEmoji
        }
		
        submitPayload(dictionary, completion: completion)
    }
	
    private lazy var session: NSURLSession = NSURLSession.sharedSession()
    
	/*
	*	A generic method to submit payloads to Slack
	*   Submits a JSON paylod to the webhook URL
	* 	- dictionary: A dictionary which can contain text, icon_url, and icon_emoji, or a series of attachments
	*	- completion: A completion block with a success parameter to determine the succes of the submission
	*/
    private func submitPayload(dictionary: [String: AnyObject], completion: ((Bool) -> ())?) {
        do {
            let payload = try NSJSONSerialization.dataWithJSONObject(dictionary, options: NSJSONWritingOptions())
            let request = NSMutableURLRequest(URL: endpointURL)
            
            request.HTTPMethod = "POST"
            request.HTTPBody = payload
            
            session.dataTaskWithRequest(request) { data, response, error in
                
                if let httpResponse = response as? NSHTTPURLResponse where httpResponse.statusCode == 200 {
                    completion?(true)
                    return
                }
                
                if let error = error {
                    print("Error: \(error)")
                }
                completion?(false)
            }.resume()
        } catch {
            
        }
    }
}
