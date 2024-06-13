//
//  AppDelegate.swift
//  Scroller
//
//  Created by Ari Fiorino on 6/13/24.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
  private var flagsMonitor: Any?
  let SCROLL_SPEED = 1.0; // Change to be any speed you want!
  let SCROLL_FLAG = NSEvent.ModifierFlags.option; // Change to be any key you want!
  
  func applicationDidFinishLaunching(_ notification: Notification) {
    let key: String = kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String
    let options = [key: true]
    let enabled = AXIsProcessTrustedWithOptions(options as CFDictionary)
    if !enabled {
      NSApp.terminate(nil)
    }
    
    var mouseMonitor: Any?
    var initialPos: CGPoint?
    var lastPos: CGPoint?
    var lastDelta: CGPoint?
    flagsMonitor = NSEvent.addGlobalMonitorForEvents(matching: .flagsChanged) { event in
      if let mouseMonitor = mouseMonitor {
        NSEvent.removeMonitor(mouseMonitor)
      }
      mouseMonitor = nil
      if event.modifierFlags.contains(self.SCROLL_FLAG){
        initialPos = CGEvent(source: nil)!.location
        mouseMonitor = NSEvent.addGlobalMonitorForEvents(matching: .mouseMoved) { _ in
          let pos = CGEvent(source: nil)!.location
          if let lastPos = lastPos {
            let delta = CGPoint(x: lastPos.x - pos.x, y: lastPos.y - pos.y)
            if delta == CGPoint(){
              return
            }
            var scroll = true
            if let lastDelta = lastDelta{
              if delta == CGPoint(x:-lastDelta.x,y:-lastDelta.y){
                scroll = false
              }
            }
            if scroll{
              let scrollEvent = CGEvent(scrollWheelEvent2Source: nil, units: .pixel, wheelCount: 2, wheel1: Int32(-delta.y * self.SCROLL_SPEED), wheel2: Int32(-delta.x * self.SCROLL_SPEED), wheel3: 0)
              scrollEvent?.post(tap: CGEventTapLocation.cghidEventTap)
            }
            let mouseEvent = CGEvent(mouseEventSource: nil, mouseType: CGEventType.mouseMoved, mouseCursorPosition: initialPos!, mouseButton: CGMouseButton.left)
            mouseEvent?.post(tap: CGEventTapLocation.cghidEventTap)
            lastDelta=delta
          }
          lastPos = pos
        }
      }else{
        initialPos = nil
        lastPos = nil
      }
    }
  }
  
  func applicationWillTerminate(_ notification: Notification) {
    if let flagsMonitor = flagsMonitor {
      NSEvent.removeMonitor(flagsMonitor)
    }
  }
}
