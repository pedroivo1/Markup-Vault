# Configurar Projeto (.sublime-project)

Abra o arquivo `.sublime-project` na raiz do seu projeto e ajuste o conteúdo para incluir o **Build System do Pytest** (usando o venv) e as **Réguas**.

```json
{
    "folders":
    [
        {
            "path": "."
        }
    ],
    "build_systems": [
        {
            "name": "Pytest Run",
            "cmd": [".venv/Scripts/python.exe", "-m", "pytest"], 
            "shell": true,
            "working_dir": "${project_path}",
            "selector": "source.python"
        }
    ],
    "settings": {
        "tab_size": 4,
        "translate_tabs_to_spaces": true,
        "rulers": [80, 120]
    }
}

**Explicação:**

- **`build_systems`**: Cria a opção `Pytest Run` (ativada por `Ctrl+B`) forçando o uso do Python que está dentro da pasta `.venv`, garantindo que ele encontre o `pytest` e o seu pacote local. 
- **`rulers`**: Adiciona linhas verticais nas colunas 80 e 120 para guiar a formatação do código (padrão PEP 8).
