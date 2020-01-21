//
//  main.swift
//  StringsDiffer
//
//  Created by Tyler Hall on 1/20/20.
//  Copyright © 2020 Tyler Hall. All rights reserved.
//

import Foundation

func keyFromStringsLine(_ line: String) -> String? {
    let tmp = line.trimmingCharacters(in: .whitespacesAndNewlines)
    if tmp.hasPrefix("\"") {
        let parts = tmp.components(separatedBy: "=")
        let firstHalf = parts.first?.trimmingCharacters(in: .whitespacesAndNewlines)
        if let key = firstHalf?.replacingOccurrences(of: "\"", with: "") {
            return key
        }
    }
    return nil
}

if CommandLine.arguments.count != 3 {
    print("Usage: StringsDiffer file1.strings file2.strings")
    exit(EXIT_FAILURE)
}

let filename1 = CommandLine.arguments[1]
let filename2 = CommandLine.arguments[2]

if !FileManager.default.fileExists(atPath: filename1) {
    print("\(filename1) does not exist.")
    exit(EXIT_FAILURE)
}

if !FileManager.default.fileExists(atPath: filename2) {
    print("\(filename2) does not exist.")
    exit(EXIT_FAILURE)
}

guard let file1Contents = try? String(contentsOfFile: filename1) else {
    print("Could not read \(filename1)")
    exit(EXIT_FAILURE)
}

guard let file2Contents = try? String(contentsOfFile: filename2) else {
    print("Could not read \(filename2)")
    exit(EXIT_FAILURE)
}

print("================== COMPARING =============")
print(filename1)
print("vs")
print(filename2)
print("==========================================")
print("\n")

let file1Lines = file1Contents.components(separatedBy: "\n")
var file1Keys = Set<String>()
var file1Dict = [String: String]()
for line in file1Lines {
    if let key = keyFromStringsLine(line) {
        file1Keys.insert(key)
        file1Dict[key] = line
    }
}

let file2Lines = file2Contents.components(separatedBy: "\n")
var file2Keys = Set<String>()
var file2Dict = [String: String]()
for line in file2Lines {
    if let key = keyFromStringsLine(line) {
        file2Keys.insert(key)
        file2Dict[key] = line
    }
}

let file2MissingKeys = file1Keys.subtracting(file2Keys)
let file1MissingKeys = file2Keys.subtracting(file1Keys)

print("\(filename1)")
print("MISSING \(file1MissingKeys.count) KEYS")
print("==========================================")
for key in file1MissingKeys {
    print(file2Dict[key] ?? key)
}

print("\n")

print("\(filename2)")
print("MISSING \(file2MissingKeys.count) KEYS")
print("==========================================")
for key in file2MissingKeys {
    print(file1Dict[key] ?? key)
}
