# 🐼 Pandas Cheat Sheet (Python)

Uma referência rápida para manipulação e análise de dados.

## 1. Importação e Configuração
```python
import pandas as pd
import numpy as np

# Configurações comuns de exibição
pd.set_option('display.max_columns', None) # Mostrar todas as colunas
pd.set_option('display.max_rows', 100)     # Limitar linhas exibidas
```
## 2. Leitura e Escrita de Dados (I/O)

| Formato | Ler (Load) | Salvar (Save) |
| :--- | :--- | :--- |
| **CSV** | `df = pd.read_csv('file.csv')` | `df.to_csv('file.csv', index=False)` |
| **Excel** | `df = pd.read_excel('file.xlsx')` | `df.to_excel('file.xlsx', sheet_name='Sheet1')` |
| **JSON** | `df = pd.read_json('file.json')` | `df.to_json('file.json')` |
| **SQL** | `df = pd.read_sql(query, conn)` | `df.to_sql('table', conn)` |
| **Parquet**| `df = pd.read_parquet('file.parquet')`| `df.to_parquet('file.parquet')` |
| **Clipboard**| `df = pd.read_clipboard()` | `df.to_clipboard()` |

## 3. Inspeção e Exploração Inicial
* `df.head(n)`: Primeiras n linhas.
* `df.tail(n)`: Últimas n linhas.
* `df.shape`: (linhas, colunas).
* `df.info()`: Resumo de tipos e memória.
* `df.describe()`: Estatísticas descritivas (média, min, max).
* `df.columns`: Lista das colunas.
* `df.dtypes`: Tipos de dados.
* `df['col'].unique()`: Valores únicos.
* `df['col'].value_counts()`: Frequência de valores.

## 4. Seleção e Filtragem
* **Colunas:**
    * `df['coluna']`: Retorna Série.
    * `df[['col1', 'col2']]`: Retorna DataFrame.
* **Loc/iLoc:**
    * `df.loc[label_row, label_col]`: Por rótulo.
    * `df.iloc[idx_row, idx_col]`: Por posição numérica.
* **Filtros:**
    * `df[df['idade'] > 18]`: Condição simples.
    * `df[(cond1) & (cond2)]`: E (AND).
    * `df[(cond1) | (cond2)]`: OU (OR).
    * `df.query('idade > 18')`: Sintaxe SQL-like.
    * `df[df['col'].isin([v1, v2])]`: Pertence à lista.

## 5. Limpeza de Dados (Data Cleaning)
* **Nulos:**
    * `df.isna().sum()`: Conta nulos.
    * `df.dropna()`: Remove linhas com nulos.
    * `df.fillna(value)`: Preenche nulos.
* **Duplicatas:**
    * `df.duplicated()`: Checa duplicatas.
    * `df.drop_duplicates()`: Remove duplicatas.

## 6. Manipulação e Transformação
* **Geral:**
    * `df.rename(columns={'old': 'new'})`: Renomear.
    * `df.sort_values(by='col')`: Ordenar.
    * `df.reset_index(drop=True)`: Resetar índice.
* **Colunas:**
    * `df['nova'] = df['a'] + df['b']`: Criar coluna.
    * `df.drop(columns=['col'], inplace=True)`: Deletar coluna.
* **Apply/Map:**
    * `df.apply(func)`: Aplicar função.
    * `df['col'].map({k:v})`: Mapear valores.
    * `df['col'].astype(int)`: Converter tipo.

## 7. Agrupamento (Groupby)
```python
# Básico
df.groupby('categoria')['valor'].mean()

# Agregação múltipla
df.groupby('cat').agg({'val1': 'sum', 'val2': 'mean'})
```
* `pd.pivot_table(df, ...)`: Tabela dinâmica.

## 8. Merge & Concat
* `pd.concat([df1, df2])`: Empilhar verticalmente.
* `pd.merge(df1, df2, on='id', how='left')`: Join (semelhante ao SQL).

## 9. Séries Temporais
* `pd.to_datetime(df['data'])`: Converter para datetime.
* `df['data'].dt.year`: Extrair ano/mês/dia.
* `df.resample('M').mean()`: Reamostragem mensal.
* `df['val'].rolling(7).mean()`: Média móvel.

## 10. Estatística Básica
* `df.mean()`, `df.median()`: Média e Mediana.
* `df.std()`: Desvio padrão.
* `df.corr()`: Correlação.

