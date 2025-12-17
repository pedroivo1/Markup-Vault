## Lista de Comandos

### Ler e Salvar Dados

Ler dados:
```python
df = pd.read_csv('file.csv')
df = pd.read_excel('file.xlsx')
```

Salvar data frame: 
```python
df.to_csv('file.csv')
df.to_excel('file.xlsx')
```

### Explorar Dados

Receber n primeiras linhas:
```python
df.head(n)
```

Receber n útimas linhas:
```python
df.tail(n)
```

Receber tipos de dados de cada coluna:
```python
df.info()
```

Receber estatísticas gerais:
```python
df.describe()
```

Receber dimensão da tabela (linhas x colunas)
```python
df.shape
```

Receber nomes de todas colunas:
```python
df.columns
```
