SELECT *

-- ===================================

SELECT

-- ===================================

SELECT
-- Tabela: loans_detail.csv → correlação com more_90_days_overdue

-- ===================================

SELECT 'number_times_delayed_payment_loan_30_59_days' AS variavel,
--0.98291680661459857
UNION ALL

-- ===================================

SELECT 'number_times_delayed_payment_loan_60_89_days',
--0.99217552634075257
UNION ALL

-- ===================================

SELECT 'debt_ratio',
---0.0082076486652037164
UNION ALL

-- ===================================

SELECT 'using_lines_not_secured_personal_assets',
---0.0013609406054606963
-- Tabela: user_info.csv + default.csv → correlação com default_flag
UNION ALL

-- ===================================

SELECT 'age',
---0.078217701557854333
UNION ALL

-- ===================================

SELECT 'last_month_salary',
---0.021943879599816363
UNION ALL

-- ===================================

SELECT 'number_dependents',
--0.031926119352033884
UNION ALL

-- ===================================

SELECT 'using_lines_not_secured_personal_assets' AS variavel, CORR(debt_ratio, using_lines_not_secured_personal_assets) AS correlacao
--0.01501213874328
UNION ALL

-- ===================================

SELECT 'last_month_salary' AS variavel, CORR(age, last_month_salary) AS correlacao
--0.035978007340201588
UNION ALL

-- ===================================

SELECT 'number_dependents' AS variavel, CORR(age, number_dependents) AS correlacao
---0.21661156571947512
UNION ALL

-- ===================================

SELECT 'total_atraso_30_59' AS variavel, CORR(score_credito, total_atraso_30_59) AS correlacao
---0.00028169858362550815
UNION ALL

-- ===================================

SELECT 'total_atraso_60_89' AS variavel, CORR(score_credito, total_atraso_60_89) AS correlacao
---0.00036510277142192879
UNION ALL

-- ===================================

SELECT 'total_atraso_90_plus' AS variavel, CORR(score_credito, total_atraso_90_plus) AS correlacao
---0.00020526804303228825
UNION ALL

-- ===================================

SELECT 'qtd_loans_ativos' AS variavel, CORR(score_credito, qtd_loans_ativos) AS correlacao
----0.041221034754838952
UNION ALL

-- ===================================

SELECT 'salario_tratado' AS variavel, CORR(score_credito, salario_tratado) AS correlacao
----0.026861423668492427
UNION ALL

-- ===================================

SELECT 'media_debt_ratio' AS variavel, CORR(score_credito, media_debt_ratio) AS correlacao
---0.87397095204604536

-- ===================================

CREATE OR REPLACE TABLE `projetoriscorelativo03.supercaja.loans-outstanding-csv` AS

-- ===================================

SELECT
FROM `projetoriscorelativo03.supercaja.loans-outstanding-csv`;

-- ===================================

CREATE OR REPLACE TABLE `projetoriscorelativo03.supercaja.dataset_enriquecido` AS

-- ===================================

