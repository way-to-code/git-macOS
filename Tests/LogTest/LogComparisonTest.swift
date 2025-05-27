//
//  LogComparisonTest.swift
//  Git-macOS
//
//  Copyright (c) Max A. Akhmatov
//
//  MIT License
//  For full license text, see LICENSE file in the repository root. 

import XCTest
import Git

class LogComparisonTest: XCTestCase, RepositoryTest {

    var repositoryBundleName: String {
        return "LogComparisonRepository.bundle"
    }
    
    private lazy var repository = createRepository()!
    
    private var branchName = "comparison"
    private var masterName = "master"
    
    func testDefaultComparisonOptions() {
        compareDefaultOptions(in: repository)
    }
    
    func testLocalMasterLocalBranch() {
        compareLocalMasterWithComparison(in: repository)
    }
    
    func testLocalBranchLocalMaster() {
        compareLocalComparisonWithMaster(in: repository)
    }
    
    func testRemoteMasterRemoteBranch() {
        compareRemoteMasterWithRemoteComparison(in: repository)
    }
    
    func testRemoteBranchRemoteMaster() {
        compareRemoteComparisonWithRemoteMaster(in: repository)
    }
    
    func testLocalBranchRemoteMaster() {
        compareLocalBranchWithRemoteMaster(in: repository)
    }
    
    func testLocalMasterRemoteBranch() {
        compareLocalMasterWithRemoteBranch(in: repository)
    }
    
    private func compareLocalMasterWithComparison(in repository: GitRepository) {
        let options = GitLogCompareOptions(lhsReference: .init(referenceName: masterName, direction: .local),
                                           rhsReference: .init(referenceName: branchName, direction: .local))
        
        guard let commits = try? repository.retrieveLogRecordsComparison(options: options) else {
            XCTFail("Unable to retrive log comparison in \(repositoryBundleName)")
            return
        }
        
        XCTAssert(commits.records.count == 2, "Failed to compare local master branch with comparison branch")
        guard commits.records.count > 0 else { return }
        
        XCTAssert(commits.records[0].hash == "b04007434ce6c6b42b1a9f8a9162e329c4796d85")
        XCTAssert(commits.records[1].hash == "31e24c018b643e3da8c1f8513596da28ab88e342")
    }
    
    private func compareLocalComparisonWithMaster(in repository: GitRepository) {
        let options = GitLogCompareOptions(lhsReference: .init(referenceName: branchName, direction: .local),
                                           rhsReference: .init(referenceName: masterName, direction: .local))
        
        guard let commits = try? repository.retrieveLogRecordsComparison(options: options) else {
            XCTFail("Unable to retrive log comparison in \(repositoryBundleName)")
            return
        }
        
        XCTAssert(commits.records.count == 2, "Failed to compare local master branch with comparison branch")
        guard commits.records.count > 0 else { return }
        
        XCTAssert(commits.records[0].hash == "dd700a2e7514a0ff65faf0e347f36e3a99b8d138")
        XCTAssert(commits.records[1].hash == "ba6f6f1cedb456aa4cfe4e83a79e8c83cd922c38")
    }
    
    private func compareDefaultOptions(in repository: GitRepository) {
        guard let commits = try? repository.retrieveLogRecordsComparison(options: .default) else {
            XCTFail("Unable to retrive log comparison in \(repositoryBundleName)")
            return
        }
        
        XCTAssert(commits.records.count == 0, "Failed to compare local master branch with comparison branch")
    }
    
