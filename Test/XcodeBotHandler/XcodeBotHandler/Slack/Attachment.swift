import Foundation

public struct Attachment {
    let fallback: String
    let color: ColorValue?
    let pretext: String?
    let author: Author?
    let text: String
    let title: Title?
    let fields: [Field]?
    let imageUrl: NSURL?
    let thumbUrl: NSURL?
	
	public init(fallback: String, color: ColorValue? = nil, pretext: String? = nil, author: Author? = nil, text: String, title: Title? = nil, fields: [Field]? = nil, imageUrl: NSURL? = nil, thumbUrl: NSURL? = nil) {
		self.fallback = fallback
		self.color = color
		self.pretext = pretext
		self.author = author
	    self.text = text
	    self.title = title
	    self.fields = fields
	    self.imageUrl = imageUrl
	    self.thumbUrl = thumbUrl
	}
}

public enum ColorValue: CustomStringConvertible {
    case Good
    case Warning
    case Danger
    case Hex(Int)
    
    public var description: String {
        switch self {
        case .Good:
            return "good"
        case .Warning:
            return "warning"
        case .Danger:
            return "danger"
        case .Hex(let hexValue):
            return String(hexValue, radix: 16, uppercase: true)
        }
    }
}

public struct Author {
    let name: String?
    let link: NSURL?
    let icon: NSURL?
	
	public init(name: String?, link: NSURL? = nil, icon: NSURL? = nil) {
		self.name = name
		self.link = link
		self.icon = icon
	}
}

public struct Field {
    let title: String
    let value: String
    let short: Bool
	
	public init(title: String, value: String, short: Bool? = nil) {
		self.title = title
		self.value = value
		if let short = short {
			self.short = short
		} else {
			self.short = value.characters.count < 100
		}
	}
}

public enum Title {
    case Text(String)
    case Linked(String, NSURL)
}
