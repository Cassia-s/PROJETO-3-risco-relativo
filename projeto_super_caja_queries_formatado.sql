-- 📌 Verificação e Tratamento de Nulos

SELECT * 
FROM `projetoriscorelativo03.supercaja.default-csv`
WHERE default_flag IS NULL;

SELECT * 
FROM `projetoriscorelativo03.supercaja.user-info-csv`
WHERE last_month_salary IS MEDIANA;

SELECT * 
FROM `projetoriscorelativo03.supercaja.user-info-csv`
WHERE number_dependents IS NULL;


-- 📌 Identificação de Duplicidades

SELECT loan_id, user_id, loan_type, COUNT(*) AS quantidade
FROM `projetoriscorelativo03.supercaja.loans-outstanding-csv`
GROUP BY loan_id, user_id, loan_type
HAVING COUNT(*) > 1;


-- 📌 Padronização de Categóricos

SELECT 
  DISTINCT LOWER(TRIM(loan_type)) AS loan_type_padronizado
FROM `projetoriscorelativo03.supercaja.loans-outstanding-csv`;


-- 📌 Identificação de Outliers em Variáveis Numéricas

SELECT
  APPROX_QUANTILES(score_risco_total, 4)[OFFSET(1)] AS Q1,
  APPROX_QUANTILES(score_risco_total, 4)[OFFSET(3)] AS Q3
FROM `projetoriscorelativo03.supercaja.score_risco`;


-- 📌 Cálculo de Correlação

SELECT 'debt_ratio' AS variavel, CORR(debt_ratio, more_90_days_overdue) AS correlacao
FROM `projetoriscorelativo03.supercaja.loans-detail-csv`
WHERE debt_ratio IS NOT NULL AND more_90_days_overdue IS NOT NULL;


-- 📌 Cálculo de Quartis, Decis e Percentis

SELECT *,
  NTILE(4) OVER (ORDER BY indice_risco_credito) AS quartil_indice_risco_credito,
  NTILE(10) OVER (ORDER BY indice_risco_credito) AS decil_indice_risco_credito,
  NTILE(100) OVER (ORDER BY indice_risco_credito) AS percentil_indice_risco_credito
FROM `projetoriscorelativo03.supercaja.unificada`;


-- 📌 Cálculo de Risco Relativo por Quartil

WITH totais_gerais AS (
  SELECT COUNT(*) AS total_geral, SUM(CASE WHEN default_flag = 1 THEN 1 ELSE 0 END) AS inadimplentes_geral
  FROM `projetoriscorelativo03.supercaja.unificada`
),
totais_por_grupo AS (
  SELECT quartil_indice_risco_credito AS grupo, COUNT(*) AS total_grupo,
         SUM(CASE WHEN default_flag = 1 THEN 1 ELSE 0 END) AS inadimplentes_grupo
  FROM `projetoriscorelativo03.supercaja.unificada`
  GROUP BY quartil_indice_risco_credito
)
SELECT grupo, total_grupo, inadimplentes_grupo,
       ROUND(SAFE_DIVIDE(inadimplentes_grupo, total_grupo), 4) AS proporcao_inadimplentes_grupo,
       ROUND(SAFE_DIVIDE(inadimplentes_geral, total_geral), 4) AS proporcao_inadimplentes_geral,
       ROUND(SAFE_DIVIDE(SAFE_DIVIDE(inadimplentes_grupo, total_grupo),
                         SAFE_DIVIDE(inadimplentes_geral, total_geral)), 4) AS risco_relativo
FROM totais_por_grupo, totais_gerais;


-- 📌 Criação do Score de Risco e Classificação de Pagadores

SELECT *,
  COALESCE(rr_indice_risco_credito, 0) + COALESCE(rr_salario_por_dependente, 0) +
  COALESCE(rr_media_debt_ratio, 0) + COALESCE(rr_uso_linhas_credito, 0) AS score_risco_total
FROM `projetoriscorelativo03.supercaja.unificada`;

SELECT *,
  CASE WHEN score_risco_total >= 7 THEN 'Mau pagador' ELSE 'Bom pagador' END AS previsao_default
FROM `projetoriscorelativo03.supercaja.score_risco`;
