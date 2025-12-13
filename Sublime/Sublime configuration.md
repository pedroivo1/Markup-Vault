# 🔧 Configuração do Sublime Text

## 1. Instalação de Pacotes Essenciais

Abra o Command Palette (`Ctrl + Shift + P`), digite **`Install Package`**

Instale o `Install Package`.

Reinicie o Sublime e, abra o Command Palette, digite "Install Package", baixe os seguintes apps:

- **`Terminus`**: Terminal integrado.
- **`Markdown Preview`**: Visualizador de arquivos `.md` no navegador.
- **`A File Icon`**: Decorador de **ícones** para a barra lateral.

## 2. Configurar Atalhos (Key Bindings)

Vá em `Preferences > Key Bindings` e cole este código no painel da **direita** (User).

```json
[
    { 
        "keys": ["alt+shift+t"], 
        "command": "terminus_open", 
        "args" : { 
            "cmd": "powershell.exe", 
            "cwd": "${folder}", 
            "panel_name": "PowerShell" 
        } 
    }, 

    { 
        "keys": ["ctrl+alt+v"], 
        "command": "markdown_preview", 
        "args": { "target": "browser" } 
    }
]
```

**Explicação:**  
Define `Alt+Shift+T` para abrir o terminal e `Ctrl+Alt+V` para visualizar Markdown (não tem conflitos com atalhos nativos).

