# Git.framework
<p align="center">
<img src="https://raw.githubusercontent.com/way-to-code/git-macOS/master/logo.png" alt="A high-level swift framework to work with git command line in macOS"/>
</p>

Git is a high-level swift framework based on the command line Git utility in macOS.

- [Features](##features)
- [Requirements](##requirements)
- [Installation](##installation)
- [Cloning a remote repository](##cloning-a-remote-repository)
 - [Simple example](###simple-example)
 - [Providing credentials](###providing-credentials)
 - [Receiving the progress ](###receiving-the-progress)

## Features

- Cloning remote repositories (git clone and git fetch);
- Getting the list of references (branches, tags) in repositories;
- Checking out references (git checkout);
- Working with remotes;

## Requirements

- macOS 10.12+
- Xcode 10+
- Swift 4.2+
- Git for Mac 2.15+

## Installation

Before installing this framework, please make sure you're using the correct version of Git in your system. You can check the current version via Terminal app:

```
git --version
$ git version 2.15.1
```

### Carthage

To install Carthage you can use [Homebrew](http://brew.sh/). Use the following command in Terminal app:

```bash
$ brew update
$ brew install carthage
```

To integrate Git.framework into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "way-to-code/git-macOS" ~> 1.1
```

Run `carthage update` to build the framework and drag the built `Git.framework` into your Xcode project.

### Manually

You can install Git.framework manually. Clone the project locally, build and integrate to your project as a framework

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
