Git is a high-level framework based on the command line git utility in macOS written in swift.

- [Requirements](#requirements)
- [Cloning a remote repository](#cloning-a-remote-repository)
- [Simple example](##simple-example)
- [Providing credentials](##providing-credentials)

## Requirements

- macOS 10.10+
- Xcode 10+
- Swift 4.2+

## Cloning a remote repository

### Simple example

To clone a remote repository you need to create an object **GitRepository**

```swift
let repository = GitRepository(from: URL(string: "https://github.com/github/hub.git"))
```
Next, just call the clone method

```swift
try? repository.clone(at: "/Users/youruser/hub")
```

### Providing credentials

You can specify credentials for repository with a help of **GitCredentialsProvider**. If no credentials are specified, credentials from the global macOS system git config are used by default.

```swift
let credentialsProvider = GitCredentialsProvider(username:"user", password:"****")
let repository = GitRepository(from: URL(string: "https://github.com/github/hub.git"), using: credentialsProvider)
```

### Receiving the progress 

You may keep track of the clone operation progress, by setting a delegate object on repository

```swift
let progressTracker = MyCustomObject()

let repository: GitRepository
repository.delegate = progressTracker

// implement RepositoryDelegate protocol in order to track the events
extension MyCustomObject: RepositoryDelegate {
    func repository(_ repository: Repository, didProgressClone progress: String) {
    }
}
```
