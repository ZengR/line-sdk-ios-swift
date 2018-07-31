//
//  LoginConfigurationTests.swift
//
//  Copyright (c) 2016-present, LINE Corporation. All rights reserved.
//
//  You are hereby granted a non-exclusive, worldwide, royalty-free license to use,
//  copy and distribute this software in source code or binary form for use
//  in connection with the web services and APIs provided by LINE Corporation.
//
//  As with any software that integrates with the LINE Corporation platform, your use of this software
//  is subject to the LINE Developers Agreement [http://terms2.line.me/LINE_Developers_Agreement].
//  This copyright notice shall be included in all copies or substantial portions of the software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
//  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
//  DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import XCTest
@testable import LineSDK

class LoginConfigurationTests: XCTestCase {

    func testValidCustomizeURL() {
        let config = LoginConfiguration(channelID: "123", universalLinkURL: nil)
        
        let results = [
            "https://sample.com",
            "randomUrl://authorize",
            "\(Constant.thirdPartyAppRetrurnScheme)://somePath/",
            "\(Constant.thirdPartyAppRetrurnScheme)://authorize?hello=world",
            "\(Constant.thirdPartyAppRetrurnScheme)://authorize",
            "\(Constant.thirdPartyAppRetrurnScheme.uppercased())://Authorize"
        ].map { config.isValidCustomizeURL(url: URL(string: $0)!) }

        XCTAssertEqual(results, [
            false, false, false,
            true,  true,  true
        ])
    }
    
    func testValidUniversalLinkURL() {
        let url = URL(string: "https://sample.com/auth/")
        let config = LoginConfiguration(channelID: "123", universalLinkURL: url)
        
        let results = [
            "https://sample.com",
            "https://sample.com/auth/other",
            "https://domain.com/auth",
            "randomUrl://auth",
            
            "https://sample.com/auth",
            "https://sample.com/auth?code=123",
            "https://SAMPLE.com/Auth/?code=123",
            "HTTPS://sample.com/auth",
        ].map { config.isValidUniversalLinkURL(url: URL(string: $0)!) }
        XCTAssertEqual(results, [
            false, false, false, false,
            true,  true,  true,  true
        ])
    }
    
    func testValidSourceApplication() {
        let config = LoginConfiguration(channelID: "123", universalLinkURL: nil)
        let results = [
            "jp.naver.line",
            "com.apple.hello",
            "com.company.app"
        ].map(config.isValidSourceApplication)
        XCTAssertEqual(results, [true, true, false])
    }
}
