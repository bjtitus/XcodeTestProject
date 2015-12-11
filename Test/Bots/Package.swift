import PackageDescription

let package = Package(
	dependencies: [
		.Package(url: "/Users/bjtitus/Documents/Source Code/Personal/XcodeBotServices", versions: Version(0,0,1)..<Version(1,0,0))
	]
)