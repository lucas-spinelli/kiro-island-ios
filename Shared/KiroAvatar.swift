import SwiftUI

/// One vector drawing. No frame clock, bitmap sheets, blur or offscreen rendering.
struct KiroAvatar: View {
    var mood: KiroMood
    var gesture: Int = 0
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.isLuminanceReduced) private var dimmed

    private var angle: Double {
        guard !reduceMotion && !dimmed else { return 0 }
        return Double(gesture) * (mood == .music ? 8 : 5)
    }

    var body: some View {
        Canvas { context, size in
            let scale = min(size.width / 430, size.height / 315)
            context.translateBy(x: (size.width - 430 * scale) / 2,
                                y: (size.height - 315 * scale) / 2)
            context.scaleBy(x: scale, y: scale)
            context.translateBy(x: -45, y: -80)

            context.fill(Self.head, with: .linearGradient(
                Gradient(colors: [Color(red: 1, green: 0.995, blue: 0.99),
                                  Color(red: 0.94, green: 0.92, blue: 0.98),
                                  Color(red: 0.75, green: 0.69, blue: 0.90)]),
                startPoint: CGPoint(x: 100, y: 120), endPoint: CGPoint(x: 360, y: 390)))
            let earInk = Color(red: 0.51, green: 0.36, blue: 0.96)
            context.fill(Self.leftEar, with: .color(earInk))
            context.fill(Self.rightEar, with: .color(earInk))
            for cheek in [CGRect(x: 152, y: 286, width: 34, height: 14),
                          CGRect(x: 343, y: 271, width: 28, height: 12)] {
                context.fill(Path(ellipseIn: cheek), with: .color(.pink.opacity(0.16)))
            }

            let ink = Color(red: 0.055, green: 0.055, blue: 0.08)
            if mood == .question {
                context.draw(Text("?").font(.system(size: 91, weight: .medium, design: .rounded))
                    .foregroundColor(ink), at: CGPoint(x: 268, y: 269))
            } else if mood == .greeting || mood == .music || mood == .sleeping {
                var eyes = Path()
                for (x, y) in [(209.0, 270.0), (323.0, 259.0)] {
                    eyes.move(to: CGPoint(x: x - 12, y: y))
                    eyes.addQuadCurve(to: CGPoint(x: x + 12, y: y),
                                      control: CGPoint(x: x, y: y + (mood == .sleeping ? 14 : -23)))
                }
                context.stroke(eyes, with: .color(ink), style: StrokeStyle(lineWidth: 8, lineCap: .round))
            } else {
                context.fill(Path(roundedRect: CGRect(x: 198, y: 245, width: 24, height: 46),
                                  cornerRadius: 12), with: .color(ink))
                context.fill(Path(roundedRect: CGRect(x: 315, y: 238, width: 21, height: 41),
                                  cornerRadius: 11), with: .color(ink))
            }
            // Greeting hands only. They are omitted from the small music pose.
            if mood == .greeting {
                context.fill(Path(ellipseIn: CGRect(x: 50, y: 311, width: 29, height: 36)),
                             with: .color(Color(red: 0.96, green: 0.94, blue: 1)))
                context.fill(Path(ellipseIn: CGRect(x: 432, y: 220, width: 29, height: 36)),
                             with: .color(Color(red: 0.96, green: 0.94, blue: 1)))
            }
        }
        .rotationEffect(.degrees(angle))
        .animation(reduceMotion || dimmed ? nil : .easeInOut(duration: 0.35), value: gesture)
        .accessibilityLabel("Kiro: \(mood.label)")
    }

    // Original Kiro silhouette; large/small ears and the perspective stay intact.
    private static let head: Path = {
        var p = Path()
        p.move(to: CGPoint(x: 96, y: 224))
        let curves: [(Double, Double, Double, Double, Double, Double)] = [
            (94,204,88,182,86,163),(83,138,85,119,98,119),
            (115,119,151,138,174,149),(189,157,195,159,207,156),
            (231,150,257,148,279,147),(289,146.5,291,142,298,134),
            (319,110,339,88,356,86),(373,84,383,109,389,134),
            (394,157,392,178,399,199),(405,217,412,239,414,263),
            (417,299,414,321,395,340),(370,365,325,372,281,378),
            (237,384,183,387,150,378),(117,369,103,345,99,316),
            (95,287,98,253,96,224)
        ]
        for c in curves {
            p.addCurve(to: CGPoint(x: c.4, y: c.5),
                       control1: CGPoint(x: c.0, y: c.1), control2: CGPoint(x: c.2, y: c.3))
        }
        p.closeSubpath()
        return p
    }()

    private static let leftEar: Path = {
        var p = Path()
        p.move(to: CGPoint(x: 115, y: 187))
        p.addCurve(to: CGPoint(x: 119, y: 148), control1: CGPoint(x: 109, y: 171), control2: CGPoint(x: 108, y: 148))
        p.addCurve(to: CGPoint(x: 174, y: 171), control1: CGPoint(x: 134, y: 147), control2: CGPoint(x: 156, y: 161))
        p.addCurve(to: CGPoint(x: 115, y: 187), control1: CGPoint(x: 153, y: 172), control2: CGPoint(x: 132, y: 180))
        p.closeSubpath(); return p
    }()

    private static let rightEar: Path = {
        var p = Path()
        p.move(to: CGPoint(x: 323, y: 149))
        p.addCurve(to: CGPoint(x: 363, y: 114), control1: CGPoint(x: 336, y: 132), control2: CGPoint(x: 353, y: 111))
        p.addCurve(to: CGPoint(x: 374, y: 162), control1: CGPoint(x: 372, y: 117), control2: CGPoint(x: 377, y: 143))
        p.addCurve(to: CGPoint(x: 323, y: 149), control1: CGPoint(x: 357, y: 152), control2: CGPoint(x: 341, y: 148))
        p.closeSubpath(); return p
    }()
}
