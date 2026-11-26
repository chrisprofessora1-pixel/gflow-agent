# Gflow

Agente de imagem e vídeo para o Google Flow, feito para o OpenCode.

Ele não é um gerador próprio. Ele conversa com você, confere a conta e os créditos, monta o comando e usa o [gflow-cli](https://github.com/ffroliva/gflow-cli) para gerar imagem, vídeo, narração e legenda.

## O que ele faz

- Imagem no Nano Banana e no Imagen.
- Vídeo no Veo e no Omni.
- Imagem para vídeo, vídeo com referência, extensão de cena e upscale.
- Narração, transcrição, legenda queimada e montagem de clipes.
- Confere o saldo antes de gastar crédito e só gera depois do seu sim.

## O que você precisa

- macOS ou Linux. No Windows, siga o passo a passo manual mais abaixo.
- [gflow-cli](https://github.com/ffroliva/gflow-cli) instalado.
- Uma conta Google com acesso ao Flow.
- [OpenCode](https://opencode.ai) instalado.

## Instalar

```bash
uv tool install gflow-cli

git clone https://github.com/chrisprofessora1-pixel/gflow-agent.git
cd gflow-agent
bash install.sh
```

Se você ainda não tem o `uv`:

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

O instalador faz quatro coisas:

1. Cria a pasta `Flow` dentro dos seus Downloads.
2. Aponta `GFLOW_CLI_OUTPUT_DIR` para essa pasta no `.env` do gflow.
3. Copia o agente para `~/.config/opencode/agents/gflow.md`.
4. Guarda um backup se você já tinha um agente com esse nome.

## Login

Uma vez só, no terminal:

```bash
gflow auth login --browser chrome
```

Abre uma janela do Chrome. Faça login na conta que tem acesso ao Flow. O agente nunca pede sua senha, cookie ou código.

Para conferir depois:

```bash
gflow auth status
gflow credits user --json
```

## Usar

Abra o OpenCode e digite `gflow` junto com o pedido. Exemplos:

```text
gflow, faz uma imagem 9:16 de uma professora sorrindo numa sala clara
gflow, anima essa foto em um vídeo de 8 segundos
gflow, faz um vídeo 16:9 de 10 segundos com esse personagem
gflow, qual é o meu saldo de créditos?
```

Ele pergunta o que falta, mostra o custo e só gera depois do seu sim.

## Onde ficam os arquivos

- Imagem: `~/Downloads/Flow/images/<data>/`
- Vídeo: `~/Downloads/Flow/videos/<data>/`
- Áudio: `~/Downloads/Flow/audio/`
- Legendas: `~/Downloads/Flow/legendas/`
- Montagens: `~/Downloads/Flow/montagens/`

O instalador grava o caminho em `GFLOW_CLI_OUTPUT_DIR`, no `.env` da pasta de configuração do gflow. Se quiser mudar de pasta, edite essa linha.

## O que nunca vai para este repositório

- Conta Google, e-mail, cookies ou perfil do Chrome.
- Banco `gflow.db` e histórico de gerações.
- `.env` com caminho pessoal.
- Arquivos gerados na pasta Downloads.

O agente não tem conta configurada. Ele usa a conta que estiver logada na máquina de quem instalou.

## Segurança

O gflow abre um Chrome real com a sua sessão. Rode só na sua máquina. Nunca cole cookies, tokens ou dados de sessão em um prompt. Se o Google marcar a sessão como atividade incomum, pare e espere esfriar.

## Windows, instalação manual

1. Instale o CLI com `uv tool install gflow-cli`.
2. Crie a pasta `%USERPROFILE%\Downloads\Flow`.
3. Crie ou edite `%LOCALAPPDATA%\gflow-cli\.env` com esta linha:

   ```text
   GFLOW_CLI_OUTPUT_DIR="C:\Users\SEU_USUARIO\Downloads\Flow"
   ```

4. Copie `opencode\agents\gflow.md` para `%USERPROFILE%\.config\opencode\agents\gflow.md`.
5. Faça o login com `gflow auth login --browser chrome`.

## Créditos

O CLI é do projeto [gflow-cli](https://github.com/ffroliva/gflow-cli), de ffroliva. Este repositório é só o agente e o instalador.

## Licença

MIT. Use, adapte e compartilhe mantendo o aviso de copyright.
