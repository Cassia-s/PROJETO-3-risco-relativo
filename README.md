# PROJETO-3-risco-relativo

Projeto Super Caja – Análise de Risco de Crédito

  </details>
  
  <details>
  <summary><strong style="font-size: 16px;">Objetivo</strong></summary>

Este repositório contém a análise completa do projeto Super Caja, cujo objetivo foi automatizar a avaliação de risco de crédito para um banco fictício, utilizando técnicas de análise de dados, estatística e visualização.

  </details>
  
  <details>
  <summary><strong style="font-size: 16px;">Visão geral</strong></summary>

🔍 Visão Geral

Diante do aumento da demanda por crédito e da alta inadimplência, propusemos uma solução baseada em dados para:

Avaliar o risco de crédito de forma automatizada

Identificar perfis de risco com base em comportamento financeiro e demográfico

Apoiar decisões de concessão de crédito com uma métrica objetiva

  </details>
  
  <details>
  <summary><strong style="font-size: 16px;">Estrutura do projeto</strong></summary>

📁 Estrutura do Projeto

Etapa

Descrição

1. Importação de Dados

Importação e integração no BigQuery das 4 bases fornecidas (CSV)

2. Limpeza dos Dados

Tratamento de nulos, duplicados, padronização de textos e tipos de dados

3. Enriquecimento

Criação de novas variáveis, joins e flags de comportamento

4. Análise Exploratória

Correlações, estatísticas descritivas e agrupamentos

5. Risco Relativo

Cálculo por quartis e criação do score de risco

6. Validação

Matriz de confusão: comparação entre previsão e realidade

7. Visualização

Dashboard interativo no Looker Studio

  </details>
  
  <details>
  <summary><strong style="font-size: 16px;">Técnicas Utilizadas</strong></summary>

🧮 Técnicas Utilizadas

SQL no BigQuery

Estatística descritiva (média, mediana, desvio padrão, percentis)

Correlação entre variáveis

Intervalo interquartil (IQR) para detectar outliers

Risco relativo por quartis

Score composto para classificação de inadimplência

Matriz de confusão para validação do modelo

  </details>
  
  <details>
  <summary><strong style="font-size: 16px;">Dashboard</strong></summary>

📊 Dashboard Interativo

🔗 Acessar o Dashboard no Looker Studio (Substituir pelo link real)

Inclui:

Scorecards

Gráficos univariados e bivariados

Tabelas interativas com destaques visuais

Filtros por sexo, idade, renda, score e tipo de empréstimo

  </details>
  
  <details>
  <summary><strong style="font-size: 16px;">Arquivos</strong></summary>

🧾 Arquivos Disponíveis

ficha_tecnica.txt: descrição detalhada de todas as etapas

queries.sql: todas as queries utilizadas para limpeza, cálculo e análise

README.md: este arquivo

  </details>
  
  <details>
  <summary><strong style="font-size: 16px;">Conclusão</strong></summary>

💬 Conclusões

Faixas de menor renda e mais jovens concentram maior risco

Score de risco composto foi eficaz para prever inadimplência

Risco relativo por quartil revelou insights de segmentação poderosos

Visualização facilitou a comunicação dos resultados com stakeholders

  </details>
  
  <details>
  <summary><strong style="font-size: 16px;">Equipe</strong></summary>

👩‍💻 Autor

Cassia – Analista de Dados | Projeto Super Caja – Bootcamp

