import SwiftUI
import UIKit
import AudioToolbox

/// Tela principal: um botão que faz o iPhone vibrar e mostra "Olá mundo".
struct ContentView: View {
    @Environment(\.colorScheme) private var esquema
    @State private var mostrarMensagem = false
    @State private var ondas: [Onda] = []
    @State private var respirando = false

    /// Nos testes automáticos, a animação contínua fica desligada para o simulador conseguir tirar as fotos.
    private let emTeste = ProcessInfo.processInfo.arguments.contains("-modoTeste")

    var body: some View {
        ZStack {
            Fundo(escuro: esquema == .dark)

            VStack(spacing: 0) {
                cabecalho
                    .padding(.top, 32)

                Spacer()

                ZStack {
                    ForEach(ondas) { onda in
                        OndaView(atraso: onda.atraso)
                    }
                    Circle()
                        .stroke(.white.opacity(0.35), lineWidth: 2)
                        .frame(width: 236, height: 236)
                        .scaleEffect(respirando ? 1.06 : 1)
                    botao
                }
                .frame(height: 320)

                Spacer()

                mensagem
                    .frame(height: 96)
                    .padding(.bottom, 40)
            }
            .padding(.horizontal, 24)
        }
        .onAppear {
            guard !emTeste else { return }
            withAnimation(.easeInOut(duration: 1.6).repeatForever(autoreverses: true)) {
                respirando = true
            }
        }
    }

    private var cabecalho: some View {
        VStack(spacing: 8) {
            Text("Olá Mundo")
                .font(.system(size: 40, weight: .heavy, design: .rounded))
            Text("Toque no botão para vibrar")
                .font(.system(.title3, design: .rounded).weight(.medium))
                .opacity(0.8)
        }
        .foregroundStyle(.white)
        .multilineTextAlignment(.center)
    }

    private var botao: some View {
        Button(action: tocar) {
            VStack(spacing: 12) {
                Image(systemName: "bell.and.waves.left.and.right.fill")
                    .font(.system(size: 46, weight: .semibold))
                Text("Tocar")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
            }
            .foregroundStyle(Paleta.gradiente(escuro: esquema == .dark))
            .frame(width: 200, height: 200)
            .background(Circle().fill(.white))
            .shadow(color: .black.opacity(0.28), radius: 24, y: 14)
        }
        .buttonStyle(BotaoAfundaStyle())
        .accessibilityIdentifier("botaoTocar")
    }

    @ViewBuilder
    private var mensagem: some View {
        if mostrarMensagem {
            Text("Olá mundo 👋")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .padding(.horizontal, 32)
                .padding(.vertical, 18)
                .background(Capsule().fill(.white.opacity(0.18)))
                .overlay(Capsule().stroke(.white.opacity(0.4), lineWidth: 1))
                .transition(.scale(scale: 0.6).combined(with: .opacity))
                .accessibilityIdentifier("mensagemOlaMundo")
        }
    }

    private func tocar() {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)

        withAnimation(.spring(response: 0.45, dampingFraction: 0.6)) {
            mostrarMensagem = true
        }

        let novas = [0.0, 0.2, 0.4].map { Onda(atraso: $0) }
        ondas.append(contentsOf: novas)
        let ids = Set(novas.map(\.id))
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            ondas.removeAll { ids.contains($0.id) }
        }
    }
}

private struct Onda: Identifiable {
    let id = UUID()
    let atraso: Double
}

/// Um anel branco que cresce e some, como uma onda de vibração.
private struct OndaView: View {
    let atraso: Double
    @State private var expandida = false

    var body: some View {
        Circle()
            .stroke(.white, lineWidth: 4)
            .frame(width: 200, height: 200)
            .scaleEffect(expandida ? 2.1 : 1)
            .opacity(expandida ? 0 : 0.75)
            .onAppear {
                withAnimation(.easeOut(duration: 1.3).delay(atraso)) {
                    expandida = true
                }
            }
    }
}

/// Faz o botão "afundar" um pouco enquanto está pressionado.
private struct BotaoAfundaStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

private enum Paleta {
    static func gradiente(escuro: Bool) -> LinearGradient {
        let cores = escuro
            ? [Color(red: 0.17, green: 0.11, blue: 0.45), Color(red: 0.45, green: 0.12, blue: 0.40)]
            : [Color(red: 0.36, green: 0.27, blue: 0.95), Color(red: 0.93, green: 0.32, blue: 0.62)]
        return LinearGradient(colors: cores, startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

/// Fundo em degradê com dois brilhos suaves.
private struct Fundo: View {
    let escuro: Bool

    var body: some View {
        Paleta.gradiente(escuro: escuro)
            .overlay(alignment: .topTrailing) {
                Circle()
                    .fill(.white.opacity(escuro ? 0.06 : 0.12))
                    .frame(width: 320, height: 320)
                    .blur(radius: 60)
                    .offset(x: 90, y: -80)
            }
            .overlay(alignment: .bottomLeading) {
                Circle()
                    .fill(.white.opacity(escuro ? 0.05 : 0.10))
                    .frame(width: 280, height: 280)
                    .blur(radius: 70)
                    .offset(x: -100, y: 90)
            }
            .ignoresSafeArea()
    }
}
