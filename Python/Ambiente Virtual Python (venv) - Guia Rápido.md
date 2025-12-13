# 🐍 Ambiente Virtual Python (venv) - Guia Rápido

## 1. Criar o Ambiente Virtual

Na raiz do seu projeto, rode:
```bash
python -m venv .venv
```

**Explicação:**  
Cria uma nova pasta chamada `.venv` dentro do seu projeto, contendo uma cópia isolada do interpretador Python e do `pip`.


## 2. Ativar o Ambiente Virtual

Para usar o `.venv` você deve ativá-lo.

```bash
.\.venv\Scripts\activate
```

**Explicação:**  
Depois desse comando o Python usado será o Python dentro da pasta .venv e não o Python do SO.


Após a ativação, o nome do ambiente, `(.venv)`, deve aparecer no início da linha de comando, indicando que ele está ativo:
```bash
(.venv) PS C:\Users\...
```

## 3. Configurar o Ambiente Virtual

O `(.venv)` é  uma **cópia estrita** do interpretador Python base e do `pip`, **não incluindo** os *symlinks* ou referências às bibliotecas instaladas no diretório de pacotes global do SO.

### 3.1 Instalar o Projeto em Modo Editável e Dependências

Para que o ambiente virtual reconheça seu código local e instale as dependências de desenvolvimento, rode:
```bash
pip install -e .[dev]
```

**Explicação:**  

- `-e .` instala o pacote local (a pasta atual) em modo editável. Isso é crucial para que ferramentas como o `pytest` encontrem seu módulo.
- `[dev]` indica a instalação de dependências específicas para o ambiente de desenvolvimento e testes.

### 3.2 Instalar Dependências de um Arquivo (Opcional)

Se o projeto tiver um arquivo de dependências (`requirements.txt`), rode:

```bash
pip install -r requirements.txt
```
**Explicação:**  
Baixa todos os pacotes listados em `requirements.txt`.

## 4. Gerenciamento do Ambiente

- Desativar o `.venv`:
```bash
deactivate
```

- Excluir o `.venv`:
```bash
rmdir /s /q .venv
```

- Salvar quais pacotes extras foram instalados:
```bash
pip freeze > nome_do_arquivo.txt
```
