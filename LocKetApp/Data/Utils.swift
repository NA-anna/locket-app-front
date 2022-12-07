//
//  Utils.swift
//  miniProject_map
//
//  Created by 나유진 on 2022/10/27.
//

import Foundation


//===========================================================================================
// Date <-> String
//===========================================================================================
extension String {
    func toDate() -> Date? { //"yyyy-MM-dd HH:mm:ss"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
    

}

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        return dateFormatter.string(from: self)
    }
}





/*
extension Encodable {
    var toDictionary : [String: Any]? {
        guard let object = try? JSONEncoder().encode(self) else { return nil }
        guard let dictionary = try? JSONSerialization.jsonObject(with: object, options: []) as? [String:Any] else { return nil }
        return dictionary
    }
}



extension String {
    public func convertToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}

*/

// 화면에 뿌려본 것. 나중에 주석 필요
/*
let jsonData: Data = try! JSONEncoder().encode(market) // data
let jsonString: String = String.init(data: jsonData, encoding: .utf8) ?? "err"
textView.text = jsonString
*/

extension UITextView {
    func setLineAndLetterSpacing(_ text: String){
        let style = NSMutableParagraphStyle()
        // 행간 세팅
        style.lineSpacing = 5
        let attributedString = NSMutableAttributedString(string: text)
        // 자간 세팅
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(0), range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSRange(location: 0, length: attributedString.length))
        self.attributedText = attributedString
    }
}
