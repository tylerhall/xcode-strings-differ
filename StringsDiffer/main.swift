//
//  main.swift
//  StringsDiffer
//
//  Created by Tyler Hall on 1/20/20.
//  Copyright © 2020 Tyler Hall. All rights reserved.
//

import Foundation

func keyArray(_ lines: [String]) -> Set<String> {
    var keys = Set<String>()
    for line in lines {
        let tmp = line.trimmingCharacters(in: .whitespacesAndNewlines)
        if tmp.hasPrefix("\"") {
            let parts = tmp.components(separatedBy: "=")
            let firstHalf = parts.first?.trimmingCharacters(in: .whitespacesAndNewlines)
            if let key = firstHalf?.replacingOccurrences(of: "\"", with: "") {
                keys.insert(key)
            }
        }
    }
    return keys
}

if CommandLine.arguments.count != 3 {
    print("Usage: StringsDiffer TruthFile.strings Translation.strings")
    exit(EXIT_FAILURE)
}

let truth = CommandLine.arguments[1]
let trans = CommandLine.arguments[2]

if !FileManager.default.fileExists(atPath: truth) {
    print("Truth.strings does not exist.")
    exit(EXIT_FAILURE)
}

if !FileManager.default.fileExists(atPath: trans) {
    print("Translation.strings does not exist.")
    exit(EXIT_FAILURE)
}

guard let truthStr = try? String(contentsOfFile: truth) else {
    print("Could not read Truth.strings")
    exit(EXIT_FAILURE)
}
let truthLines = truthStr.components(separatedBy: "\n")
let truthKeys = keyArray(truthLines)

guard let transStr = try? String(contentsOfFile: trans) else {
    print("Could not read Translation.strings")
    exit(EXIT_FAILURE)
}
let transLines = transStr.components(separatedBy: "\n")
let transKeys = keyArray(transLines)

var missingKeys = truthKeys.subtracting(transKeys)
print("Translation.strings is missing \(missingKeys.count) keys")
print("==========================================")
for key in missingKeys {
    print("\(key)")
}

print("\n")

missingKeys = transKeys.subtracting(truthKeys)
print("Truth.strings is missing \(missingKeys.count) keys")
print("==========================================")
for key in missingKeys {
    print("\(key)")
}
