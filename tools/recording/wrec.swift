// wrec <windowID> <out.mov> [scale]  — records one window (even if covered) until /tmp/srtest/rec/stop exists.
import Foundation
import ScreenCaptureKit
import AVFoundation
import CoreMedia
import AppKit

final class Rec: NSObject, SCStreamOutput, SCStreamDelegate {
    let writer: AVAssetWriter
    let input: AVAssetWriterInput
    var started = false
    var frames = 0
    init(url: URL, w: Int, h: Int) throws {
        try? FileManager.default.removeItem(at: url)
        writer = try AVAssetWriter(outputURL: url, fileType: .mov)
        input = AVAssetWriterInput(mediaType: .video, outputSettings: [
            AVVideoCodecKey: AVVideoCodecType.hevc, AVVideoWidthKey: w, AVVideoHeightKey: h,
            AVVideoCompressionPropertiesKey: [AVVideoAverageBitRateKey: 60_000_000, AVVideoExpectedSourceFrameRateKey: 30]])
        input.expectsMediaDataInRealTime = true
        writer.add(input)
    }
    func stream(_ s: SCStream, didOutputSampleBuffer sb: CMSampleBuffer, of type: SCStreamOutputType) {
        guard type == .screen, sb.isValid else { return }
        guard let att = CMSampleBufferGetSampleAttachmentsArray(sb, createIfNecessary: false) as? [[SCStreamFrameInfo: Any]],
              let raw = att.first?[.status] as? Int, SCFrameStatus(rawValue: raw) == .complete else { return }
        if !started { writer.startWriting(); writer.startSession(atSourceTime: sb.presentationTimeStamp); started = true }
        if input.isReadyForMoreMediaData { input.append(sb); frames += 1 }
    }
    func stream(_ s: SCStream, didStopWithError e: Error) { print("stopped:", e); exit(1) }
}

_ = NSApplication.shared
let a = CommandLine.arguments
let wid = CGWindowID(a[1])!
let out = URL(fileURLWithPath: a[2])
let scale = a.count > 3 ? Double(a[3])! : 2
let stopFile = "/tmp/srtest/rec/stop"
try? FileManager.default.removeItem(atPath: stopFile)
Task {
    do {
        let content = try await SCShareableContent.excludingDesktopWindows(false, onScreenWindowsOnly: false)
        guard let win = content.windows.first(where: { $0.windowID == wid }) else { print("no window"); exit(1) }
        let w = Int(win.frame.width * scale) & ~1, h = Int(win.frame.height * scale) & ~1
        let cfg = SCStreamConfiguration()
        cfg.width = w; cfg.height = h
        cfg.minimumFrameInterval = CMTime(value: 1, timescale: 30)
        cfg.showsCursor = false
        cfg.pixelFormat = kCVPixelFormatType_32BGRA
        cfg.ignoreShadowsSingleWindow = true
        cfg.queueDepth = 8
        let rec = try Rec(url: out, w: w, h: h)
        let stream = SCStream(filter: SCContentFilter(desktopIndependentWindow: win), configuration: cfg, delegate: rec)
        try stream.addStreamOutput(rec, type: .screen, sampleHandlerQueue: DispatchQueue(label: "rec"))
        try await stream.startCapture()
        print("recording \(w)x\(h)"); fflush(stdout)
        while !FileManager.default.fileExists(atPath: stopFile) { try await Task.sleep(nanoseconds: 100_000_000) }
        try await stream.stopCapture()
        rec.input.markAsFinished()
        await rec.writer.finishWriting()
        print("done frames=\(rec.frames) status=\(rec.writer.status.rawValue) \(rec.writer.error as Any)")
        exit(0)
    } catch { print("error:", error); exit(1) }
}
RunLoop.main.run()
