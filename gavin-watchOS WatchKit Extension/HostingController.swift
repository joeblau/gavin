//
//  HostingController.swift
//  gavin-watchOS WatchKit Extension
//
//  Created by Joe Blau on 7/31/19.
//

import WatchKit
import Foundation
import SwiftUI

class HostingController: WKHostingController<ContentView> {
    override var body: ContentView {
        return ContentView(wrist: WKInterfaceDevice
            .current()
            .wristLocation
            .description)
    }
}
