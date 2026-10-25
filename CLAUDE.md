# Olá Mundo — app de iPhone

App nativo (Swift + SwiftUI) feito no Windows, sem Mac e sem custo. Fale sempre em português do Brasil, em linguagem simples: quem usa este projeto está começando a programar.

## Objetivo
Um botão que, ao ser tocado, toca o som escolhido pelo usuário, vibra e mostra "Olá mundo" (na tela e como notificação).

## Aparelhos
- iPhone 11: entrada Lightning, aceita iOS 26 e 27. Versão atual do iOS: a confirmar.
- PC: Windows 11, sem entrada USB-C (precisa de cabo Lightning ↔ USB-A).

## Como o app é montado (não há Mac)
1. Cada `git push` na branch `main` dispara `.github/workflows/montar-app.yml`: um Mac do GitHub (`macos-26`, Xcode 26) gera o projeto com XcodeGen a partir do `project.yml` e monta o app **sem assinatura**.
2. O app fica como artefato `OlaMundo-ipa`. Para baixar: `gh run download --name OlaMundo-ipa --dir app-pronto`.
3. Quando o app estiver pronto, o próprio usuário instala no iPhone pelo cabo, com o Apple ID grátis (Sideloadly ou Impactor).

- `*.xcodeproj` e `OlaMundo/Info.plist` são gerados na montagem: altere o `project.yml`.
- Swift para iOS não compila no Windows, então cada teste depende de uma montagem no GitHub (cerca de 10 min). Junte as mudanças e revise o código com cuidado antes de enviar. Se a montagem falhar, veja o erro com `gh run view --log-failed`.

## Laboratório de testes (simulador na nuvem)
- `.github/workflows/testar-no-simulador.yml` roda a cada push: cria um simulador de iPhone 11 num Mac do GitHub, roda os testes de interface (`OlaMundoUITests`) nos modos claro e escuro e guarda fotos da tela e um vídeo no artefato `capturas-de-tela`.
- Para analisar: `gh run download <id> --name capturas-de-tela --dir capturas` e abra as imagens. Revise o visual pelas fotos antes de entregar.
- Nos testes, o app recebe `-modoTeste`, que desliga as animações contínuas (senão o simulador não "para" para fotografar).
- O simulador não vibra nem toca som de verdade: vibração, som e modo silencioso só se confirmam no iPhone.

## Fases
| Fase | Pronto quando |
|---|---|
| 0. Preparação | O GitHub monta o app sem erro |
| 1. "Olá mundo" que vibra (atual) | O app está no iPhone; o botão mostra o texto e vibra |
| 2. Som | Um som que vem no app toca mesmo no silencioso (`AVAudioSession` `.playback`), com vibração e botão Parar |
| 3. Escolher o som | O som escolhido no app Arquivos (inclui Google Drive) ou na biblioteca de Música toca ao apertar o botão; o app lembra a escolha |
| 4. Notificação | A notificação local "Olá mundo" aparece com o som escolhido, inclusive com a tela bloqueada |
| 5. Alarme (opcional) | Um alarme do AlarmKit toca na hora marcada, mesmo no silencioso |

## Limites conhecidos
- Não existe API pública para os toques de alarme do sistema (confirmado pela Apple). Na fase 3 dá para testar, sem garantia, a leitura de `/System/Library/Audio/UISounds`.
- Músicas do Apple Music (com DRM) não podem ser lidas pelo app.
- Som de notificação: no máximo 30 s, em `.caf`/`.wav`/`.aiff`, guardado em `Library/Sounds`.
- Assinatura grátis: o app vence em 7 dias, no máximo 3 apps, sem push remoto, iCloud ou Apple Pay.
- Alvo mínimo: iOS 16.0. Use `if #available(iOS 26, *)` para o AlarmKit.

## Regras
- Peça confirmação antes de instalar programas, apagar arquivos ou publicar/enviar algo.
- Nunca digite nem peça para ver senhas: o usuário faz os logins numa janela própria.
- Uma fase de cada vez, com um commit a cada etapa que funcionar.
- As skills em `.claude/skills/` (alarmkit, push-notifications, swiftui-patterns) foram copiadas de dpearson2699/swift-ios-skills e não vão para o GitHub.
