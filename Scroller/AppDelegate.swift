//
//  AppDelegate.swift
//  Scroller
//
//  Created by Ari Fiorino on 6/13/24.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    private var monitor2: Any?

    func applicationDidFinishLaunching(_ notification: Notification) {
        let key: String = kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String
        let options = [key: true]
        let enabled = AXIsProcessTrustedWithOptions(options as CFDictionary)
        if !enabled {
            NSApp.terminate(nil)
        }

        var monitor: Any?
        var lastMousePosition: CGPoint?
        var initialPos: CGPoint?
        var lastDelta: CGPoint?
        self.monitor2 = NSEvent.addGlobalMonitorForEvents(matching: .flagsChanged) { event in
            if let monitor3 = monitor {
                NSEvent.removeMonitor(monitor3)
            }
            monitor = nil
            if event.modifierFlags.contains(.option){
                if initialPos == nil{
                    initialPos = CGEvent(source: nil)!.location
                }
                monitor = NSEvent.addGlobalMonitorForEvents(matching: .mouseMoved) { _ in
                    let point = CGEvent(source: nil)!.location
                    
                    if let lastPosition = lastMousePosition {
                        let mouseDelta = CGPoint(x: lastPosition.x - point.x, y: lastPosition.y - point.y)
                        if mouseDelta == CGPoint(){
                            return
                        }
                        var scroll = true
                        if let lastDelta2 = lastDelta{
                            if mouseDelta == CGPoint(x:-lastDelta2.x,y:-lastDelta2.y){
                                scroll = false
                            }
                        }
                        lastDelta=mouseDelta
                        if scroll{
                            let event = CGEvent(scrollWheelEvent2Source: nil, units: .pixel, wheelCount: 2, wheel1: Int32(-mouseDelta.y), wheel2: Int32(-mouseDelta.x), wheel3: 0)
                            event?.post(tap: CGEventTapLocation.cghidEventTap)
                        }
                        let event2 = CGEvent(mouseEventSource: nil, mouseType: CGEventType.mouseMoved, mouseCursorPosition: initialPos!, mouseButton: CGMouseButton.left)
                        event2?.post(tap: CGEventTapLocation.cgSessionEventTap)
                    }
                    lastMousePosition = point
                }
            }else{
                lastMousePosition = nil
                initialPos = nil
            }
        }
    }

    func applicationWillTerminate(_ notification: Notification) {
        if let monitor2 = monitor2 {
            NSEvent.removeMonitor(monitor2)
        }
    }


}

