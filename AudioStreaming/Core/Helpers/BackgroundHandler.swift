#if os(OSX)
import Foundation
#else
import UIKit
#endif

actor BackgroundHandler {

    // MARK: - Public helper object
    public final class BackgroundTask {
        private weak var handler: BackgroundHandler?
        private let id: UIBackgroundTaskIdentifier

        fileprivate init(handler: BackgroundHandler, id: UIBackgroundTaskIdentifier) {
            self.handler = handler
            self.id      = id
        }

        public func end() {
            Task { await handler?.endBackgroundTask(id: id) }
        }

        deinit { end() }
    }

    // MARK: - Private state
    #if !os(OSX)
    private let application: UIApplication = .shared
    private var activeIDs: Set<UIBackgroundTaskIdentifier> = []
    #endif

    // MARK: - API
    @discardableResult
    nonisolated
    func begin(reason: StaticString = "unspecified") -> BackgroundTask? {
        #if os(OSX)
        return nil
        #else
        let remaining = application.backgroundTimeRemaining
        let id = application.beginBackgroundTask(withName: "\(reason)") { [weak self] in
            Task { await self?.endBackgroundTask(id: id, expired: true) }
        }

        guard id != .invalid else { return nil }

        // Register the ID **on the actor**.
        Task { await self.register(id: id, remaining: remaining, reason: reason) }

        return BackgroundTask(handler: self, id: id)
        #endif
    }

    fileprivate func endBackgroundTask(id: UIBackgroundTaskIdentifier,
                                       expired: Bool = false) {
        #if !os(OSX)
        guard activeIDs.remove(id) != nil else { return }

        let remaining = application.backgroundTimeRemaining
        if expired {
            Logger.debug("🟠 Expired task %d – remaining: %.1f s",
                         category: .backgroundHandler,
                         args: id.rawValue, remaining)
        } else {
            Logger.debug("🟢 End   task %d – remaining: %.1f s (%d left)",
                         category: .backgroundHandler,
                         args: id.rawValue, remaining, activeIDs.count)
        }

        application.endBackgroundTask(id)
        #if DEBUG
        assert(!activeIDs.contains(id), "Background task \(id) leaked!")
        #endif
        #endif
    }

    // MARK: - Actor-isolated helper
    private func register(id: UIBackgroundTaskIdentifier,
                          remaining: TimeInterval,
                          reason: StaticString) {
        activeIDs.insert(id)
        Logger.debug("🔵 Begin [%{public}s] – remaining: %.1f s (%d active)",
                     category: .backgroundHandler,
                     args: "\(reason)", remaining, activeIDs.count)
    }

    deinit {
        #if !os(OSX)
        for id in activeIDs { application.endBackgroundTask(id) }
        #endif
    }
}