WITH base AS (

-- ===================================

SELECT
-- Total de empréstimos ativos por cliente
-- Tipos únicos de empréstimo por cliente
DISTINCT LOWER(TRIM(COALESCE(o.loan_type_padronizado, 'não informado'))), -- Usa COALESCE para tratar NULLs
-- Soma dos atrasos de pagamento por categoria
-- Soma de todos os atrasos
-- Proporção entre dívidas e uso de linhas de crédito
-- Índice de inadimplência histórica
`projetoriscorelativo03.supercaja.user-info-csv-limpa` AS u  -- << atualizado aqui

-- ===================================

SELECT *,
-- Faixa etária
-- Salário por dependente (ajuste de renda)
-- Renda categorizada
-- Índice composto de risco (proxy simplificado)
-- Histórico de inadimplência
FROM base;

-- ===================================

CREATE OR REPLACE TABLE `projetoriscorelativo03.supercaja.loans-outstanding-csv` AS

-- ===================================

SELECT
FROM `projetoriscorelativo03.supercaja.loans-outstanding-csv`;

-- ===================================

CREATE OR REPLACE TABLE projetoriscorelativo03.supercaja.base_com_quartis AS

-- ===================================

WITH base AS (

-- ===================================

SELECT

-- ===================================

SELECT
-- Quartis
-- Decis
-- Percentis (NTILE(100) pode ser pesado, use com cuidado em grandes bases)

-- ===================================

SELECT * FROM base_com_quartis;

-- ===================================

CREATE OR REPLACE TABLE `projetoriscorelativo03.supercaja.score_risco` AS

-- ===================================

CREATE OR REPLACE TABLE `projetoriscorelativo03.supercaja.score_risco` AS

-- ===================================

SELECT
-- Soma dos riscos relativos para formar o score total
FROM `projetoriscorelativo03.supercaja.unificada`;

-- ===================================

SELECT
FROM `projetoriscorelativo03.supercaja.score_risco`;

-- ===================================

CREATE OR REPLACE TABLE `projetoriscorelativo03.supercaja.score_classificado` AS

-- ===================================

SELECT
FROM `projetoriscorelativo03.supercaja.score_risco`;

-- ===================================

SELECT
ORDER BY previsao_default, default_flag;

-- ===================================

SELECT
FROM `projetoriscorelativo03.supercaja.score_risco`;

-- ===================================

CREATE OR REPLACE TABLE `projetoriscorelativo03.supercaja.risco_relativo_indice_credito` AS

-- ===================================

WITH totais_gerais AS (

-- ===================================

SELECT

-- ===================================

SELECT

-- ===================================

SELECT
FROM totais_por_grupo, totais_gerais;

-- ===================================

CREATE OR REPLACE TABLE `projetoriscorelativo03.supercaja.risco_relativo_salario_dependente` AS

-- ===================================

WITH totais_gerais AS (

-- ===================================

SELECT COUNT(*) AS total_geral,

-- ===================================

SELECT

-- ===================================

SELECT
FROM totais_por_grupo, totais_gerais;

-- ===================================

CREATE OR REPLACE TABLE `projetoriscorelativo03.supercaja.risco_relativo_debt_ratio` AS

-- ===================================

WITH totais_gerais AS (

-- ===================================

SELECT COUNT(*) AS total_geral,

-- ===================================

SELECT

-- ===================================

SELECT
FROM totais_por_grupo, totais_gerais;

-- ===================================

CREATE OR REPLACE TABLE `projetoriscorelativo03.supercaja.risco_relativo_uso_linhas_credito` AS

-- ===================================

WITH totais_gerais AS (

-- ===================================

SELECT COUNT(*) AS total_geral,

-- ===================================

SELECT

-- ===================================

SELECT

-- ===================================

CREATE OR REPLACE TABLE `projetoriscorelativo03.supercaja.dataset_enriquecido` AS

-- ===================================

WITH user_loans_count AS (

-- ===================================

SELECT

-- ===================================

SELECT
-- Salário tratado com mediana

-- ===================================

SELECT APPROX_QUANTILES(last_month_salary, 2)[OFFSET(1)]
-- Dependentes tratados com zero
-- Tipos únicos de empréstimo por cliente
-- Tipos padronizados
-- Atrasos
-- Média de dívida e uso de crédito
-- Índice de inadimplência histórica

-- ===================================

SELECT
-- Faixa etária
-- Salário por dependente (ajuste de renda)
-- Renda categorizada
-- Índice composto de risco
ON base.user_id = ulc.user_id;

-- ===================================

CREATE OR REPLACE TABLE `projetoriscorelativo03.supercaja.unificada` AS
-- 1. Agregação de loans-detail por user_id

-- ===================================

WITH detalhes_agg AS (

-- ===================================

SELECT
-- 2. Agregação de loans-outstanding por user_id

-- ===================================

SELECT
-- 3. União com dataset_enriquecido + agregados + quartis

-- ===================================

SELECT
-- Quartis e percentis da base_com_quartis
-- 4. Adiciona riscos relativos à unificada

-- ===================================

SELECT
-- Risco relativo por quartil de índice de risco
-- Risco relativo por quartil de salário por dependente
-- Risco relativo por quartil de debt ratio
-- Risco relativo por quartil de uso de linhas de crédito
ON u.quartil_uso_linhas_credito = rr_uso.grupo;