import SwiftUI
import AudioToolbox

/// Tela principal: um botão que mostra "Olá mundo" e faz o iPhone vibrar.
struct ContentView: View {
    @State private var mostrarMensagem = false

    private let roxo = Color(red: 0.36, green: 0.27, blue: 0.95)
    private let rosa = Color(red: 0.93, green: 0.32, blue: 0.62)

    var body: some View {
        ZStack {
            LinearGradient(colors: [roxo, rosa], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack(spacing: 48) {
                Text("Olá mundo")
                    .font(.system(size: 48, weight: .heavy, design: .rounded))
                    .foregroundStyle(.white)
                    .opacity(mostrarMensagem ? 1 : 0)
                    .scaleEffect(mostrarMensagem ? 1 : 0.6)

                Button(action: tocar) {
                    Text("Tocar")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(roxo)
                        .frame(width: 180, height: 180)
                        .background(Circle().fill(.white))
                        .shadow(color: .black.opacity(0.25), radius: 16, y: 8)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func tocar() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
            mostrarMensagem = true
        }
        // Vibração padrão do iPhone
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
}
