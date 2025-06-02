
# Projeto Super Caja – Análise de Risco de Crédito

## 💼 Desafio do Negócio

Com a queda das taxas de juros, o banco Super Caja viu a demanda por crédito crescer consideravelmente. A equipe de análise manual tornou-se um gargalo, aumentando o risco de inadimplência. O objetivo foi criar um modelo de score de risco automatizado, baseado em dados, para classificar clientes entre bons e maus pagadores.

## 📦 Bases de Dados Utilizadas

- `user-info-csv`: Dados demográficos e salariais
- `default-csv`: Histórico de inadimplência
- `loans-outstanding-csv`: Tipos e quantidade de empréstimos
- `loans-detail-csv`: Atrasos e uso de crédito

## 🧹 Limpeza e Preparação

- Tratamento de nulos: salários com mediana, dependentes e default_flag como zero
- Padronização de categorias (`loan_type`)
- Identificação de duplicatas e outliers (via IQR)
- Conversão de tipos para análises posteriores

## 🧠 Enriquecimento e Feature Engineering

- Variáveis criadas: `indice_risco_credito`, `salario_por_dependente`, `faixa_etaria`, etc.
- Quartis, decis e percentis com `NTILE()`
- Score de risco construído com soma dos riscos relativos

## 📊 Análise Exploratória

- Correlações via `CORR()`
- Médias, medianas e desvios padrão
- Gráficos no Looker Studio (boxplot, barras, dispersão)
- Segmentação de clientes por faixa etária, uso de crédito e inadimplência

## ⚙️ Técnicas Analíticas

- Cálculo de Risco Relativo por grupo
- Criação de score composto
- Classificação dos clientes com base em corte (>= 7 pontos)
- Validação com matriz de confusão e KPIs

**Resultados**:
- Acurácia: 92,7%
- Recall: 86%
- Precisão: 18,9%

## 📈 Visualização no Looker Studio

- Scorecards: total de clientes, inadimplência, score médio
- Filtros por idade, sexo, faixa salarial, tipo de empréstimo
- Gráficos: risco relativo, score vs previsão, inadimplência por perfil

## ✅ Conclusões e Recomendações

- Clientes com perfil “Sênior”, score baixo e boa renda → aprovação automática
- Jovens com uso intenso de crédito e baixa renda → risco elevado
- Modelo pronto para ser integrado à esteira de crédito

---

## 📁 Queries SQL do Projeto

Todas as queries estão disponíveis no arquivo `queries_super_caja.sql` neste repositório.

---

## 👩‍💻 Desenvolvido por

Cassia – Projeto de Análise de Crédito no Bootcamp de Dados | 2025