    private func compareRemoteMasterWithRemoteComparison(in repository: GitRepository) {
        guard let remote = try? repository.listRemotes().remotes.first else {
            XCTFail("Unable to retrive remote information in \(repositoryBundleName)")
            return
        }
        let options = GitLogCompareOptions(lhsReference: .init(referenceName: masterName, direction: .remote(remote: remote)),
                                           rhsReference: .init(referenceName: branchName, direction: .remote(remote: remote)))
        
        guard let commits = try? repository.retrieveLogRecordsComparison(options: options) else {
            XCTFail("Unable to retrive log comparison in \(repositoryBundleName)")
            return
        }
        
        XCTAssert(commits.records.count == 2, "Failed to compare local master branch with comparison branch")
        guard commits.records.count > 0 else { return }
        
        XCTAssert(commits.records[0].hash == "b04007434ce6c6b42b1a9f8a9162e329c4796d85")
        XCTAssert(commits.records[0].refNames == "local_remote/comparison, comparison")
        XCTAssert(commits.records[1].hash == "31e24c018b643e3da8c1f8513596da28ab88e342")
    }

    private func compareRemoteComparisonWithRemoteMaster(in repository: GitRepository) {
        guard let remote = try? repository.listRemotes().remotes.first else {
            XCTFail("Unable to retrive remote information in \(repositoryBundleName)")
            return
        }
        let options = GitLogCompareOptions(lhsReference: .init(referenceName: branchName, direction: .remote(remote: remote)),
                                           rhsReference: .init(referenceName: masterName, direction: .remote(remote: remote)))
        
        guard let commits = try? repository.retrieveLogRecordsComparison(options: options) else {
            XCTFail("Unable to retrive log comparison in \(repositoryBundleName)")
            return
        }
        
        XCTAssert(commits.records.count == 2, "Failed to compare local master branch with comparison branch")
        guard commits.records.count > 0 else { return }
        
        XCTAssert(commits.records[0].hash == "dd700a2e7514a0ff65faf0e347f36e3a99b8d138")
        XCTAssert(commits.records[0].refNames == "HEAD -> master, local_remote/master")
        XCTAssert(commits.records[1].hash == "ba6f6f1cedb456aa4cfe4e83a79e8c83cd922c38")
    }
    
    private func compareLocalBranchWithRemoteMaster(in repository: GitRepository) {
        guard let remote = try? repository.listRemotes().remotes.first else {
            XCTFail("Unable to retrive remote information in \(repositoryBundleName)")
            return
        }
        let options = GitLogCompareOptions(lhsReference: .init(referenceName: branchName, direction: .local),
                                           rhsReference: .init(referenceName: masterName, direction: .remote(remote: remote)))
        
        guard let commits = try? repository.retrieveLogRecordsComparison(options: options) else {
            XCTFail("Unable to retrive log comparison in \(repositoryBundleName)")
            return
        }
        
        XCTAssert(commits.records.count == 2, "Failed to compare local master branch with comparison branch")
        guard commits.records.count > 0 else { return }
        
        XCTAssert(commits.records[0].hash == "dd700a2e7514a0ff65faf0e347f36e3a99b8d138")
        XCTAssert(commits.records[0].refNames == "HEAD -> master, local_remote/master")
        XCTAssert(commits.records[1].hash == "ba6f6f1cedb456aa4cfe4e83a79e8c83cd922c38")
    }
    
    private func compareLocalMasterWithRemoteBranch(in repository: GitRepository) {
        guard let remote = try? repository.listRemotes().remotes.first else {
            XCTFail("Unable to retrive remote information in \(repositoryBundleName)")
            return
        }
        let options = GitLogCompareOptions(lhsReference: .init(referenceName: masterName, direction: .local),
                                           rhsReference: .init(referenceName: branchName, direction: .remote(remote: remote)))
        
        guard let commits = try? repository.retrieveLogRecordsComparison(options: options) else {
            XCTFail("Unable to retrive log comparison in \(repositoryBundleName)")
            return
        }
        
        XCTAssert(commits.records.count == 2, "Failed to compare local master branch with comparison branch")
        guard commits.records.count > 0 else { return }
        
        XCTAssert(commits.records[0].hash == "b04007434ce6c6b42b1a9f8a9162e329c4796d85")
        XCTAssert(commits.records[0].refNames == "local_remote/comparison, comparison")
        XCTAssert(commits.records[1].hash == "31e24c018b643e3da8c1f8513596da28ab88e342")
    }
}
