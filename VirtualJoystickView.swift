import SwiftUI

struct VirtualJoystickView: View {
    @State private var location: CGPoint = .zero
    @State private var innerCircleLocation: CGPoint = .zero
    
    let maxDistance: CGFloat = 50.0 // Maximum travel distance for the joystick

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Outer Base Ring
                Circle()
                    .fill(Color.black.opacity(0.4))
                    .frame(width: maxDistance * 2.5, height: maxDistance * 2.5)
                
                // Inner Thumbstick
                Circle()
                    .fill(Color.white.opacity(0.8))
                    .frame(width: maxDistance, height: maxDistance)
                    .offset(x: innerCircleLocation.x, y: innerCircleLocation.y)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                let translation = value.translation
                                let distance = sqrt(pow(translation.width, 2) + pow(translation.height, 2))
                                
                                if distance <= maxDistance {
                                    innerCircleLocation = CGPoint(x: translation.width, y: translation.height)
                                } else {
                                    let angle = atan2(translation.height, translation.width)
                                    innerCircleLocation = CGPoint(
                                        x: cos(angle) * maxDistance,
                                        y: sin(angle) * maxDistance
                                    )
                                }
                                
                                // TODO: Send innerCircleLocation coordinates to emulator core
                                // e.g., EmulatorEngine.shared.updateJoystick(x: innerCircleLocation.x, y: innerCircleLocation.y)
                            }
                            .onEnded { _ in
                                // Snap back to center when released
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                    innerCircleLocation = .zero
                                }
                                // TODO: Reset emulator core joystick input
                            }
                    )
            }
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
        }
    }
}
