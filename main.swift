import Cocoa

// Menu bar stopwatch. Left click: start/pause. Double click: reset. Right click: menu.
class AppDelegate: NSObject, NSApplicationDelegate {
    let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    var timer: Timer?
    var accumulated: TimeInterval = 0
    var startedAt: Date?

    var elapsed: TimeInterval {
        accumulated + (startedAt.map { Date().timeIntervalSince($0) } ?? 0)
    }

    func applicationDidFinishLaunching(_ n: Notification) {
        let button = item.button!
        button.font = NSFont.monospacedDigitSystemFont(ofSize: NSFont.systemFontSize, weight: .regular)
        button.target = self
        button.action = #selector(clicked)
        button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        render()
    }

    @objc func clicked() {
        let event = NSApp.currentEvent
        if event?.type == .rightMouseUp || event?.modifierFlags.contains(.control) == true {
            showMenu()
        } else if event?.clickCount == 2 {
            // The first click of the pair already toggled; undo that, then zero.
            toggle()
            reset()
        } else {
            toggle()
        }
    }

    @objc func toggle() {
        if let s = startedAt {
            accumulated += Date().timeIntervalSince(s)
            startedAt = nil
            timer?.invalidate()
            timer = nil
        } else {
            startedAt = Date()
            let t = Timer(timeInterval: 0.25, repeats: true) { [weak self] _ in self?.render() }
            RunLoop.main.add(t, forMode: .common)
            timer = t
        }
        render()
    }

    @objc func reset() {
        accumulated = 0
        if startedAt != nil { startedAt = Date() }
        render()
    }

    func showMenu() {
        let menu = NSMenu()
        menu.addItem(withTitle: startedAt == nil ? "Start" : "Pause", action: #selector(toggle), keyEquivalent: "").target = self
        menu.addItem(withTitle: "Reset", action: #selector(reset), keyEquivalent: "").target = self
        menu.addItem(.separator())
        menu.addItem(withTitle: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        item.menu = menu
        item.button?.performClick(nil)
        item.menu = nil
    }

    func render() {
        let s = Int(elapsed)
        let text = s >= 3600
            ? String(format: "%d:%02d:%02d", s / 3600, s / 60 % 60, s % 60)
            : String(format: "%d:%02d", s / 60, s % 60)
        // Shows the action a click performs: play while paused, pause while running.
        let symbol = startedAt == nil ? "play.fill" : "pause.fill"
        item.button?.image = NSImage(systemSymbolName: symbol, accessibilityDescription: "Stopwatch")
        item.button?.imagePosition = .imageLeading
        item.button?.title = " " + text
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.setActivationPolicy(.accessory)
app.run()
