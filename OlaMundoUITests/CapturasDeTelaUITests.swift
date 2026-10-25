import XCTest

/// Abre o app no simulador, toca no botão e tira fotos da tela em cada etapa.
final class CapturasDeTelaUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testTocarMostraOlaMundo() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-modoTeste"]
        app.launch()

        let botao = app.buttons["botaoTocar"]
        XCTAssertTrue(botao.waitForExistence(timeout: 10), "O botão Tocar não apareceu")
        XCTAssertFalse(app.staticTexts["mensagemOlaMundo"].exists, "A mensagem não deveria aparecer antes do toque")
        capturar("01-inicio")
        let alturaDoBotao = botao.frame.midY

        botao.tap()
        capturar("02-tocando")

        let mensagem = app.staticTexts["mensagemOlaMundo"]
        XCTAssertTrue(mensagem.waitForExistence(timeout: 5), "A mensagem Olá mundo não apareceu")
        sleep(2)
        capturar("03-mensagem")
        XCTAssertEqual(botao.frame.midY, alturaDoBotao, accuracy: 1, "O botão mudou de lugar quando a mensagem apareceu")
    }

    private func capturar(_ nome: String) {
        let anexo = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        anexo.name = nome
        anexo.lifetime = .keepAlways
        add(anexo)
    }
}
