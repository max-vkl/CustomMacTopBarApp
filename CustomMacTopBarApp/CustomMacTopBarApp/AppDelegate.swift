//
//  AppDelegate.swift
//  CustomMacTopBarApp
//
//  Created by Max on 09.11.24.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the status item in the menu bar
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem?.button {
            button.title = "Hello" // Text in the menu bar
        }

        // Create the menu
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Say Hello", action: #selector(sayHello), keyEquivalent: "H"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: "Q"))
        statusItem?.menu = menu
    }

    @objc func sayHello() {
        let alert = NSAlert()
        alert.messageText = "Hello from the Menu Bar!"
        alert.runModal()
    }

    @objc func quit() {
        NSApplication.shared.terminate(self)
    }
}
