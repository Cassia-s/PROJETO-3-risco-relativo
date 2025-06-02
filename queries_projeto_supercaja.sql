
-- ✅ 1. Verificar valores nulos
SELECT * FROM `projetoriscorelativo03.supercaja.default-csv` WHERE default_flag IS NULL;

-- ✅ 2. Identificar duplicidades
SELECT loan_id, user_id, loan_type, COUNT(*) as quantidade
FROM `projetoriscorelativo03.supercaja.loans-outstanding-csv`
GROUP BY loan_id, user_id, loan_type
HAVING COUNT(*) > 1;

-- ✅ 3. Padronizar categorias textuais (loan_type)
SELECT *, LOWER(TRIM(loan_type)) AS loan_type_padronizado
FROM `projetoriscorelativo03.supercaja.loans-outstanding-csv`;

-- ✅ 4. Unificação das tabelas com criação de variáveis derivadas
CREATE OR REPLACE TABLE `projetoriscorelativo03.supercaja.unificada` AS
WITH base AS (
  SELECT
    u.user_id,
    u.age,
    COALESCE(u.last_month_salary, (SELECT APPROX_QUANTILES(last_month_salary, 2)[OFFSET(1)] FROM `projetoriscorelativo03.supercaja.user-info-csv` WHERE last_month_salary IS NOT NULL)) AS last_month_salary,
    COALESCE(u.number_dependents, 0) AS number_dependents,
    COALESCE(d.default_flag, 0) AS default_flag,

    COUNT(DISTINCT o.loan_id) AS qtd_loans_ativos,
    COUNT(DISTINCT LOWER(TRIM(o.loan_type_padronizado))) AS qtd_tipos_emprestimo,
    STRING_AGG(DISTINCT LOWER(TRIM(o.loan_type_padronizado)), ', ') AS tipos_emprestimos_padronizados,

    SUM(COALESCE(ld.number_times_delayed_payment_loan_30_59_days, 0)) AS total_atraso_30_59,
    SUM(COALESCE(ld.number_times_delayed_payment_loan_60_89_days, 0)) AS total_atraso_60_89,
    SUM(COALESCE(ld.more_90_days_overdue, 0)) AS total_atraso_90_plus,

    SUM(COALESCE(ld.number_times_delayed_payment_loan_30_59_days, 0) + COALESCE(ld.number_times_delayed_payment_loan_60_89_days, 0) + COALESCE(ld.more_90_days_overdue, 0)) AS total_atrasos,
    AVG(COALESCE(ld.debt_ratio, 0)) AS media_debt_ratio,
    AVG(COALESCE(ld.using_lines_not_secured_personal_assets, 0)) AS media_uso_linhas_credito,
    SAFE_DIVIDE(SUM(COALESCE(ld.more_90_days_overdue, 0)), COUNT(DISTINCT o.loan_id)) AS inadimplencia_media_por_emprestimo
  FROM `projetoriscorelativo03.supercaja.user-info-csv` u
  LEFT JOIN `projetoriscorelativo03.supercaja.default-csv` d ON u.user_id = d.user_id
  LEFT JOIN `projetoriscorelativo03.supercaja.loans-outstanding-csv` o ON u.user_id = o.user_id
  LEFT JOIN `projetoriscorelativo03.supercaja.loans-detail-csv` ld ON u.user_id = ld.user_id
  GROUP BY u.user_id, u.age, u.last_month_salary, u.number_dependents, d.default_flag
)
SELECT
  *,
  CASE WHEN age < 25 THEN 'Jovem' WHEN age BETWEEN 25 AND 45 THEN 'Adulto' ELSE 'Sênior' END AS faixa_etaria,
  CASE 
    WHEN last_month_salary < 2000 THEN 'Baixa'
    WHEN last_month_salary BETWEEN 2000 AND 6000 THEN 'Média'
    ELSE 'Alta' END AS faixa_salarial,
  SAFE_DIVIDE(last_month_salary, NULLIF(number_dependents, 0)) AS salario_por_dependente,
  SAFE_DIVIDE(total_atrasos + media_debt_ratio * 10 + media_uso_linhas_credito * 10, qtd_loans_ativos + 1) AS indice_risco_credito
FROM base;
