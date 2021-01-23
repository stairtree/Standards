import Foundation

struct WikipediaIdentifier: Equatable {
    let name: String
    // this looks something like
    // https://upload.wikimedia.org/wikipedia/commons/thumb/9/93/Flag_of_the_Bahamas.svg/23px-Flag_of_the_Bahamas.svg.png
    // and we want to extract the `Flag_of_the_Bahamas.svg` and reduce it to `the_Bahamas`.
    init(svgSrc: String) {
        let imgName = svgSrc.split(separator: "/").dropLast().last! // Flag_of_the_Bahamas.svg
        name = String(imgName.suffix(from: imgName.index(imgName.startIndex, offsetBy: 8)).dropLast(4))
    }
}

// Those are all from in `Utilities`
extension String {
    func removingCharacters(from forbiddenChars: CharacterSet) -> String {
        let passed = self.unicodeScalars.filter { !forbiddenChars.contains($0) }
        return String(String.UnicodeScalarView(passed))
    }

    func replacingCharacters(from forbiddenChars: CharacterSet, with replacement: String) -> String {
        self.unicodeScalars.reduce(into: "") { str, char in
            guard !forbiddenChars.contains(char) else {
                str.append(replacement)
                return
            }
            str.append(Character(char))
        }
    }
    
    func capitalizingFirstLetters() -> String {
        split(separator: " ").map { $0.prefix(1).capitalized + $0.dropFirst() }.joined(separator: " ")
    }
}

let caseAndDiacriticInsensitiveCompare: (String, String) -> Bool = {
    $0.compare($1, options: [.caseInsensitive, .diacriticInsensitive]) == .orderedAscending
}

extension String {
    func toTypeName() -> String {
        self
            .replacingOccurrences(of: "&", with: "And")
            .replacingOccurrences(of: "'s", with: "s")
            .replacingCharacters(from: CharacterSet.letters.inverted, with: " ")
            .capitalizingFirstLetters()
            .removingCharacters(from: CharacterSet.letters.inverted)
    }
}
