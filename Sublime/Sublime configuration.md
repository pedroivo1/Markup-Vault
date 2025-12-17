# 🔧 Configuração do Sublime Text

## 1. Instalação de Pacotes Essenciais

Digite `Ctrl + Shift + P`, digite **`Install Package`**.

Instale o `Install Package`.

Digite `Ctrl + Shift + P`, digite **`Install Package`**, selecione `Package Control: Install Package`.

procure e instale:
- **`Terminus`**
- **`MarkdownLivePreview`**
- **`A File Icon`**

## 2. Configurar Atalhos (Key Bindings)

Vá em `Preferences > Key Bindings` e cole este código no painel da **direita** (User).

```json
[
    { 
        "keys": ["alt+shift+t"], 
        "command": "terminus_open", 
        "args" : { 
            "cwd": "${folder}", 
            "panel_name": "Terminal"
        } 
    }, 

    { 
        "keys": ["ctrl+alt+v"], 
        "command": "markdown_live_preview"
    }
]
```

**Explicação:**  
Define `Alt+Shift+T` para abrir o terminal e `Ctrl+Alt+V` para visualizar Markdown (não tem conflitos com atalhos nativos).

## 3. Preferece > Settings

na direita cole:
```json
{
    "word_wrap": true,
    "wrap_width": 0,
    
    "draw_white_space": "all",
    "tab_size": 4,

    "auto_save_on_focus_lost": true
}
```