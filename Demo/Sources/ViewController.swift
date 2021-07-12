//
//  ViewController.swift
//  GitDemo
//
//  Copyright (c) Max A. Akhmatov
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

// ℹ️ #1
// Please note that App Sandbox is disabled in the entitlements file.
// When App Sandbox is enabled the app can not access anything except own documents.
// However, without App Sandboox apps won't be accepted by Appstore.
// If Appstore is your goal, please do not use Git.framework and consider other alternatives.

import Cocoa

// ℹ️ #2
// Import Git as an ordinary module
import Git

class ViewController: NSViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var urlTextField: NSTextField!
    @IBOutlet private weak var localPathTextField: NSTextField!
    @IBOutlet private weak var cloneButton: NSButton!
    @IBOutlet private weak var progressView: NSProgressIndicator!
    @IBOutlet private weak var progressLabel: NSTextField!
    @IBOutlet private weak var logTextView: NSTextView!
    
    // MARK: - Properties
    private var remoteUrl: URL? {
        return URL(string: urlTextField.stringValue)
    }
    
    private var localPath: String {
        return localPathTextField.stringValue
    }
    
    // ℹ️ #3
    // Define an instance of repository
    private var repository: GitRepository?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    private func setup() {
        cloneButton.isEnabled = false
        progressView.isHidden = true
        progressLabel.isHidden = true
        
        urlTextField.delegate = self
        
        if let desktopPath = NSSearchPathForDirectoriesInDomains(.desktopDirectory,
                                                                 .userDomainMask,
                                                                 true).first {
            localPathTextField.stringValue = desktopPath
        }
        
        if #available(OSX 10.14, *) {
            logTextView.usesAdaptiveColorMappingForDarkAppearance = true
        }
    }
    
    private func clone() {
        guard let remoteUrl = self.remoteUrl, localPath.count > 0 else {
            return
        }
        
        let localPath = self.localPath
        
        // ℹ️ #4
        // Initiate a new instane of repository with a remote URL
        // If you want to track the progress, assign a delegate object.
        repository = GitRepository(from: remoteUrl)
        repository?.delegate = self
        
        showActivity(true)
        
        // ℹ️ #5
        // When working with "heavy" git operations like clone, don't forget to make such operations in background.
        // When an operation is in progress, the calling thread will be blocked until the operation is finished.
        DispatchQueue.global(qos: .background).async { [unowned self] in
            defer {
                DispatchQueue.main.async {
                    showActivity(false)
                }
            }
            
            do {
                // ℹ️ #6
                // When working with clone you may change some options
                let cloneOptions = GitCloneOptions()
                cloneOptions.quiet = false
                cloneOptions.progress = true
                
                try repository?.clone(at: localPath, options: cloneOptions)
                
                // ℹ️ #7
                // An example how to use other methods
                if let references = try repository?.listReferences() {
                    DispatchQueue.main.async {
                        showReferences(references)
                    }
                }
                
                // ℹ️ #8
                // Another example how to get the most recent 5 log records
                let logOptions = GitLogOptions()
                logOptions.limit = 5
                
                if let records = try repository?.listLogRecords(options: logOptions) {
                    DispatchQueue.main.async {
                        showLogRecords(records)
                    }
                }
                
            } catch {
                DispatchQueue.main.async {
                    let alert = NSAlert()
                    alert.messageText = "Clone error"
                    alert.informativeText = error.localizedDescription
                    alert.alertStyle = .warning
                    alert.addButton(withTitle: "OK")
                    alert.runModal()
                }
            }
        }
    }
    
    private func showActivity(_ show: Bool) {
        progressView.isHidden = !show
        progressLabel.isHidden = !show
        urlTextField.isEnabled = !show
        localPathTextField.isEnabled = !show
        cloneButton.isEnabled = !show
        
        if show {
            progressView.startAnimation(nil)
        } else {
            progressView.stopAnimation(nil)
        }
    }
    
    private func showReferences(_ references: GitReferenceList) {
        logTextView.textStorage?.beginEditing()
        appendLog("\nReferences in repository:\n")
        for reference in references.references {
            appendLog(reference.name + "\n")
        }
        logTextView.textStorage?.endEditing()
        logTextView.scrollToEndOfDocument(nil)
    }
    
    private func showLogRecords(_ records: GitLogRecordList) {
        logTextView.textStorage?.beginEditing()
        appendLog("\nLastest commits in repository:\n")
        for record in records.records {
            appendLog("[\(record.shortHash)]: \(record.subject)\n")
        }
        logTextView.textStorage?.endEditing()
        logTextView.scrollToEndOfDocument(nil)
    }
    
    private func appendLog(_ string: String) {
        logTextView.textStorage?.append(.init(string: string))
    }
    
    // MARK: - Actions
    @IBAction private func handleCloneClick(sender: Any) {
        clone()
    }
}

// MARK: - NSTextFieldDelegate
extension ViewController: NSTextFieldDelegate {
    
    func controlTextDidChange(_ obj: Notification) {
        cloneButton.isEnabled = remoteUrl != nil && localPath.count > 0
    }
}

// MARK: - RepositoryDelegate
extension ViewController: RepositoryDelegate {
 
    func repository(_ repository: Repository, didProgressClone progress: String) {
        logTextView.textStorage?.beginEditing()
        appendLog(progress)
        logTextView.textStorage?.endEditing()
        
        logTextView.scrollToEndOfDocument(nil)
    }
}
