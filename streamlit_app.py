import streamlit as st
import numpy as np

st.set_page_config(page_title="Calculadora de Risco de Crédito - Super Caja", layout="centered")

st.title("💸 Calculadora de Risco de Crédito - Super Caja")

st.markdown("""
    Preencha os dados do cliente abaixo para uma **análise de risco de crédito**.
    Nosso sistema estima a probabilidade do cliente ser um **Bom Pagador**, **Intermediário** ou **Mau Pagador**.
""")

# --- Entradas do Usuário ---
st.header("👤 Dados do Cliente")

col1, col2 = st.columns(2)

with col1:
    salario = st.number_input("💵 Salário mensal (R$)", min_value=0.0, step=100.0, format="%.2f", value=0.0)
    dependentes = st.number_input("👨‍👩‍👧‍👦 Número de dependentes", min_value=0, step=1, value=0)
    dividas_mensais = st.number_input("📉 Total de dívidas mensais (R$)", min_value=0.0, step=100.0, format="%.2f", value=0.0)

with col2:
    limite_credito = st.number_input("💳 Limite total de crédito disponível (R$)", min_value=0.0, step=100.0, format="%.2f", value=0.0)
    uso_credito = st.number_input("📊 Uso atual do crédito (R$)", min_value=0.0, step=100.0, format="%.2f", value=0.0)

st.subheader("🗓️ Histórico de Atrasos")
st.markdown("Informe o número de atrasos por período:")
atrasos_30 = st.number_input("Atrasos < 30 dias", min_value=0, step=1, value=0)
atrasos_60 = st.number_input("Atrasos entre 30 e 90 dias", min_value=0, step=1, value=0)
atrasos_90_mais = st.number_input("Atrasos 90+ dias", min_value=0, step=1, value=0)

# --- Cálculos das Variáveis ---
# Unificar os atrasos com pesos diferentes (maior peso para atrasos mais longos)
total_atrasos_ponderado = (atrasos_30 * 0.5) + (atrasos_60 * 1.0) + (atrasos_90_mais * 2.0)

salario_por_dependente = salario / dependentes if dependentes > 0 else salario if salario > 0 else 1 # Avoid division by zero
media_debt_ratio = dividas_mensais / salario if salario > 0 else 0.36
media_uso_linhas_credito = uso_credito / limite_credito if limite_credito > 0 else 0.62

# Indice de Risco de Crédito aprimorado
# Se não houver uso de crédito, o risco pode ser considerado menor, mas ainda presente
# O divisor 1 + uso_credito evita divisão por zero e suaviza o impacto
indice_risco_credito = total_atrasos_ponderado / (1 + uso_credito / 1000) if uso_credito > 0 else total_atrasos_ponderado * 0.5


# --- Cálculo do Score de Risco Total (com pesos simulados ajustados) ---
# Os pesos foram ajustados para que o score caia dentro das faixas desejadas (1-10)
# e para dar mais peso aos fatores que indicam maior risco.
score_total = (
    (indice_risco_credito * 2.0) +  # Atrasos têm um peso significativo
    (0.5 / (salario_por_dependente / 1000)) + # Salário por dependente inversamente proporcional ao risco
    (media_debt_ratio * 3.0) + # Dívidas mensais sobre salário
    (media_uso_linhas_credito * 1.5) # Uso do limite de crédito
)

# Normalizar o score para a escala de 1 a 10
# Este é um ajuste manual e pode precisar de mais refinamento com dados reais
# Para garantir que o score fique na faixa de 1-10, podemos usar uma função de mapeamento
# Ex: Min-Max Scaling (Score_final = 1 + (Score_bruto - Min_bruto) * (10 - 1) / (Max_bruto - Min_bruto))
# Para simplificar aqui, faremos um ajuste linear mais simples ou uma função sigmoidal se necessário
# Por enquanto, vamos limitar o score para não ultrapassar muito, e definir um mínimo.
score_total = max(1.0, min(10.0, score_total / 2.5)) # Ajuste para escalar para 1-10 aproximadamente

# --- Exibir Resultados ---
st.header("📊 Resultados da Análise")
st.markdown(f"**Score de Risco Total:** `{score_total:.2f}`")

if score_total <= 6:
    st.success("✅ **Resultado: Bom Pagador**")
    st.balloons()
elif 6 < score_total <= 8:
    st.warning("⚠️ **Resultado: Intermediário**")
elif score_total > 8: # Corrigido para 8 em vez de 8.5 para ficar claro com a divisão
    st.error("🚩 **Resultado: Mau Pagador**")

st.markdown("---")

# --- Explicações ---
with st.expander("ℹ️ Entenda como o score é calculado"):
    st.markdown("""
    O **Score de Risco Total** é uma métrica que avalia a probabilidade de um cliente honrar seus compromissos financeiros. Ele é calculado com base em diversos fatores, cada um com um peso específico na fórmula:

    * **Histórico de Atrasos (Ponderado):** Considera a gravidade dos atrasos, dando mais peso a dívidas mais antigas (90+ dias) do que a atrasos recentes (< 30 dias). Quanto mais e mais longos os atrasos, maior o risco.
    * **Salário Ajustado por Dependente:** Avalia a renda disponível do cliente em relação à sua carga familiar. Um salário alto com poucos dependentes indica menor risco.
    * **Proporção de Dívidas Mensais (Debt-to-Income Ratio):** Compara o total de dívidas mensais do cliente com sua renda. Uma proporção alta indica que grande parte do salário é comprometida com pagamentos.
    * **Uso das Linhas de Crédito (Credit Utilization):** Analisa o quanto do limite de crédito disponível o cliente está utilizando. Usar uma porcentagem muito alta do limite pode indicar dependência de crédito e maior risco.

    **Classificação do Score:**

    * **1 - 6:** **Bom Pagador** - Indivíduos com histórico financeiro sólido e baixa probabilidade de inadimplência.
    * **7 - 8:** **Intermediário** - Clientes com alguns pontos de atenção em seu perfil de crédito, mas que ainda podem ser considerados com risco moderado.
    * **8.5 - 10:** **Mau Pagador** - Perfil com alto risco de inadimplência, geralmente devido a um histórico de pagamentos inconsistente ou alta alavancagem financeira.

    **Importante:** Este é um modelo simulado para fins demonstrativos. Um modelo real de risco de crédito utiliza algoritmos mais complexos e uma base de dados muito maior para calibração e validação.
    """)

st.markdown("---")
st.info("Desenvolvido para Super Caja com Streamlit")
